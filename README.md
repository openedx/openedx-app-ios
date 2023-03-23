# EducationX iOS

Modern vision of the mobile application for the Open EdX platform from Raccoon Gang.

## Building
1. Check out the source code:

        git clone https://github.com/raccoongang/educationx-app-ios.git

2. Navigate to the project folder and run ``pod install``.

3. Open ``NewEdX.xcworkspace``.

4. Ensure that the ``NewEdXDev`` or ``NewEdXProd`` scheme is selected.

5. Configure the [``Environment.swift`` file](https://github.com/raccoongang/new-edx-app-ios/blob/main/NewEdX/Environment.swift) with URLs and OAuth credentials for your Open edX instance.

6. Click the **Run** button.

## Roadmap
Please feel welcome to develop any of the suggested features below and submit a pull request.

- Migrate to the new APIs
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
