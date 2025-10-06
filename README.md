# 🚀 Modern Developer Dotfiles

A comprehensive, well-organized collection of dotfiles for a productive development environment on macOS. Features a beautiful terminal setup with Starship prompt, powerful shell functions, and sensible defaults for modern development tools.

![Starship Prompt Preview](dotfiles/config/prompt_preview.png)

> **📌 Note**: These dotfiles contain many opinionated configurations and unique customizations (RuboCop rules, IRB helpers, Prettier settings, custom shell functions, etc.). See the [🎯 Unique Configurations](#-unique-configurations--opinionated-choices) section to understand what makes these dotfiles different and decide what to keep or modify for your workflow.

## ✨ Features

### 🎨 Beautiful Terminal
- **Starship Prompt**: Fast, customizable prompt with Git integration
- **Dracula-inspired theme**: Easy on the eyes with excellent contrast
- **Nerd Fonts icons**: Visual indicators for languages and tools
- **Syntax highlighting**: Powered by zsh-syntax-highlighting
- **Smart completions**: Context-aware tab completions

### 🛠 Developer Productivity
- **Smart aliases**: Shortcuts for common Git, Docker, and development tasks
- **Project detection**: Auto-detects project type and runs appropriate dev server
- **Git workflow helpers**: Streamlined branch creation and pushing
- **File backup functions**: Safe file operations with automatic backups
- **YouTube downloaders**: Built-in functions for downloading videos/audio

### 🔧 Development Environment
- **Multi-language support**: Configurations for Ruby, Node.js, Python, Elixir, and more
- **Version management**: Support for asdf, rbenv, pyenv, and nvm
- **Linting configs**: RuboCop for Ruby, Prettier for JavaScript/CSS
- **Database tools**: PostgreSQL and MySQL path configurations
- **Container support**: Docker and Docker Compose shortcuts

### 📦 Tool Integrations
- **Oh My Zsh**: Extended Zsh functionality and plugins
- **Homebrew**: Package manager integration for macOS
- **Git enhancements**: Powerful aliases and configurations
- **Editor support**: Configurations for VS Code, Vim, and more

## 🎯 Unique Configurations & Opinionated Choices

These dotfiles include several opinionated configurations that may differ from standard setups. Review and adjust these to match your preferences:

### Shell Configuration (`.zshrc`, `.zshenv`)
- **Minimal Plugin Philosophy**: Only loads `git` and `macos` plugins for faster shell startup
- **Disabled Auto-Correction**: `ENABLE_CORRECTION="false"` - no annoying command corrections
- **Disabled Completion Dots**: `COMPLETION_WAITING_DOTS="false"` - cleaner multiline prompts
- **XDG Base Directory Compliance**: Follows XDG spec for organized config directories
- **Disabled Auto Name Dirs**: `unsetopt auto_name_dirs` - prevents automatic directory name expansion
- **Modern Runtime Support**: Built-in support for Bun, pnpm, Deno, and Rust/Cargo
- **Smart Tool Detection**: Conditionally loads rbenv, pyenv, asdf, direnv, and zoxide only if installed

### Starship Prompt (`config/starship.toml`)
- **Dracula Color Scheme**: Custom colors (#ff5555, #50fa7b, #ffb86c, #f1fa8c, #ff79c6, #bd93f9, #8be9fd)
- **Time on Right Side**: `right_format = "$time"` displays current time in prompt
- **Extended Timeout**: `command_timeout = 20000` (20 seconds) for long-running commands
- **Disabled Contexts**: Docker and gcloud context indicators are disabled for cleaner prompt
- **Two-Line Prompt**: Line breaks enabled for better readability
- **Nerd Font Icons**: Custom symbols for all languages and tools

### Ruby Configuration (`.irbrc`, `.rubocop.yml`, `.gemrc`)

#### IRB Console (`.irbrc`)
- **Amazing Print**: Automatically loads `amazing_print` gem for beautiful output formatting
- **Dracula IRB Theme**: Uses `irb-theme-dracula` when available
- **Custom Introspection Methods**:
  - `defined_methods` - Show methods defined by an object's class
  - `local_methods` - Show instance methods from the class only
  - `class_methods` - Show class methods (not inherited)
  - `ocode(method_name)` - Opens method source in VS Code at exact line
- **Rails-Specific Helpers**:
  - `show_model(Model)` - Display database columns and types
  - `show_sql` / `hide_sql` - Toggle SQL query logging
  - `sql(query)` - Execute raw SQL queries
  - Custom Rails environment prompt
- **macOS Integration**: `copy()` and `paste()` functions for clipboard operations
- **Benchmarking Helpers**: `benchmark()` and `time()` functions built-in

#### RuboCop (`.rubocop.yml`)
- **No Frozen String Literals**: Disabled - reduces file noise
- **Flexible String Literals**: Allows both single and double quotes
- **No Documentation Requirement**: Classes don't require documentation comments
- **120 Character Line Length**: More practical for modern wide screens
- **Bracket Style for Symbol Arrays**: Prefers `[:a, :b]` over `%i[a b]`
- **No Empty Lines in Class/Module Bodies**: `EnforcedStyle: no_empty_lines`
- **Relaxed Metrics**: MethodLength: 20, ClassLength: 200, AbcSize: 20
- **Space Flexibility**: Allows both `{a: 1}` and `{ a: 1 }` styles

#### RubyGems (`.gemrc`)
- **No Documentation by Default**: `gem: --no-document` for faster gem installations

### JavaScript/TypeScript Configuration (`.prettierrc.json`)
- **Single Quotes**: Prefers single quotes for JS/TS (except JSX)
- **100 Character Width**: `printWidth: 100` instead of default 80
- **Bracket Same Line**: `bracketSameLine: true` for compact JSX
- **Single Attribute Per Line**: `singleAttributePerLine: true` for readable React/JSX
- **Always Wrap Prose**: `proseWrap: "always"` for markdown and text files
- **ERB File Support**: Special handling for Rails `.erb` files as HTML
- **YAML Double Quotes**: Different quote style for YAML/YML files

### Custom Shell Functions (`config/zshfunctions.sh`)

#### Development Workflow
- **`srv()`**: Intelligent dev server starter that auto-detects:
  - Bun (`bun.lockb`) → `bun run dev`
  - pnpm (`pnpm-lock.yaml`) → `pnpm dev`
  - Yarn (`yarn.lock`) → `yarn dev`
  - npm → `npm run dev`
  - Rails `bin/dev` → `./bin/dev`
  - Rails Procfile.dev → `foreman start -f Procfile.dev`
  - Elixir Phoenix → `mix phx.server`
  - Django → `python manage.py runserver`

#### Git Workflow Helpers
- **`gacm "message"`**: Add all changes and commit in one command
- **`gnrb branch-name`**: Create new branch and immediately push to origin with upstream
- **`gps`**: Push with automatic upstream tracking
- **`grbi 3`**: Interactive rebase last N commits (default 3)

#### Rails Preferences
- **`rails-new app-name`**: Creates Rails app with opinionated defaults:
  - `--main` - Uses main branch instead of master
  - `--skip-test` - Skips Minitest (assumes RSpec preference)
  - `--skip-system-test` - Skips system tests
  - `--css=tailwind` - Tailwind CSS by default
  - `--database=postgresql` - PostgreSQL over SQLite

#### Unique Utilities
- **YouTube Downloaders**: `youtube-mp3`, `youtube-video`, `youtube-playlist` (requires yt-dlp)
- **`bak file.txt`**: Smart backup that creates `file.bak.txt` (preserves extensions)
- **`killport 3000`**: Kill any process running on specified port
- **`localhost 3000`**: Opens browser to localhost:port
- **`timezsh`**: Benchmark shell startup time (runs 10 iterations)
- **`mkcd dir`**: Create directory and cd into it in one command
- **`extract file.zip`**: Universal archive extractor (supports tar, zip, rar, 7z, etc.)
- **`myip`**: Get your public IP address
- **Safety Aliases**: `rm -i`, `cp -i`, `mv -i` - always prompt before overwriting

### Environment Variables (`config/env/.vars.example`)
- **Comprehensive Template**: 250+ lines covering all major services
- **1Password CLI Integration**: Recommended for secure credential management
- **Organized Sections**: API keys, cloud providers, databases, payment processors, analytics, OAuth, etc.
- **Modern Tooling**: Includes Docker registry, npm tokens, Homebrew GitHub tokens
- **Security Warnings**: Inline reminders about never committing real credentials

### Version Management (`.tool-versions.example`)
- **Modern Versions**: Ruby 3.3.0, Node 20.11.0, Python 3.12.0
- **Polyglot Support**: Examples for Ruby, Node, Python, Elixir, Go, Rust, Java, PHP
- **Infrastructure Tools**: PostgreSQL, Redis, Terraform, AWS CLI, kubectl

## ⚠️ Security & Safety Warnings

**IMPORTANT: Read before using these dotfiles!**

### 🔴 Potentially Dangerous Commands

These functions/aliases can cause data loss if used carelessly:

1. **`docker-cleanup`** (zshfunctions.sh:240-242)
   - Uses `docker system prune -a --volumes -f`
   - **Deletes ALL unused containers, images, networks, AND volumes without confirmation**
   - Could destroy important database volumes or cached data
   - **Recommendation**: Remove the `-f` flag or comment out this function

2. **`pkill-name` and `killport`** (zshfunctions.sh:52-54, 197-199)
   - Use `kill -9` (SIGKILL) for forceful termination
   - Can cause data corruption or loss of unsaved work
   - **Recommendation**: Use `kill -15` (SIGTERM) first to allow graceful shutdown

3. **`gacm` function** (zshfunctions.sh:105-108)
   - Runs `git add .` which stages ALL files in the working directory
   - **Could accidentally commit sensitive files** (.env, credentials, private keys)
   - **Recommendation**: Always review `git status` before using this command

4. **Safety Aliases Create Bad Habits** (zshfunctions.sh:309-311)
   - `alias rm="rm -i"`, `cp="cp -i"`, `mv="mv -i"`
   - These create muscle memory expecting confirmation prompts
   - **Dangerous on systems without these aliases** - you might delete files expecting a prompt that never comes
   - **Recommendation**: Consider removing these and use explicit flags when needed (`rm -i` manually)

### 🔒 Security Best Practices

**Before committing your dotfiles to a public repository:**

1. ✅ **Never commit actual credentials**
   - The `.gitignore` properly excludes `.env`, `.vars`, and `*.local` files
   - Always use `.example` files with placeholder values only
   - Store real secrets in `~/.config/env/.vars` (excluded from git)

2. ✅ **Verify your .gitignore is working**
   ```bash
   git status --ignored
   ```

3. ✅ **Remove personal information**
   - Update `.gitconfig` with your actual name/email in `~/.gitconfig.local` (not committed)
   - Don't commit machine-specific paths or usernames

4. ✅ **Review git aliases**
   - `.gitconfig` line 128: `today` alias has placeholder "Your Name"
   - Update to use `--author="$(git config user.name)"` or remove this alias

5. ✅ **Use SSH for GitHub** (already configured)
   - `.gitconfig` lines 209-211 rewrite HTTPS URLs to SSH
   - Ensure you have SSH keys set up first

### 🛡️ What's Safe - Already Secured

These dotfiles **DO NOT** contain:
- ✅ Hardcoded API keys or passwords
- ✅ Personal email addresses or real credentials
- ✅ Company-specific or proprietary information
- ✅ Actual secret values (only `.example` templates with placeholders)

The `.gitignore` and `.gitignore_global` properly exclude:
- ✅ Environment files (`.env`, `.vars`)
- ✅ Local customizations (`*.local`, `*.private`)
- ✅ SSL certificates and private keys (`*.pem`, `*.key`, `*.crt`)
- ✅ AWS credentials (`.aws/`)
- ✅ Terraform state files
- ✅ Personal notes and secret directories

## 📋 Prerequisites

### Required
- **macOS** (or Linux with modifications)
- **Zsh** shell (default on modern macOS)
- **[Homebrew](https://brew.sh/)** package manager

### Recommended
- **[Oh My Zsh](https://ohmyz.sh/)** - Zsh framework
- **[Starship](https://starship.rs/)** - Cross-shell prompt
- **[Nerd Font](https://www.nerdfonts.com/)** - For icons (recommend "MesloLGS NF")

## 🚀 Quick Install

### Automated Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# Run the installer
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### Manual Installation

1. **Install dependencies**:
```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install required tools
brew install starship zsh-syntax-highlighting zoxide direnv
```

2. **Backup existing dotfiles**:
```bash
# Backup your current configs
for file in ~/.zshrc ~/.zshenv ~/.gitconfig ~/.irbrc; do
  [ -f "$file" ] && mv "$file" "$file.backup"
done
```

3. **Create symbolic links**:
```bash
# Link shell configurations
ln -sf ~/dotfiles/shell/.zshrc ~/.zshrc
ln -sf ~/dotfiles/shell/.zshenv ~/.zshenv

# Link config files
mkdir -p ~/.config
ln -sf ~/dotfiles/config/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/config/zshfunctions.sh ~/.config/zshfunctions.sh

# Link Ruby configurations
ln -sf ~/dotfiles/ruby/.irbrc ~/.irbrc
ln -sf ~/dotfiles/ruby/.rubocop.yml ~/.rubocop.yml
ln -sf ~/dotfiles/ruby/.gemrc ~/.gemrc

# Link other configs
ln -sf ~/dotfiles/misc/.prettierrc.json ~/.prettierrc.json
```

4. **Set up environment variables**:
```bash
# Copy the environment template
mkdir -p ~/.config/env
cp ~/dotfiles/config/env/.vars.example ~/.config/env/.vars

# Edit with your values
$EDITOR ~/.config/env/.vars
```

5. **Reload your shell**:
```bash
source ~/.zshrc
```

## 📁 Directory Structure

```
dotfiles/
├── shell/              # Shell configurations
│   ├── .zshrc         # Main Zsh configuration
│   ├── .zshenv        # Environment variables
│   ├── .bashrc        # Bash compatibility
│   └── .bash_profile  # Bash login shell
│
├── config/            # Application configurations
│   ├── starship.toml  # Starship prompt theme
│   ├── zshfunctions.sh # Custom functions and aliases
│   ├── prompt_preview.png # Starship prompt screenshot
│   └── env/
│       └── .vars.example # Environment variables template
│
├── ruby/              # Ruby development
│   ├── .irbrc         # Interactive Ruby config
│   ├── .rubocop.yml   # Ruby linting rules
│   └── .gemrc         # RubyGems configuration
│
└── misc/              # Other configurations
    ├── .prettierrc.json # JavaScript/CSS formatting
    └── .tool-versions.example # asdf version manager

```

## 🎯 Key Features Explained

> **⚠️ Important**: Before using these dotfiles, review the [Unique Configurations & Opinionated Choices](#-unique-configurations--opinionated-choices) section above. Many settings are customized to specific preferences and may differ from what you're used to.

### Smart Development Server (`srv`)
The `srv` command intelligently detects your project type and runs the appropriate dev server. See the full list of supported frameworks in the Unique Configurations section above.

### Powerful Git Workflow
Custom git helpers streamline common operations. See all git workflow functions in the Unique Configurations section above.

### Ruby Development Excellence
IRB is supercharged with introspection methods, Rails helpers, and beautiful output. See the complete Ruby configuration details in the Unique Configurations section above.

### Custom Aliases & Functions
Over 50+ custom aliases and functions for productivity. See the complete list in `config/zshfunctions.sh` or review highlights in the Unique Configurations section above.

## ⚙️ Configuration

### Customizing Starship Prompt
Edit `~/.config/starship.toml` to customize your prompt. See [Starship docs](https://starship.rs/config/) for options.

### Adding Custom Functions
Create `~/.config/zshfunctions.local.sh` for personal functions that won't be tracked in Git:
```bash
# Example custom function
myproject() {
  cd ~/Development/my-awesome-project
}
```

### Environment Variables
Never commit sensitive data! Use `~/.config/env/.vars` for private environment variables:
```bash
export OPENAI_API_KEY="your-key-here"
export GITHUB_TOKEN="your-token-here"
```

### Local Git Configuration
Create `~/.gitconfig.local` for machine-specific Git settings:
```ini
[user]
  email = your.email@company.com
```

## 🔌 Included Aliases

### Git Shortcuts
- `gs` - Git status
- `gd` - Git diff
- `gl` - Git log with graph
- `gacm` - Add all and commit
- `gps` - Push with upstream

### Development
- `rc` - Rails console
- `rs` - Rails server
- `be` - Bundle exec
- `dc` - Docker compose
- `srv` - Smart dev server

### System
- `ll` - List files with details
- `..` - Go up one directory
- `reload` - Reload shell config
- `myip` - Show public IP
- `killport 3000` - Kill process on port

## 🛠 Troubleshooting

### Prompt not showing icons
Install a Nerd Font and configure your terminal to use it:
```bash
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```

### Syntax highlighting not working
Ensure zsh-syntax-highlighting is installed:
```bash
brew install zsh-syntax-highlighting
```

### Command not found errors
Make sure Homebrew is in your PATH:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshenv
```

## 📚 Additional Resources

- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Starship Configuration](https://starship.rs/config/)
- [Zsh Manual](https://zsh.sourceforge.io/Doc/)
- [Homebrew Documentation](https://docs.brew.sh/)

## 🤝 Contributing

Found a bug or have a suggestion? Feel free to:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) for the Zsh framework
- [Starship](https://starship.rs/) for the amazing prompt
- [Dracula Theme](https://draculatheme.com/) for color inspiration
- The open source community for countless tools and inspirations

---

**Happy coding!** 🎉 If you find this helpful, consider giving it a ⭐️