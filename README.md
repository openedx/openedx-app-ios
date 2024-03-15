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

## API
This project targets on the latest Open edX release and rely on the relevant mobile APIs.

If your platform version is older than December 2023, please follow the instructions to use the [API Plugin](./Documentation/APIs_Compatibility.md).

## License
The code in this repository is licensed under the Apache-2.0 license unless otherwise noted.

Please see [LICENSE](https://github.com/openedx/openedx-app-ios/blob/main/LICENSE) file for details.
