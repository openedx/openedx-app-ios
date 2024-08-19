# Open edX iOS

Modern vision of the mobile application for the Open edX platform from Raccoon Gang.

[Documentation](Documentation/Documentation.md)

## Building
1. Check out the source code:

        git clone https://github.com/openedx/openedx-app-ios.git

2. Navigate to the project folder and run ``pod install``.

3. Open ``OpenEdX.xcworkspace``.

4. Ensure that the ``OpenEdXDev``, ``OpenEdXStage`` or ``OpenEdXProd`` scheme is selected.

5. Configure `config_settings.yaml` inside `default_config` and `config.yaml` inside sub direcroties to point to your OpenEdx configuration [Configuration Documentation](./Documentation/CONFIGURATION_MANAGEMENT.md)

6. Click the **Run** button.

## Translations
### Getting translations for the app
Translations aren't included in the source code of this repository as of [OEP-58](https://docs.openedx.org/en/latest/developers/concepts/oep58.html). Therefore, they need to be pulled before testing or publishing to App Store.

Before retrieving the translations for the app, we need to install the requirements listed in the requirements.txt file located in the i18n_scripts directory. This can be done easily by running the following make command:
```bash
make translation_requirements
```

Then, to get the latest translations for all languages use the following command:
```bash
make pull_translations
```

This command runs [`atlas pull`](https://github.com/openedx/openedx-atlas) to download the latest translations files from the [openedx/openedx-translations](https://github.com/openedx/openedx-translations) repository. These files contain the latest translations for all languages. In the [openedx/openedx-translations](https://github.com/openedx/openedx-translations) repository each language's translations are saved as a single file e.g. `I18N/I18N/uk.lproj/Localization.strings` ([example](https://github.com/openedx/openedx-translations/blob/6448167e9695a921f003ff6bd8f40f006a2d6743/translations/openedx-app-ios/I18N/I18N/uk.lproj/Localizable.strings)). After these are pulled, each language's translation file is split into the App's modules e.g. `Discovery/Discovery/uk.lproj/Localization.strings`.
   
  After this command is run the application can load the translations by changing the device (or the emulator) language in the settings.

**Note:** This command modifies the XCode project files which fails the build so it's required to clean the translations files before committing using the following command:

```
make clean_translations
```

### Using custom translations

By default, the command `make pull_translations` runs [`atlas pull`](https://github.com/openedx/openedx-atlas) with no arguments which pulls transaltions from the [openedx-translations repository](https://github.com/openedx/openedx-translations).

You can use custom translations on your fork of the openedx-translations repository by setting the following configuration parameters:

- `--revision` (default: `"main"`): Branch or git tag to pull translations from.
- `--repository` (default: `"openedx/openedx-translations"`): GitHub repository slug. There's a feature request to [support GitLab and other providers](https://github.com/openedx/openedx-atlas/issues/20).

Arguments can be passed via the `ATLAS_OPTIONS` environment variable as shown below:
``` bash
make ATLAS_OPTIONS='--repository=<your-github-org>/<repository-name> --revision=<branch-name>' pull_translations
```
Additional arguments can be passed to `atlas pull`. Refer to the [atlas documentations ](https://github.com/openedx/openedx-atlas) for more information.

### How to translate the app
	
Translations are managed in the [open-edx/openedx-translations](https://app.transifex.com/open-edx/openedx-translations/dashboard/) Transifex project.

To translate the app join the [Transifex project](https://app.transifex.com/open-edx/openedx-translations/dashboard/) and add your translations to the [`openedx-app-ios`](https://app.transifex.com/open-edx/openedx-translations/openedx-app-ios/) resource.

Once the resource is both 100% translated and reviewed the [Transifex integration](https://github.com/apps/transifex-integration) will automatically push it to the [openedx-translations](https://github.com/openedx/openedx-translations) repository and developers can use the translations in their app.


## API
This project targets on the latest Open edX release and rely on the relevant mobile APIs.

If your platform version is older than December 2023, please follow the instructions to use the [API Plugin](./Documentation/APIs_Compatibility.md).

## License
The code in this repository is licensed under the Apache-2.0 license unless otherwise noted.

Please see [LICENSE](https://github.com/openedx/openedx-app-ios/blob/main/LICENSE) file for details.
