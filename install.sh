#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE=bootstrap
FORCE=false

usage() {
    cat <<'EOF'
Usage: install.sh [--links-only | --bootstrap | --force-bootstrap | --full | --minimal]

  --links-only, --minimal  Link configuration without installing user tools.
  --bootstrap              Link configuration and reconcile user tools (default).
  --force-bootstrap, --full
                           Link configuration and force user-tool reconciliation.
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --links-only|--minimal)
            MODE=links
            ;;
        --bootstrap)
            MODE=bootstrap
            ;;
        --force-bootstrap|--full)
            MODE=bootstrap
            FORCE=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

printf 'export DMOTLES_DOTFILES_ROOT=%q\n' "$ROOT" > "$HOME/.dmotles-dotfiles-root"

LINK_ARGS=()
if [ "${CODER:-}" = "true" ] || [ "${CODESPACES:-}" = "true" ] || [ "${DOTFILES_NONINTERACTIVE:-}" = "1" ]; then
    LINK_ARGS+=(--non-interactive)
fi
python3 "$ROOT/symlink_all.py" "${LINK_ARGS[@]}"

if [ "$MODE" = bootstrap ]; then
    if [ "$FORCE" = true ]; then
        "$ROOT/bootstrap-user.sh" --force
    else
        "$ROOT/bootstrap-user.sh"
    fi
fi
