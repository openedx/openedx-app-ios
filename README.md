# EducationX iOS

Modern vision of the mobile application for the Open EdX platform from Raccoon Gang.

[Documentation](Documentation/Documentation.md)

## Building
1. Check out the source code:

        git clone https://github.com/raccoongang/educationx-app-ios.git

2. Navigate to the project folder and run ``pod install``.

3. Run ``make whitelabel``. This will create theme/credential files based on example files. Take note of the output.

4. Open ``OpenEdX.xcworkspace``.

5. Ensure that the ``OpenEdXDev`` or ``OpenEdXProd`` scheme is selected.

6. Configure the Environment.swift file created in step 3 with URLs and OAuth credentials for your Open edX instance.

7. If you're preparing the app for a production release and need to theme it, customize the package assets as directed by the output of step 3.

7. Click the **Run** button.

## API plugin
This project uses custom APIs to improve performance and reduce the number of requests to the server.

You can find the plugin with the API and installation guide [here](https://github.com/raccoongang/mobile-api-extensions).

## Roadmap
Please feel welcome to develop any of the suggested features below and submit a pull request.

- ✅ ~~Migrate to the new APIs~~
- ✅ ~~New Navigation~~
- ✅ ~~Analytics and Crashlytics~~
- Recent searches
- Migrate to the Olive and JWT token
- UnAuth User mode
- Prerequisite course
- Prerequisite sections
- Scorm XBlocks
- Native Programs
- New discovery (catalog)
- E-Commerce

## License
The code in this repository is licensed under the AGPL v3 license unless otherwise noted.

Please see [LICENSE](https://github.com/raccoongang/educationx-app-ios/blob/main/LICENSE) file for details.
