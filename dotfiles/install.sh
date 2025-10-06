#!/usr/bin/env bash

# ═══════════════════════════════════════════════════════════════
# Dotfiles Installation Script
# ═══════════════════════════════════════════════════════════════
#
# This script installs the dotfiles and required dependencies
# Run with: ./install.sh

set -e # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ═══════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════

print_header() {
  echo -e "\n${PURPLE}═══════════════════════════════════════════════════════════════${NC}"
  echo -e "${PURPLE}  $1${NC}"
  echo -e "${PURPLE}═══════════════════════════════════════════════════════════════${NC}\n"
}

print_success() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

confirm() {
  read -r -p "$(echo -e ${YELLOW}"$1 [y/N]: "${NC})" response
  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# ═══════════════════════════════════════════════════════════════
# System Detection
# ═══════════════════════════════════════════════════════════════

detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
  else
    print_error "Unsupported operating system: $OSTYPE"
    exit 1
  fi
}

detect_arch() {
  ARCH=$(uname -m)
  if [[ "$ARCH" == "arm64" ]]; then
    BREW_PREFIX="/opt/homebrew"
  else
    BREW_PREFIX="/usr/local"
  fi
}

# ═══════════════════════════════════════════════════════════════
# Backup Existing Files
# ═══════════════════════════════════════════════════════════════

backup_file() {
  local file="$1"
  if [[ -f "$file" || -L "$file" ]]; then
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$file" "$backup"
    print_info "Backed up $(basename $file) to $(basename $backup)"
  fi
}

# ═══════════════════════════════════════════════════════════════
# Install Dependencies
# ═══════════════════════════════════════════════════════════════

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    print_header "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    if [[ "$OS" == "macos" ]]; then
      echo 'eval "$('$BREW_PREFIX'/bin/brew shellenv)"' >> ~/.zprofile
      eval "$($BREW_PREFIX/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
  else
    print_info "Homebrew already installed"
  fi
}

install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    print_header "Installing Oh My Zsh"

    # Backup existing .zshrc if it exists
    backup_file "$HOME/.zshrc"

    # Install Oh My Zsh (unattended)
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    print_success "Oh My Zsh installed"
  else
    print_info "Oh My Zsh already installed"
  fi
}

install_brew_packages() {
  print_header "Installing Homebrew Packages"

  local packages=(
    "starship"           # Cross-shell prompt
    "zsh-syntax-highlighting" # Shell syntax highlighting
    "zoxide"            # Smarter cd command
    "direnv"            # Directory-based environments
    "git"               # Version control
    "gh"                # GitHub CLI
    "ripgrep"           # Better grep
    "fd"                # Better find
    "bat"               # Better cat
    "eza"               # Better ls
    "jq"                # JSON processor
    "fzf"               # Fuzzy finder
    "tldr"              # Simplified man pages
    "htop"              # Process viewer
    "ncdu"              # Disk usage analyzer
  )

  for package in "${packages[@]}"; do
    if brew list "$package" &>/dev/null; then
      print_info "$package already installed"
    else
      print_info "Installing $package..."
      brew install "$package" || print_warning "Failed to install $package"
    fi
  done

  print_success "Homebrew packages installed"
}

install_fonts() {
  if confirm "Install Nerd Fonts for terminal icons?"; then
    print_header "Installing Nerd Fonts"

    brew tap homebrew/cask-fonts
    brew install --cask font-meslo-lg-nerd-font || print_warning "Failed to install font"

    print_success "Fonts installed"
    print_info "Remember to set your terminal font to 'MesloLGS NF'"
  fi
}

# ═══════════════════════════════════════════════════════════════
# Create Symbolic Links
# ═══════════════════════════════════════════════════════════════

create_symlinks() {
  print_header "Creating Symbolic Links"

  # Create config directories if they don't exist
  mkdir -p "$HOME/.config"
  mkdir -p "$HOME/.config/env"

  # Shell configurations
  backup_file "$HOME/.zshrc"
  ln -sf "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
  print_success "Linked .zshrc"

  backup_file "$HOME/.zshenv"
  ln -sf "$DOTFILES_DIR/shell/.zshenv" "$HOME/.zshenv"
  print_success "Linked .zshenv"

  # Config files
  backup_file "$HOME/.config/starship.toml"
  ln -sf "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
  print_success "Linked starship.toml"

  backup_file "$HOME/.config/zshfunctions.sh"
  ln -sf "$DOTFILES_DIR/config/zshfunctions.sh" "$HOME/.config/zshfunctions.sh"
  print_success "Linked zshfunctions.sh"

  # Git configurations
  backup_file "$HOME/.gitconfig"
  ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  print_success "Linked .gitconfig"

  backup_file "$HOME/.gitignore_global"
  ln -sf "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
  print_success "Linked .gitignore_global"

  # Ruby configurations
  if confirm "Install Ruby configurations?"; then
    backup_file "$HOME/.irbrc"
    ln -sf "$DOTFILES_DIR/ruby/.irbrc" "$HOME/.irbrc"
    print_success "Linked .irbrc"

    backup_file "$HOME/.rubocop.yml"
    ln -sf "$DOTFILES_DIR/ruby/.rubocop.yml" "$HOME/.rubocop.yml"
    print_success "Linked .rubocop.yml"

    backup_file "$HOME/.gemrc"
    ln -sf "$DOTFILES_DIR/ruby/.gemrc" "$HOME/.gemrc"
    print_success "Linked .gemrc"
  fi

  # Other configurations
  if confirm "Install Prettier configuration?"; then
    backup_file "$HOME/.prettierrc.json"
    ln -sf "$DOTFILES_DIR/misc/.prettierrc.json" "$HOME/.prettierrc.json"
    print_success "Linked .prettierrc.json"
  fi

  # Environment variables template
  if [[ ! -f "$HOME/.config/env/.vars" ]]; then
    cp "$DOTFILES_DIR/config/env/.vars.example" "$HOME/.config/env/.vars"
    print_success "Created .config/env/.vars from template"
    print_warning "Remember to edit ~/.config/env/.vars with your values"
  else
    print_info ".config/env/.vars already exists, skipping"
  fi
}

# ═══════════════════════════════════════════════════════════════
# Additional Setup
# ═══════════════════════════════════════════════════════════════

setup_asdf() {
  if confirm "Install asdf version manager?"; then
    print_header "Installing asdf"

    brew install asdf

    # Add some common plugins
    if confirm "Install common asdf plugins (nodejs, ruby, python)?"; then
      asdf plugin add nodejs || true
      asdf plugin add ruby || true
      asdf plugin add python || true
      print_success "asdf plugins added"
    fi
  fi
}

setup_development_tools() {
  if confirm "Install additional development tools?"; then
    print_header "Installing Development Tools"

    # Node.js tools
    if confirm "Install Node.js tools (via Homebrew)?"; then
      brew install node yarn pnpm bun || true
    fi

    # Ruby tools
    if confirm "Install Ruby tools (via Homebrew)?"; then
      brew install rbenv ruby-build || true
    fi

    # Python tools
    if confirm "Install Python tools (via Homebrew)?"; then
      brew install pyenv python@3.12 || true
    fi

    # Docker
    if confirm "Install Docker Desktop?"; then
      brew install --cask docker || true
    fi

    print_success "Development tools installed"
  fi
}

# ═══════════════════════════════════════════════════════════════
# Main Installation
# ═══════════════════════════════════════════════════════════════

main() {
  clear

  echo -e "${CYAN}"
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║                                                          ║"
  echo "║            🚀 DOTFILES INSTALLATION SCRIPT 🚀           ║"
  echo "║                                                          ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo -e "${NC}\n"

  print_info "This script will install dotfiles from: $DOTFILES_DIR"
  print_warning "Existing files will be backed up with .backup extension"
  echo

  if ! confirm "Do you want to continue?"; then
    print_error "Installation cancelled"
    exit 0
  fi

  # Detect system
  detect_os
  detect_arch

  # Install dependencies
  if [[ "$OS" == "macos" ]]; then
    install_homebrew
    install_brew_packages
    install_fonts
  else
    print_warning "Automatic package installation only supported on macOS"
    print_info "Please install required packages manually"
  fi

  install_oh_my_zsh

  # Create symbolic links
  create_symlinks

  # Optional additional setup
  setup_asdf
  setup_development_tools

  # Final messages
  print_header "Installation Complete! 🎉"

  echo -e "${GREEN}Your dotfiles have been successfully installed!${NC}\n"
  echo "Next steps:"
  echo "  1. Edit ~/.config/env/.vars with your environment variables"
  echo "  2. Customize ~/.gitconfig with your user information"
  echo "  3. Set your terminal font to 'MesloLGS NF' for icons"
  echo "  4. Restart your terminal or run: source ~/.zshrc"
  echo
  echo -e "${CYAN}Happy coding! 🚀${NC}"
}

# Run main function
main "$@"