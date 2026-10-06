#!/bin/bash

# Script to generate mocks using Mockolo
# Usage: ./generateMockoloMocks.sh

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "${DIR}"

MOCKOLO="${DIR}/BuildTools/bin/mockolo"

# Check if mockolo is installed
if [[ ! -x "${MOCKOLO}" ]]; then
    echo "Error: mockolo is not installed"
    echo "Install it with: make bootstrap"
    exit 1
fi

echo "Generating mocks with Mockolo..."

# Core module
echo "Generating Core mocks..."
"${MOCKOLO}" \
    --sourcedirs "Core/Core" \
    --destination "Core/CoreTests/Generated/CoreMocks.generated.swift" \
    --mock-final \
    --testable-imports "Core" \
    --custom-imports "Foundation" "SwiftUI" "Combine" "OEXFoundation" "Alamofire" "CoreData" "ZipArchive"

# Authorization module (includes Core sources for shared protocols like AuthInteractorProtocol)
echo "Generating Authorization mocks..."
"${MOCKOLO}" \
    --sourcedirs "Authorization/Authorization" "Core/Core" \
    --destination "Authorization/AuthorizationTests/Generated/AuthorizationMocks.generated.swift" \
    --mock-final \
    --testable-imports "Authorization" "Core" \
    --custom-imports "Foundation" "SwiftUI" "Combine" "OEXFoundation" "Alamofire" "CoreData"

# Course module (includes Core sources for shared protocols)
echo "Generating Course mocks..."
"${MOCKOLO}" \
    --sourcedirs "Course/Course" "Core/Core" \
    --destination "Course/CourseTests/Generated/CourseMocks.generated.swift" \
    --mock-final \
    --testable-imports "Course" "Core" \
    --custom-imports "Foundation" "SwiftUI" "Combine" "OEXFoundation" "Alamofire" "CoreData"

# WhatsNew module
echo "Generating WhatsNew mocks..."
"${MOCKOLO}" \
    --sourcedirs "WhatsNew/WhatsNew" \
    --destination "WhatsNew/WhatsNewTests/Generated/WhatsNewMocks.generated.swift" \
    --mock-final \
    --testable-imports "WhatsNew" \
    --custom-imports "Foundation"

# Discovery module (includes Core sources for shared protocols)
echo "Generating Discovery mocks..."
"${MOCKOLO}" \
    --sourcedirs "Discovery/Discovery" "Core/Core" \
    --destination "Discovery/DiscoveryTests/Generated/DiscoveryMocks.generated.swift" \
    --mock-final \
    --testable-imports "Discovery" "Core" \
    --custom-imports "Foundation" "SwiftUI" "Combine" "OEXFoundation" "Alamofire" "CoreData"

# Dashboard module (includes Core sources for shared protocols)
echo "Generating Dashboard mocks..."
"${MOCKOLO}" \
    --sourcedirs "Dashboard/Dashboard" "Core/Core" \
    --destination "Dashboard/DashboardTests/Generated/DashboardMocks.generated.swift" \
    --mock-final \
    --testable-imports "Dashboard" "Core" \
    --custom-imports "Foundation" "SwiftUI" "Combine" "OEXFoundation"

# Downloads module (includes Core sources for shared protocols)
echo "Generating Downloads mocks..."
"${MOCKOLO}" \
    --sourcedirs "Downloads/Downloads" "Core/Core" \
    --destination "Downloads/DownloadsTests/Generated/DownloadsMocks.generated.swift" \
    --mock-final \
    --testable-imports "Downloads" "Core" \
    --custom-imports "Foundation" "SwiftUI" "Combine" "OEXFoundation"

# Profile module (includes Core sources for shared protocols)
echo "Generating Profile mocks..."
"${MOCKOLO}" \
    --sourcedirs "Profile/Profile" "Core/Core" \
    --destination "Profile/ProfileTests/Generated/ProfileMocks.generated.swift" \
    --mock-final \
    --testable-imports "Profile" "Core" \
    --custom-imports "Foundation" "SwiftUI" "Combine" "OEXFoundation" "Alamofire"

# Discussion module (includes Core sources for shared protocols)
echo "Generating Discussion mocks..."
"${MOCKOLO}" \
    --sourcedirs "Discussion/Discussion" "Core/Core" \
    --destination "Discussion/DiscussionTests/Generated/DiscussionMocks.generated.swift" \
    --mock-final \
    --testable-imports "Discussion" "Core" \
    --custom-imports "Foundation" "SwiftUI" "Combine" "OEXFoundation" "Alamofire"

# AppDates module (includes Core sources for shared protocols)
echo "Generating AppDates mocks..."
"${MOCKOLO}" \
    --sourcedirs "AppDates/AppDates" "Core/Core" \
    --destination "AppDates/AppDatesTests/Generated/AppDatesMocks.generated.swift" \
    --mock-final \
    --testable-imports "AppDates" "Core" \
    --custom-imports "Foundation" "SwiftUI" "Combine" "OEXFoundation"

echo "Done! All mocks generated successfully."
