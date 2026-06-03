#!/usr/bin/env bash
# Publish socratic-mirror to openclawmp with the CHINESE readme.
#
# Why: the openclawmp CLI only renders the packaged README.md (it never reads
# README.zh-CN.md). GitHub's README.md must stay English-first. So at publish
# time we temporarily put the Chinese README in place, publish, then restore
# the English one — GitHub is never affected.
#
# Usage:  ./publish-openclawmp.sh          # publishes the semver in .metadata.json
# Bump "semver" in .metadata.json before running (openclawmp rejects re-using a version).

set -euo pipefail
cd "$(dirname "$0")"

EN="README.md"
ZH="README.zh-CN.md"
BAK="$(mktemp)"

[ -f "$ZH" ] || { echo "missing $ZH" >&2; exit 1; }

# Save English README, swap in Chinese
cp "$EN" "$BAK"
restore() { cp "$BAK" "$EN"; rm -f "$BAK"; echo "restored English $EN"; }
trap restore EXIT

cp "$ZH" "$EN"
echo "swapped Chinese README into $EN, publishing..."

openclawmp publish . --yes "$@"
# trap restores English README on exit (success or failure)
