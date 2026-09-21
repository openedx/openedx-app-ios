# Configuration Management

This document describes how the app is configured, both locally (build-time) and remotely
(runtime instance catalog). As of the instance-model work (`infra/03-remote-config-fetch`
onward), **JSON is the single configuration format used end-to-end** — there is no YAML
anywhere in the config pipeline.

## Why one format

Earlier revisions of this project used `config.yaml` for local/build-time config and were
briefly considering a second, separate JSON format for the remote instance directory (fetched
by URL, or bundled locally). That would have meant two independent parsers — `PyYAML` in the
build scripts and a JSON decoder in Swift — each with its own schema and casing convention,
kept in sync only by developer discipline. Nothing in the toolchain enforces that; a field
renamed or reshaped in one format's parser and not the other drifts silently until it breaks
at runtime.

Using JSON everywhere collapses that to one schema, one casing convention
(`UPPER_SNAKE_CASE`), and one thing to keep consistent when the schema changes.

## Local / build-time config: `config.json`

- Lives per environment: `default_config/dev/config.json`, `.../stage/config.json`,
  `.../prod/config.json`. (`config.yaml` has been deleted from all three — there is no YAML
  fallback.)
- Read at build time by `config_script/process_config.py` and `whitelabel.py`, which were
  rewritten to parse JSON instead of YAML. These scripts flatten the relevant keys into the
  build-time `Info.plist` that `Config.swift` reads at runtime — the Swift layer never parses
  `config.json` directly for these app-level keys.
- `default_config/config_settings.json` (which config directory/mapping the build uses) and
  each environment's `file_mappings.json` (which config file maps to which target) are JSON
  too — build-tooling plumbing, not app config, but kept in the same format as everything
  else so `default_config/` isn't half JSON, half YAML.
- Also holds `INSTANCES_CATALOG_URL` — the URL the app fetches the remote instance catalog
  from at launch — and a bundled fallback catalog for offline/first-run use.
- **Temporary compatibility bridge**: `Config.swift` still hard-requires `API_HOST_URL`,
  `SSO_URL`, `SSO_FINISHED_URL`, and `OAUTH_CLIENT_ID` at the top level, because it's the only
  `ConfigProtocol` implementation wired into DI until `InstanceAwareConfig` lands (PR-9).
  These four keys are mirrored from the example/default instance and are explicitly commented
  as removable once PR-9 ships. Don't add new app-level keys here without checking whether
  they actually belong on `Instance` instead.

## Upgrading from a pre-JSON checkout

If your `config_directory` still has an old `config.yaml` and no `config.json`,
`process_config.py` fails the build with a message naming both files rather than a generic
"config files not found." Convert with:

```
python3 config_script/yaml_to_json_config.py path/to/config.yaml
```

This writes the equivalent `config.json` next to it (structure carries over as-is — the
schema didn't reshape moving formats, just casing, which was already consistent). Delete the
old `.yaml` file once you've checked the output in. The same script converts
`config_settings.yaml`/`file_mappings.yaml` if you're upgrading from before those were
converted too.

## Remote instance catalog

- `InstanceApiService` does a plain `URLSession` GET against `INSTANCES_CATALOG_URL` — not
  routed through the authenticated Alamofire/API stack, since this is a fixed, anonymous,
  external endpoint. It returns raw JSON bytes; all parsing happens in `InstancesConfig`.
- `InstanceConfigLoader.load()` merge policy (offline-safe):
  - Baseline = last cached successful fetch, else the bundled catalog, else empty.
  - Every launch awaits a live fetch. A non-empty response wholesale-replaces the baseline and
    becomes the new cache.
  - A failed fetch, or a fetch that succeeds with zero instances, leaves the baseline
    untouched — a reachable-but-empty catalog must never wipe a good cache.
- Both the bundled catalog and the remote catalog are parsed through the same `Instance` /
  `InstancesConfig` `Codable` model — one schema for both sources, not two.

## Schema conventions

- All keys this project owns are uniformly `UPPER_SNAKE_CASE` (`NAME`, `COLOR`, `THEME.LIGHT`
  / `DARK`, `LOGO_URL`, `HEADER_BACKGROUND_URL`, etc.) across local and remote — a shared
  instance schema reads the same regardless of which source parsed it.
- A remote payload that arrives snake_case or mixed-case is normalized on the way in,
  key-by-key, at every nesting depth. Anything with no explicit mapping passes through
  unchanged.
  - **Known naming debt**: this normalization function is still called
    `remoteToYAMLKeyMap`, a holdover from before YAML was retired — it no longer maps to
    YAML anything. Rename it (e.g. `remoteKeyNormalizationMap`) as part of the PR-9 cleanup
    below, so the name doesn't mislead anyone reading the schema fresh.
- Palette-internal field names (`accent_color`, etc.) are deliberately left alone — that's the
  Theme module's own contract, not this schema's to rename.

## What's explicitly out of scope today

- Wiring `InstanceConfigLoader` into the app launch sequence / DI — PR-9.
- Instance picker / selection UI — PR-10.
- Removing the temporary `Config.swift` bridge keys once `InstanceAwareConfig` exists, and
  renaming `remoteToYAMLKeyMap` — PR-9.
- Removing the dead `ConfigProtocol.instancesCatalogURL` property, once nothing references it.

## Summary

| Concern | Format | Owner |
|---|---|---|
| Local/build-time app config | JSON (`config.json`) | `process_config.py` / `whitelabel.py` → build-time plist |
| Build-tooling plumbing (`config_settings.json`, `file_mappings.json`) | JSON | `process_config.py` / `whitelabel.py` |
| Bundled fallback instance catalog | JSON | `InstancesConfig` (`Codable`) |
| Remote instance catalog | JSON (fetched from `INSTANCES_CATALOG_URL`) | `InstanceApiService` + `InstanceConfigLoader` |

No YAML remains anywhere in this pipeline.
