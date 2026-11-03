#!/bin/sh
# Updates Formula/git-native-issuez.rb to a release: the version in each
# platform's URL and the sha256 under it, taken from the release's SHA256SUMS.
#
#   scripts/update-formula.sh VERSION SHA256SUMS [FORMULA]
#
# Fails without writing anything unless all four platforms are updated.

set -eu

usage() {
  echo "usage: $0 VERSION SHA256SUMS [FORMULA]" >&2
  exit 2
}

[ $# -ge 2 ] && [ $# -le 3 ] || usage
version=$1
sums=$2
formula=${3:-$(dirname "$0")/../Formula/git-native-issuez.rb}

case $version in
  v*) echo "$0: VERSION is without the v: ${version#v}" >&2; exit 2 ;;
esac
if ! printf '%s\n' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "$0: not a release version: $version" >&2
  exit 2
fi
[ -f "$sums" ] || { echo "$0: no such file: $sums" >&2; exit 2; }
[ -f "$formula" ] || { echo "$0: no such file: $formula" >&2; exit 2; }

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

awk -v version="$version" -v sums="$sums" '
  BEGIN {
    n = split("aarch64-macos x86_64-macos aarch64-linux x86_64-linux", platforms, " ")
    while ((getline line < sums) > 0) {
      split(line, f, /[ *]+/)
      sha[f[2]] = f[1]
    }
    for (i = 1; i <= n; i++) {
      p = platforms[i]
      archive[p] = "git-native-issuez-" version "-full-" p ".tar.gz"
      if (length(sha[archive[p]]) != 64 || sha[archive[p]] !~ /^[0-9a-f]+$/) {
        print "update-formula: no sha256 for " archive[p] " in " sums > "/dev/stderr"
        failed = 1
        exit 1
      }
    }
  }
  # A platform URL: rewrite it; the next sha256 line is its checksum.
  /^ *url "/ {
    for (i = 1; i <= n; i++) {
      p = platforms[i]
      if (index($0, "-full-" p ".tar.gz\"")) {
        indent = $0
        sub(/url.*/, "", indent)
        print indent "url \"https://github.com/EuroZig/git-native-issuez/releases/download/v" version "/" archive[p] "\""
        pending = p
        urls[p]++
        next
      }
    }
  }
  /^ *sha256 "/ && pending != "" {
    indent = $0
    sub(/sha256.*/, "", indent)
    print indent "sha256 \"" sha[archive[pending]] "\""
    shas[pending]++
    pending = ""
    next
  }
  { print }
  END {
    if (failed) exit 1
    for (i = 1; i <= n; i++) {
      p = platforms[i]
      if (urls[p] != 1 || shas[p] != 1) {
        print "update-formula: expected one url and sha256 for " p ", found " urls[p] + 0 " and " shas[p] + 0 > "/dev/stderr"
        bad = 1
      }
    }
    exit bad
  }
' "$formula" > "$tmp"

cat "$tmp" > "$formula"
