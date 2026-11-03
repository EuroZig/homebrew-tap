#!/bin/bash
# Updates Formula/git-native-issuez.rb to a release: the version in each
# platform's URL and the sha256 under it, taken from the release's SHA256SUMS.
#
#   scripts/update-formula.sh VERSION SHA256SUMS [FORMULA]
#
# Fails without writing anything unless all four platforms are updated.

set -euo pipefail

usage() {
  echo "usage: $0 VERSION SHA256SUMS [FORMULA]" >&2
  exit 2
}

[[ $# -ge 2 && $# -le 3 ]] || usage
dir=$(dirname "$0")
version=$1
sums=$2
formula=${3:-${dir}/../Formula/git-native-issuez.rb}

if [[ ${version} == v* ]]
then
  echo "$0: VERSION is without the v: ${version#v}" >&2
  exit 2
fi
if [[ ! ${version} =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
  echo "$0: not a release version: ${version}" >&2
  exit 2
fi
for file in "${sums}" "${formula}"
do
  if [[ ! -f ${file} ]]
  then
    echo "$0: no such file: ${file}" >&2
    exit 2
  fi
done

tmp=$(mktemp)
trap 'rm -f "${tmp}"' EXIT

awk -v version="${version}" -v sums="${sums}" -f "${dir}/update-formula.awk" "${formula}" >"${tmp}"
cat "${tmp}" >"${formula}"
