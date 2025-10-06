# Public Dotfiles Configuration Plan

## Overview

This document outlines the dotfiles and configurations that will be included in a public-friendly
repository, with all personal information, API keys, and private paths removed or genericized.

## Security Considerations

After thorough analysis, I've identified the following items that MUST be excluded or sanitized:

### CRITICAL - Must Remove:

- **API Keys**: OpenAI, Digital Ocean, Namecheap credentials
- **Personal Information**: Email addresses, usernames, personal paths
- **1Password References**: SSH signing configurations, biometric settings
- **Private Scripts**: Domain management scripts (godaddy, cloudflare, namecheap)
- **Work-specific Configurations**: Company-specific paths and settings

## Files to Include (Sanitized)

### 1. **Shell Configuration**

#### `.zshrc` (public version)

- **Include:**
  - Oh-My-Zsh configuration
  - Plugin setup (git, macos)
  - Tool initializations (starship, zoxide, direnv)
  - Generic PATH additions for common tools
  - Syntax highlighting setup
  - Completion settings
- **Remove/Generalize:**
  - Personal paths → Use `$HOME` variables
  - Specific work directories
  - Private cloud SDK paths
  - Company-specific tool paths

#### `.zshenv` (public version)

- **Include:**
  - Generic environment variable structure
  - Cargo environment setup
- **Remove:**
  - Personal `.vars` file reference
  - Create example ENV variable templates instead

#### `.config/env/.vars.example`

- **Create New:**
  - Template with placeholder values
  - Common PATH exports (Homebrew, Android SDK, PostgreSQL)
  - Editor preferences structure
  - Language environment settings
- **Replace with placeholders:**
  - `OPENAI_API_KEY="your-api-key-here"`
  - `GITHUB_TOKEN="your-github-token"`
  - Generic usernames and paths

### 2. **Shell Functions & Aliases**

#### `.config/zshfunctions.sh` (public version)

- **Include:**
  - Generic utility functions (bak, pfind, srv)
  - Git workflow helpers (gacm, gnrb, gps)
  - YouTube download functions
  - Development navigation aliases (with examples)
  - Time benchmarking function (timezsh)
  - Localhost helper
  - Docker compose alias
  - Rails new helper
- **Remove:**
  - Personal directory paths
  - Domain management functions
  - 1Password integration functions
  - Specific work project aliases

### 3. **Prompt Configuration**

#### `.config/starship.toml`

- **Include AS-IS:** This file is safe to share completely
  - Custom symbols for various languages
  - Color schemes (Dracula theme inspired)
  - Git status configuration
  - Time display settings

### 4. **Git Configuration**

#### `.gitconfig` (public version)

- **Include:**
  - Useful aliases (co, ci, st, pr, branches, etc.)
  - Core settings (default branch, push behavior)
  - Git LFS configuration
- **Remove/Replace:**
  - User name/email → placeholders
  - SSH signing key → example format
  - 1Password SSH program path → comment with instructions
  - Sourcetree paths → generic examples

#### `.gitignore_global`

- **Include AS-IS:** Standard global gitignore patterns

### 5. **Development Tool Configurations**

#### `.irbrc`

- **Include AS-IS:** Ruby IRB customizations and helper methods
  - Amazing Print setup
  - Dracula theme
  - Custom class methods for introspection

#### `.rubocop.yml`

- **Include AS-IS:** Ruby linting preferences

#### `.prettierrc.json`

- **Include AS-IS:** JavaScript/HTML formatting preferences

#### `.tool-versions`

- **Include with examples:** asdf version management template

### 6. **Additional Configurations**

#### `.bashrc` / `.bash_profile`

- **Include:** Basic bash configuration for compatibility

#### `.gemrc`

- **Include:** Ruby gem configuration

## New Files to Create

### 1. **README.md**

Comprehensive guide including:

- Installation instructions
- Tool requirements (Homebrew, Oh-My-Zsh, Starship, etc.)
- Feature descriptions
- Customization guide
- Screenshots of terminal appearance

### 2. **install.sh**

Automated setup script that:

- Backs up existing dotfiles
- Creates symlinks
- Installs required tools via Homebrew
- Sets up Oh-My-Zsh and plugins
- Configures Starship prompt

### 3. **.env.example**

Template for environment variables with:

- Clear descriptions for each variable
- Security best practices
- Links to obtain API keys

## Directory Structure

```
dotfiles/
├── README.md
├── install.sh
├── .env.example
├── shell/
│   ├── .zshrc
│   ├── .zshenv
│   ├── .bashrc
│   └── .bash_profile
├── config/
│   ├── starship.toml
│   ├── zshfunctions.sh
│   └── env/
│       └── .vars.example
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── ruby/
│   ├── .irbrc
│   ├── .rubocop.yml
│   └── .gemrc
└── misc/
    ├── .prettierrc.json
    └── .tool-versions.example
```

## Features to Highlight

### Developer Productivity

- Smart aliases and functions for common tasks
- Git workflow optimizations
- Project navigation helpers
- Service startup detection (Rails, Node.js)

### Terminal Aesthetics

- Beautiful Starship prompt with icons
- Dracula-inspired color scheme
- Git status integration
- Command duration display

### Development Environment

- Multi-language support (Ruby, Node.js, Python, etc.)
- Version management with asdf/rbenv
- Linting and formatting configurations
- Database tool integrations

### Shell Enhancements

- Syntax highlighting
- Auto-suggestions
- Directory jumping with zoxide
- Smart tab completion

## Implementation Notes

1. **Privacy First**: All personal information will be replaced with clear placeholders
2. **Documentation**: Each configuration will include inline comments explaining purpose
3. **Modularity**: Configurations will be organized to allow selective adoption
4. **Cross-Platform**: Where possible, include notes for Linux compatibility
5. **Version Control**: Include example `.gitignore` for managing local overrides

## Next Steps

1. Review this plan
2. Create sanitized versions of each file
3. Build comprehensive README with visuals
4. Create installation automation

---

**Note**: This plan has been carefully designed to share useful configurations while protecting all
sensitive information. Please review and let me know if you'd like any adjustments before I proceed
with implementation.
