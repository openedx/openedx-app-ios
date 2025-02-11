# Configuration Management

This documentation provides a comprehensive solution for integrating and managing configuration files in OpenEdx iOS project.

## Features

- **Build Phase Script Integration:** Adds a script to the Build Phase of Xcode. It calls the Xcode build phase run script, which takes care of the virtual environment and installing dependencies and executes a Python script `process_config.py` with `$CONFIGURATION` and `scheme_mappings` argument.
- **Python Script for Configuration:** Utilizes `process_config.py` for:
  - Adding essential keys to `Info.plist` (e.g., Facebook, Microsoft keys).
  - Creating `GoogleServices.plist` with Firebase keys.
  - Generating `config.plist` from `ios.yaml` and `shared.yaml`.

Inside `Config.swift`, parsing and populating relevant keys and classes are done, e.g. `AgreementConfig.swift` and `FirebaseConfig.swift`.

## Getting Started

### Configuration Setup

Edit a `config_settings.yaml` in the `default_config` folder. It should contain data as follows:

```yaml
config_directory: '{path_to_config_folder}'
config_mapping:
  prod: 'prod'
  stage: 'stage'
  dev: 'dev'
# These mappings are configurable, e.g. dev: 'prod_test'
```

- `config_directory` provides the path of the config directory.
- `config_mappings` provides mappings that can be utilized to map the Xcode build scheme to a defined folder within the config directory, and it will be referenced.

### Configuration Files

Two main configuration files are used: `ios.yaml` and `shared.yaml`, placed under the folder defined in `config_mappings`. Additionally, a `mappings.yaml` file is required in the same directory, specifying the YAML files to be processed. Its structure is as follows:

```yaml
ios:
    files:
      - {file_one.yaml}
      - {file_two.yaml}
```

- `ios.yaml` will contain config data specific to iOS, e.g., Firebase keys, Facebook keys, etc.
- `shared.yaml` will contain config data that is shared, e.g., `API_HOST_URL`, `OAUTH_CLIENT_ID`, `TOKEN_TYPE`, etc.

## Future Support

- To add config related to some other service, create a class, e.g. `ServiceNameConfig.swift`, to be able to populate related fields.
- Create an `extension` to `Config.swift` to be able to add the newly created service as a variable to the main Config.
- If needed, make a protocol to be referenced inside the scope of `ConfigProtocol` so that the config is available using `ConfigProtocol` service.

Example:

```swift
private let key = "KEY"
extension Config {
    public var serviceNameConfig: ServiceNameConfig {
        return ServiceNameConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}
```

## Note

If Firebase Configuration is provided the updated `FirebaseCrashlytics` build phase script extracts `googleAppID` from the newly generated `GoogleService-Info.plist` and runs the Crashlytics script with the provifing id.

## Examples of Config Files

`ios.yaml`:

```yaml
OAUTH_CLIENT_ID: ''

FIREBASE:
  ENABLED: true
  API_KEY: "testApiKey"
  BUNDLE_ID: "testBundleID"
  CLIENT_ID: "testClientID"
  DATABASE_URL: "https://test.database.url"
  GCM_SENDER_ID: "testGCMSenderID"
  GOOGLE_APP_ID: "testGoogleAppID"
  PROJECT_ID: "testProjectID"
  REVERSED_CLIENT_ID: "testReversedClientID"
  STORAGE_BUCKET: "testStorageBucket"
  ANALYTICS_SOURCE: "firebase"

MICROSOFT:
  ENABLED: true
  CLIENT_ID: "microsoftAppID"
```

`shared.yaml`:

```yaml
API_HOST_URL: "https://www.example.com"
FEEDBACK_EMAIL_ADDRESS: "example@mail.com"
TOKEN_TYPE: "JWT"

AGREEMENT_URLS:
  PRIVACY_POLICY_URL: "https://www.example.com/privacy"
  TOS_URL: "https://www.example.com/tos"

# Features
WHATS_NEW_ENABLED: false
```

The `default_config` directory is added to the project to provide an idea of how to write config YAML files.
