#!/usr/bin/env bash
# MoneliLLM — fresh install in personal mode (one person, no login, this Mac only).
# The old install is moved aside, not deleted; the licence carries over.
#
#   curl -fsSL https://raw.githubusercontent.com/mesmalif/moneli-releases/main/personal.sh | MONELI_KEY=<install password> bash
#
# Optional last word: the chat model to use instead of the default (gemma4:26b), e.g.
#   ... | MONELI_KEY=<install password> bash -s qwen3:14b
#
# Wrapped in a function so bash reads this whole file before running any of it: it arrives
# through a pipe, and the installer must not read the rest of the script as its input.
main() {
  set -euo pipefail
  local base=https://github.com/mesmalif/moneli-releases/releases/latest/download
  curl -fsSL "$base/install.sh" -o /tmp/moneli-install.sh
  # Give the installer the keyboard if there is one (for the Mac password prompt), and an
  # empty input otherwise - an SSH session or a script has no /dev/tty, and demanding one
  # failed the whole install before it started.
  local input=/dev/null
  if (exec < /dev/tty) 2>/dev/null; then input=/dev/tty; fi
  if [ -n "${1:-}" ]; then export MONELI_MODEL="$1"; fi
  MONELI_FRESH=1 MONELI_PERSONAL=1 MONELI_RELEASE_URL="$base/moneli.tar.gz.enc" \
    bash /tmp/moneli-install.sh < "$input"
}
main "$@"
