# Enable Python environment management (if using pyenv)
# eval "$(pyenv init --path)"

# Enable Powerlevel10k instant prompt (optional - uncomment if using p10k instead of Starship)
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load (comment out if using Starship)
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Hyphen-insensitive completion (treats _ and - as interchangeable)
HYPHEN_INSENSITIVE="true"

# Disable command auto-correction
ENABLE_CORRECTION="false"

# Disable completion waiting dots (can cause issues with multiline prompts)
COMPLETION_WAITING_DOTS="false"

# Which plugins to load (keep minimal for faster startup)
# Available plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(git macos)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Disable automatic directory name expansion
unsetopt auto_name_dirs

# ═══════════════════════════════════════════════════════════════
# INITIALIZATIONS
# ═══════════════════════════════════════════════════════════════

# Syntax highlighting (install with: brew install zsh-syntax-highlighting)
if [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Load custom functions and aliases
if [[ -f "$HOME/.config/zshfunctions.sh" ]]; then
  source "$HOME/.config/zshfunctions.sh"
fi

# ═══════════════════════════════════════════════════════════════
# VERSION MANAGERS
# ═══════════════════════════════════════════════════════════════

# ASDF version manager (if installed)
if [[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
elif [[ -f /usr/local/opt/asdf/libexec/asdf.sh ]]; then
  . /usr/local/opt/asdf/libexec/asdf.sh
fi

# rbenv (Ruby version manager)
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init - zsh)"
fi

# pyenv (Python version manager)
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init --path)"
fi

# ═══════════════════════════════════════════════════════════════
# PROMPT & SHELL ENHANCEMENTS
# ═══════════════════════════════════════════════════════════════

# Starship prompt (install with: brew install starship)
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# direnv (auto-load .envrc files)
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# zoxide (smarter cd command)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# ═══════════════════════════════════════════════════════════════
# PATH ADDITIONS
# ═══════════════════════════════════════════════════════════════

# Homebrew (for M1 Macs)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Homebrew (for Intel Macs)
if [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Bun JavaScript runtime
if [[ -d "$HOME/.bun" ]]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  # Bun completions
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# pnpm
if [[ -d "$HOME/Library/pnpm" ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi

# Rust/Cargo
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# Deno
if [[ -d "$HOME/.deno" ]]; then
  export PATH="$PATH:$HOME/.deno/bin"
fi

# Local binaries
if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$PATH:$HOME/.local/bin"
fi

# ═══════════════════════════════════════════════════════════════
# COMPLETIONS
# ═══════════════════════════════════════════════════════════════

# Initialize completions
autoload -Uz compinit && compinit

# ═══════════════════════════════════════════════════════════════
# CUSTOM SETTINGS
# ═══════════════════════════════════════════════════════════════

# Set your preferred editor (examples)
# export EDITOR="code -w"        # VS Code
# export EDITOR="subl -w"        # Sublime Text
# export EDITOR="zed -w"         # Zed
# export EDITOR="vim"            # Vim
# export EDITOR="nvim"           # Neovim

# History settings
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# ═══════════════════════════════════════════════════════════════
# LOAD ADDITIONAL CONFIGURATIONS
# ═══════════════════════════════════════════════════════════════

# Load local/private configurations (not tracked in git)
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi