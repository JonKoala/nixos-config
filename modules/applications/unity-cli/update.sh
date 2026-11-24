#!/usr/bin/env bash
# Bump package.nix to the latest stable Unity CLI release.
set -euo pipefail

manifest_url="https://public-cdn.cloud.unity3d.com/hub/prod/cli/latest.json"
package="$(dirname "$(realpath "$0")")/package.nix"

manifest=$(curl -fsSL "$manifest_url")
version=$(jq -r '.version // empty' <<<"$manifest")
sha256=$(jq -r '.binaries["linux-x64"].sha256 // empty' <<<"$manifest")

[[ -n $version && -n $sha256 ]] || { echo "failed to parse $manifest_url" >&2; exit 1; }

current=$(sed -n 's/^ *version = "\(.*\)";/\1/p' "$package")
if [[ $current == "$version" ]]; then
  echo "unity-cli already at $version"
  exit 0
fi

sed -i \
  -e "s/^\( *version = \)\".*\";/\1\"$version\";/" \
  -e "s/^\( *sha256 = \)\".*\";/\1\"$sha256\";/" \
  "$package"

echo "unity-cli: $current -> $version"
echo "release notes: https://docs.unity.com/en-us/unity-cli/release-notes"
echo "rebuild to apply"
