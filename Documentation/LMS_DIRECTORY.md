# The LMS Directory

A build of this app normally talks to one Open edX site, named in
`config.yaml`. With the LMS Directory on, it instead shows a list of platforms,
lets the learner pick one, re-themes to it and signs in against it.

Off by default. With `ENABLED: false` nothing in this document applies and the
app behaves exactly as it always has.

## Where the list comes from

Three ways, and the config decides which:

```yaml
LMS_DIRECTORY:
  ENABLED: true
  DIRECTORY_URL: "https://example.com/lms_directory.json"   # a document, on the web
  DIRECTORY_FILE: ""
  DIRECTORY_MODE: ""
```

```yaml
LMS_DIRECTORY:
  ENABLED: true
  DIRECTORY_URL: ""
  DIRECTORY_FILE: "lms_directory.json"                      # a document, in the app
  DIRECTORY_MODE: ""
```

```yaml
LMS_DIRECTORY:
  ENABLED: true
  DIRECTORY_URL: "https://registry.example.com"             # a live registry
  DIRECTORY_FILE: ""
  DIRECTORY_MODE: ""
```

**The address is what decides.** A `DIRECTORY_URL` ending in `.json` is read as a
*document*: one file, fetched once, that already contains every platform and its
branding. Anything else is treated as the base URL of a *service* that answers
`/api/v1/directory`. If both `DIRECTORY_URL` and `DIRECTORY_FILE` are set, the
file wins — a build that ships its own copy has deliberately opted out of the
network, and quietly preferring a remote list would undo that.

`DIRECTORY_MODE` is `""`, `"search"` or `"curated"`, and only means anything for
a live registry: it overrides what the server would otherwise say. A document is
always a fixed list, so the key is ignored for one.

## What a document looks like

One JSON file. This is the whole format:

```json
{
  "version": 1,
  "provider": {
    "name": "Northwind Education Group",
    "tagline": "Five campuses, one app",
    "logo_url": null
  },
  "platforms": [
    {
      "id": "1",
      "title": "Northwind College",
      "description": "The main campus, offering undergraduate programmes.",
      "short_description": "Main campus",
      "base_url": "https://learn.northwind.edu",
      "logo_url": "https://cdn.northwind.edu/logo.png",
      "accent_color": "#002545",
      "visibility": "public",
      "featured": false,
      "api": {
        "host_url": "https://learn.northwind.edu",
        "feedback_email": "support@northwind.edu",
        "oauth_client_id": "PASTE_THE_MOBILE_OAUTH_CLIENT_ID"
      },
      "feature_flags": {
        "pre_login_discovery": false,
        "unknown_units_mode": "webview"
      },
      "theme": {
        "accent_color_dark": "#4989bf",
        "login_background_url": "https://cdn.northwind.edu/signin.png",
        "logo_upload_url": null
      },
      "ui_components": {
        "course_unit_progress_enabled": true,
        "course_dropdown_navigation_enabled": true,
        "pre_login_experience_enabled": false
      },
      "dashboard": { "type": "list" }
    }
  ]
}
```

### Required

| field | what it is |
| --- | --- |
| `version` | `1`. The only version there is. |
| `platforms[]` | At least one. An empty list gives the learner nothing to pick. |
| `id` | Unique within the file. A string, even when it looks like a number. |
| `title` | Shown in the list and on the sign-in screen. |
| `description` / `short_description` | Long and one-line blurbs. |
| `base_url` | The Open edX site. Must be `https` in a shipped build. |
| `api.host_url` | Usually the same as `base_url`. |
| `api.oauth_client_id` | The site's **mobile** OAuth client id. Sign-in fails without the right one. |
| `api.feedback_email` | May be `""`. |

### Optional

Everything else. Omit a key and the app uses its own default, so the smallest
useful entry is `id`, `title`, `description`, `short_description`, `base_url`
and `api`. `provider` is optional too; its `name` is shown above the list.

`visibility` and `featured` come from the registry's own model and are ignored
when reading a document — every platform in the file is shown.

## Images

Every image field takes either of two things, and the value itself says which:

- something starting with `http://` or `https://` is downloaded;
- anything else is the **name of a file shipped with the app**.

So `"logo_url": "https://cdn.northwind.edu/logo.png"` is fetched, and
`"logo_url": "northwind-logo.png"` is looked up in the app bundle. That is what makes a
fully offline build possible: put the images next to the document, refer to them
by name, and the app never asks the network for a picture.

## Shipping the document inside the app

1. Drag the document and its images into the Xcode project.
2. Tick **Copy items if needed** and your app target.
3. Check they appear under **Build Phases → Copy Bundle Resources**.

Then set `DIRECTORY_FILE` to the file name and leave `DIRECTORY_URL` empty. The
app now works on a device that has never been online.

## Where to get a document

**Write it by hand.** For a handful of platforms this is the honest answer —
it is one JSON file, and the example above is a working template.

**Or generate one.** Any tool that emits the shape above will do. One that
exists today is the LMS Registry at <https://openedx-lms.stepanok.com> — a web
app where you add platforms through a form, upload their logos and sign-in
artwork, and it publishes the document at `/p/<your-org>/directory.json`. It also
exports a `.zip` holding the document with its image fields already rewritten to
file names plus every image beside it, which is exactly the bundle the offline
case needs.

Be clear about what that is: an **unofficial, experimental tool**, not part of
Open edX, not maintained by this project, and not required by this app. Its
public source lives in the archived
[openedx-unsupported/openedx-mobile-site-registry](https://github.com/openedx-unsupported/openedx-mobile-site-registry).

Nothing in this app knows about that tool, or any other. It reads a document;
where the document came from is not its business.

## The live-registry alternative

Pointing `DIRECTORY_URL` at a service instead makes the app ask it for the list,
which is what a public catalog of many unrelated platforms needs — search, and
platforms appearing without a new app release. A service must answer:

- `GET /api/v1/config` — `{"directory_mode": "search"|"curated", "provider_name": …}`
- `GET /api/v1/directory` — `{"items": [ … ]}`, the list
- `GET /api/v1/directory/{id}` — one platform, the same shape as a `platforms[]`
  entry above

`GET /api/v1/directory/{id}` and a document's `platforms[]` entries are the same
shape on purpose: a client that reads one already reads the other.

Reporting a platform ("Report this LMS" in the profile) needs a live registry to
post to, and is offered only when the registry says it is in `search` mode — an
open catalog is the only place where a stranger can list something nobody has
vouched for. A build reading a document never shows it.
