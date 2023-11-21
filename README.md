# EducationX iOS

Modern vision of the mobile application for the Open EdX platform from Raccoon Gang.

[Documentation](Documentation/Documentation.md)

## Building
1. Check out the source code:

        git clone https://github.com/raccoongang/educationx-app-ios.git

2. Navigate to the project folder and run ``pod install``.

3. Open ``OpenEdX.xcworkspace``.

4. Ensure that the ``OpenEdXDev`` or ``OpenEdXProd`` scheme is selected.

5. Configure `config_settings.yaml` inside `default_config` and `config.yaml` inside sub direcroties to point to your OpenEdx configuration [Configuration Docuementation](./Documentation/CONFIGURATION_MANAGEMENT.md)

6. Click the **Run** button.

## API plugin
This project uses custom APIs to improve performance and reduce the number of requests to the server.

You can find the plugin with the API and installation guide [here](https://github.com/raccoongang/mobile-api-extensions).

## License
The code in this repository is licensed under the Apache-2.0 license unless otherwise noted.

Please see [LICENSE](https://github.com/raccoongang/educationx-app-ios/blob/main/LICENSE) file for details.
