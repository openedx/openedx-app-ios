// swift-tools-version:5.9

// Command-line tools used by the Xcode build phases, fastlane and CI.
// Each one is the prebuilt release binary of an exact version, verified by its checksum.
// After changing a version here, run `make bootstrap` to fetch it.

import PackageDescription

let package = Package(
    name: "BuildTools",
    targets: [
        .binaryTarget(
            name: "swiftlint",
            url: "https://github.com/realm/SwiftLint/releases/download/0.57.0/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "a1bbafe57538077f3abe4cfb004b0464dcd87e8c23611a2153c675574b858b3a"
        ),
        .binaryTarget(
            name: "swiftgen",
            url: "https://github.com/SwiftGen/SwiftGen/releases/download/6.6.3/swiftgen-6.6.3.artifactbundle.zip",
            checksum: "caf1feaf93dd32bc5037f0b6ded8d0f4fe28ab5d2f6e5c3edf2572006ba0b7eb"
        ),
        .binaryTarget(
            name: "mockolo",
            url: "https://github.com/uber/mockolo/releases/download/2.5.0/mockolo.artifactbundle.zip",
            checksum: "107825279e5c7c2f8ef021320d8054e0b36fcb9e634d02d2ff1bde6d8b460722"
        )
    ]
)
