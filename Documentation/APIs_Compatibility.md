# APIs Compatibility

This documentation offers guidance on a workaround for utilizing mobile APIs with earlier versions of Open edX releases.

In December 2023, the [FC-0031 project](https://github.com/openedx/edx-platform/issues/33304) introduced new APIs, and the Open edX mobile apps were transitioned to utilize them.

If your platform version is older than December 2023, follow the instructions below:

1. Setup the [mobile-api-extensions](https://github.com/raccoongang/mobile-api-extensions) plugin to your platform.
The Plugin contains extended Open edX APIs for mobile applications.
2. Roll back the modifications that brought in the new APIs [3bca8bf](https://github.com/openedx/openedx-app-ios/commit/3bca8bfa994163635e1128f0404007c6d0d4761f).
