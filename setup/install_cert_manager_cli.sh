#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2022-01-05 18:51:40 +0000 (Wed, 05 Jan 2022)
#
#  https://github.com/HariSekhon/DevOps-Bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090
. "$srcdir/../lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Installs Cert Manager CLI 'cmctl'
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<version>]"

export PATH="$PATH:$HOME/bin"

help_usage "$@"

#min_args 1 "$@"

#version="${1:-1.6.1}"
version="${1:-latest}"

owner_repo="cert-manager/cert-manager"

if [ "$version" = latest ]; then
    timestamp "determining latest version of '$owner_repo' via GitHub API"
    version="$("$srcdir/../github_repo_latest_release.sh" "$owner_repo")"
    version="${version#v}"
    timestamp "latest version is '$version'"
else
    is_semver "$version" || die "non-semver version argument given: '$version' - should be in format: N.N.N"
fi

"$srcdir/../install_binary.sh" "https://github.com/$owner_repo/releases/download/v$version/cmctl-{os}-{arch}.tar.gz" cmctl