#!/usr/bin/env bash
#
# Usage: setup.sh [--bare] [--no-install]
#
# Bootstraps a Mac dotfiles install. Each phase lives in helper_scripts/.
#
# --bare        link minimal *.bare configs and install only their deps.
# --no-install  skip the brew/deps phase (re-runs that only re-link).

set -e

BARE=0
DO_INSTALL=1
while [[ $# -gt 0 ]]; do
    case "$1" in
        --bare)        BARE=1; shift ;;
        --no-install)  DO_INSTALL=0; shift ;;
        -h|--help)     sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *)             echo "unknown arg: $1" >&2; exit 1 ;;
    esac
done

[[ $BARE -eq 1 ]] && echo "Mode: BARE"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ $DO_INSTALL -eq 1 ]] && . "$REPO_DIR/helper_scripts/install-deps.sh"
. "$REPO_DIR/helper_scripts/link-configs.sh"
. "$REPO_DIR/helper_scripts/bootstrap.sh"
