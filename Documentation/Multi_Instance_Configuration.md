# Multi-Instance Configuration

How a single app build serves multiple Open edX platforms ("instances" / Learning Sites):
how the feature behaves, and the two JSON sources that drive it — the bundled `config.json`
and the remote instance catalog.

## How the feature works

An **instance** is one Open edX platform the app can log into: its own host, OAuth client,
branding, and feature flags.

- **One instance in the resolved catalog** → the app behaves like a classic single-tenant
  build. No picker, no "Change" link on Sign In, no Learning Sites card in Settings — it's
  auto-selected on launch. Same code, not a separate build flag.
- **Multiple instances** → the user picks one from the Learning Sites screen, can be
  logged into several at once, and switches between them without re-authenticating.

Selecting/switching an instance (`InstanceStore` → `.instanceDidChange`) propagates through
every layer below the UI, so nothing leaks between two instances on the same device:
- **Networking** — `RequestInterceptor` re-targets requests at the selected instance's host;
  token refresh uses its `API_HOST_URL`/`OAUTH_CLIENT_ID`.
- **Local storage** — UserDefaults keys and Keychain entries are namespaced per instance.
- **CoreData & downloads** — records carry an `instanceKey`; downloaded files live under
  `Documents/{instanceKey}/{userId}_Files/`.
- **Sessions** — `InstanceSessionManager` can switch to, or log out of, one instance's session
  without touching any other.
- **Config** — `InstanceAwareConfig` layers the selected `Instance` over the app-level
  `Config`: an instance-carried field wins when set and non-nil, everything else falls back to
  the app-level config. A single-instance deployment (no `Instance` selected yet) keeps
  working off the plain app config unchanged.
- **Theming** — accent color, logo, and header image apply app-wide on instance switch,
  logout, and app launch, not just on Sign In.

On launch, `AppDelegate` awaits the instance catalog (see below) before routing, so the first
screen shown is always based on the real catalog, never a placeholder.

---

## 1. Bundled config: `config.json`

One file per environment: `default_config/dev/config.json`, `.../stage/config.json`,
`.../prod/config.json`. It does two unrelated jobs, read two different ways:

| | App-level keys (everything except `INSTANCES`/`INSTANCES_CATALOG_URL`) | `INSTANCES` / `INSTANCES_CATALOG_URL` |
|---|---|---|
| Read by | `Config.swift`, at runtime | `InstanceConfigLoader`, at runtime |
| Read from | Build-time `Info.plist` (flattened in by `config_script/process_config.py`/`whitelabel.py`) | The `config.json` file itself, bundled as a resource (`Bundle.main.url(forResource: "config", withExtension: "json")`) |

So changing an app-level key needs a rebuild; changing `INSTANCES` doesn't strictly require
touching Info.plist generation at all — the JSON file ships as-is and is parsed directly.

### App-level keys

| Key | Purpose |
|---|---|
| `FIREBASE` | Analytics/crash/cloud-messaging config (`ENABLED`, `API_KEY`, `PROJECT_ID`, etc). |
| `FACEBOOK`, `MICROSOFT`, `GOOGLE`, `APPLE_SIGNIN` | Third-party sign-in `ENABLED` flag + provider credentials. |
| `BRANCH` | Deep-link provider `ENABLED` flag + `KEY`. |
| `URI_SCHEME` | The app's custom URL scheme. |
| `APP_STORE_ID` | For the "rate the app" / App Store links. |
| `INSTANCES_CATALOG_URL` | URL the remote catalog is fetched from. Empty string = bundled catalog only, no remote fetch attempted. |
| `API_HOST_URL`, `SSO_URL`, `SSO_FINISHED_URL`, `OAUTH_CLIENT_ID` | **Compatibility bridge** — `Config.swift` still `fatalError()`s at launch if these are missing. Meant to be removed once `InstanceAwareConfig` took over, but that cleanup hasn't happened yet — still required today. Don't remove without confirming a single-instance build still resolves fine without them. |
| `INSTANCES` | Array of instance objects — see schema below. |

### `INSTANCES[]` schema

Only `NAME`, `API_HOST_URL`, and `OAUTH_CLIENT_ID` are required; everything else falls back to
a default. A malformed entry is dropped, not half-populated. All keys are `UPPER_SNAKE_CASE`.

| Key | Type | Required | Notes |
|---|---|---|---|
| `KEY` | string | no | Machine-readable id. Falls back to a slugified `NAME`. |
| `NAME` | string | **yes** | |
| `INSTANCE_NAME` | `{locale: string}` | no | Localized display name; falls back to `en`, then `NAME`. |
| `API_HOST_URL` | URL string | **yes** | |
| `OAUTH_CLIENT_ID` | string | **yes** | |
| `SSO_URL` / `SSO_URL_SUCCESSFUL_LOGIN` | URL string | no | |
| `ENVIRONMENT_DISPLAY_NAME` | string | no | |
| `IS_SWITCH_INSTANCE_LOGIN_ENABLED` | bool | no | Default `false`. |
| `UI_COMPONENTS` | object | no | Per-instance feature toggles (course progress, nested lists, SAML SSO button, etc). |
| `THEME` | object | no | See below. |
| `FEEDBACK_EMAIL_ADDRESS` | string | no | |
| `SSO_BUTTON_TITLE` | `{locale: string}` | no | Falls back to the app-wide default. |
| `EXPERIMENTAL_FEATURES` | object | no | Currently just app-level downloads enablement. |
| `AGREEMENT_URLS`, `TOKEN_TYPE`, `DISCOVERY`, `PROGRAM`, `FAQ_URL`, `PLATFORM_NAME`, `DASHBOARD` | — | no | Same shape as their app-level equivalents; instance value wins when set. |

**`THEME`:**

```json
"THEME": {
    "LIGHT":  { "accent_color": "#3C68FF" },
    "DARK":   { "accent_color": "#1C355E" },
    "LOGO_URL": "exampleInstanceAppLogo",
    "HEADER_BACKGROUND_URL": "https://.../header.png",
    "ROUNDED_CORNERS_STYLE": true,
    "BUTTON_CORNERS_RADIUS": 8.0
}
```
- `LIGHT`/`DARK`: per-field palette overrides, fed to `ThemeColorSet.derived(fromHex:light:dark:)`. Omit both and the palette derives from the instance's top-level `COLOR`.
- `LOGO_URL` / `HEADER_BACKGROUND_URL`: a remote URL renders via `AsyncImage`; a bundled asset name resolves via `UIImage(named:)`; omit for the app default.

### How to use it

- Add/edit instances directly in the `INSTANCES` array of the environment's `config.json` —
  this is what a fresh install with no cached remote catalog (or `INSTANCES_CATALOG_URL` unset)
  actually shows.
- Editing an `INSTANCES` entry or `INSTANCES_CATALOG_URL` doesn't need an Info.plist rebuild;
  editing any other app-level key does (it's baked in at build time).

---

## 2. Remote catalog (fetched from `INSTANCES_CATALOG_URL`)

`InstanceApiService` does a plain, unauthenticated `URLSession` GET (10s timeout,
`reloadIgnoringLocalCacheData`) against `INSTANCES_CATALOG_URL` — not routed through the app's
authenticated API stack, since it's a fixed external endpoint. `InstanceConfigLoader` decides
what to do with the result:

- Baseline = last cached successful fetch, else the bundled catalog, else empty.
- A non-empty response wholesale-**replaces** the baseline and becomes the new cache.
- A failed fetch, or one that succeeds with zero instances, **leaves the baseline untouched** —
  a reachable-but-empty catalog must never wipe a good cache.

### Accepted shapes

Either a bare array, or an object wrapped under `instances`/`INSTANCES`:

```json
[ { "key": "...", ... }, { "key": "...", ... } ]
```
```json
{ "instances": [ { "key": "...", ... } ] }
```

### Keys

Same underlying schema as the bundled `INSTANCES[]` entries above — the payload is decoded
through the exact same `Instance` model — but the remote source is expected in `snake_case`
and normalized key-by-key before parsing. Only the keys below are actually remapped; anything
else passes through **unchanged** (so an unmapped `snake_case` key won't apply — it has to be
added to the normalization map first):

| Remote key (`snake_case`) | Normalized to |
|---|---|
| `key`, `name`, `color` | `KEY`, `NAME`, `COLOR` |
| `instance_name` | `INSTANCE_NAME` |
| `oauth_client_id` | `OAUTH_CLIENT_ID` |
| `api_host_url` | `API_HOST_URL` |
| `sso_url` | `SSO_URL` |
| `sso_url_successful_login` | `SSO_URL_SUCCESSFUL_LOGIN` |
| `environment_display_name` | `ENVIRONMENT_DISPLAY_NAME` |
| `is_switch_instance_login_enabled` | `IS_SWITCH_INSTANCE_LOGIN_ENABLED` |
| `ui_components` | `UI_COMPONENTS` |
| `course_dropdown_navigation_enabled`, `course_unit_progress_enabled`, `login_registration_enabled`, `saml_sso_login_enabled`, `saml_sso_default_login_button` | (nested under `UI_COMPONENTS`) |
| `theme`, `light`, `dark`, `logo_url`, `header_background_url` | `THEME`, `LIGHT`, `DARK`, `LOGO_URL`, `HEADER_BACKGROUND_URL` |

Fields not in this table (`FEEDBACK_EMAIL_ADDRESS`, `SSO_BUTTON_TITLE`,
`EXPERIMENTAL_FEATURES`, `AGREEMENT_URLS`, `TOKEN_TYPE`, `DISCOVERY`, `PROGRAM`, `FAQ_URL`,
`PLATFORM_NAME`, `DASHBOARD`, corner-style keys) aren't in the normalization map yet — send
them already `UPPER_SNAKE_CASE` if you need them from the remote source today.

### How to use it

- Point `INSTANCES_CATALOG_URL` (an app-level key in `config.json`) at an endpoint returning
  one of the two shapes above.
- The endpoint is anonymous/public — no auth headers are sent — so don't put anything in it
  you wouldn't want unauthenticated.
- Test a change by clearing the app (fresh install) to drop the cache, or by returning an
  empty catalog to confirm the fallback-to-baseline behavior instead of a reset.
