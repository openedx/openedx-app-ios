#!/bin/bash

# Fetches the tools pinned in BuildTools/Package.swift and links them into BuildTools/bin,
# where the Xcode build phases, fastlane and CI run them from.
# Usage: make bootstrap

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

TOOLS=(swiftlint swiftgen mockolo)

# Prints the executable of the given tool for this Mac, read from the info.json of its artifact bundle.
executable_path() {
    local tool="$1" triple info index path triples
    triple="$(uname -m)-apple-macosx"
    while IFS= read -r info; do
        index=0
        while path=$(plutil -extract "artifacts.${tool}.variants.${index}.path" raw -o - "${info}" 2>/dev/null); do
            triples=$(plutil -extract "artifacts.${tool}.variants.${index}.supportedTriples" json -o - "${info}")
            if [[ "${triples}" == *"\"${triple}\""* ]]; then
                echo "$(dirname "${info}")/${path}"
                return 0
            fi
            index=$((index + 1))
        done
    done < <(find .build/artifacts -path '*.artifactbundle/info.json' -not -path '*/extract/*')
    return 1
}

swift package resolve

mkdir -p bin
for tool in "${TOOLS[@]}"; do
    if ! executable=$(executable_path "${tool}") || [[ ! -x "${executable}" ]]; then
        echo "error: ${tool} was not found in the resolved artifacts of BuildTools/Package.swift" >&2
        exit 1
    fi
    ln -sfn "../${executable}" "bin/${tool}"
    echo "BuildTools/bin/${tool} -> ${executable}"
done
