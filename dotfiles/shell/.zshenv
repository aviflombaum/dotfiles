# ═══════════════════════════════════════════════════════════════
# .zshenv - Loaded for all Zsh sessions (login, non-login, script)
# ═══════════════════════════════════════════════════════════════
#
# This file is always sourced, so it should contain environment
# variables that should be available to all Zsh instances.
# Keep it fast and minimal.

# Load environment variables (create your own .vars file)
if [[ -f "$HOME/.config/env/.vars" ]]; then
  source "$HOME/.config/env/.vars"
fi

# Rust/Cargo environment (if installed)
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

# Set default language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Ensure PATH includes common binary locations
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"