# The LMS Directory

A build of this app normally talks to one Open edX site, named in
`config.yaml`. With the LMS Directory on, it instead shows a list of platforms,
lets the learner pick one, re-themes to it and signs in against it.

Off by default. With `ENABLED: false` nothing in this document applies and the
app behaves exactly as it always has.

## Where the list comes from

Two ways, and the config decides which:

```yaml
LMS_DIRECTORY:
  ENABLED: true
  DIRECTORY_URL: "https://example.com/lms_directory.json"   # a document, on the web
  DIRECTORY_FILE: ""
```

```yaml
LMS_DIRECTORY:
  ENABLED: true
  DIRECTORY_URL: ""
  DIRECTORY_FILE: "lms_directory.json"                      # a document, in the app
```

`DIRECTORY_URL` is fetched once, and whatever comes back is the document — the
address can be anything you can serve a file from. If both `DIRECTORY_URL` and
`DIRECTORY_FILE` are set the file wins: a build that ships its own copy has
deliberately opted out of the network, and quietly preferring a remote list would
undo that.

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
        "feedback_email": "support@northwind.edu"
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

### Optional

Everything else, `api` included. Omit a key and the app uses its own default, so
the smallest useful entry is `id`, `title`, `description`, `short_description`
and `base_url`. `provider` is optional too; its `name` is shown above the list.

`visibility` and `featured` are accepted and ignored — every platform in the
file is shown, in the order the file lists them.

### OAuth

A multi-instance app carries **one** OAuth client id of its own — the one in
`config.yaml` — and each platform registers that id in its own OAuth
Applications table, ideally restricted to the app's redirect scheme. The
directory is not where per-platform credentials live, so `api` can be omitted
entirely and usually should be.

`api` is still read when present: `host_url` for a platform whose API lives at a
different address than the one the learner picked, `oauth_client_id` for a
platform that insists on its own, and `feedback_email` for the support address.
A platform naming its own client id overrides the app's for that platform only.

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

**Or edit it somewhere.** Any tool that emits the shape above will do, and one
that exists today is <https://openedx-lms.stepanok.com>: a form for adding
platforms and uploading their logos and sign-in artwork, which publishes the
document at a URL and also exports a `.zip` of the document with its image
fields already rewritten to file names, plus the images themselves — the bundle
the offline case needs.

That is somebody's **unofficial** tool. It is not part of Open edX, not
maintained by this project, and nothing here depends on it. The app reads a
document; where the document came from is not its business.
