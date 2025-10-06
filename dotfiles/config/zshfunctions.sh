#!/usr/bin/env zsh
# ═══════════════════════════════════════════════════════════════
# ZSH Functions and Aliases
# ═══════════════════════════════════════════════════════════════
#
# A collection of useful shell functions and aliases for productivity

# ═══════════════════════════════════════════════════════════════
# QUICK EDIT ALIASES
# ═══════════════════════════════════════════════════════════════

alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
alias reload="omz reload"  # Reload Oh My Zsh configuration

# Quick navigation to development directory (customize the path)
alias dev="cd ~/Development"

# Edit environment variables
envs() {
  ${EDITOR:-vim} ~/.config/env/.vars
}

# ═══════════════════════════════════════════════════════════════
# FILE BACKUP FUNCTIONS
# ═══════════════════════════════════════════════════════════════

# Create a backup of a file by adding .bak to its extension
# Usage: bak file.txt → file.bak.txt
#        bak script → script.bak
bak() {
  for i do
    case ${i##*/} in
      (?*.?*) mv -iv -- "$i" "${i%.*}.bak.${i##*.}";;
      (*) mv -iv -- "$i" "$i.bak"
    esac
  done
}

# ═══════════════════════════════════════════════════════════════
# PROCESS MANAGEMENT
# ═══════════════════════════════════════════════════════════════

# Find processes by name
# Usage: pfind chrome
pfind() {
  ps aux | grep -i "$1" | grep -v grep
}

# Kill processes by name
# Usage: pkill-name chrome
# WARNING: Uses kill -9 (SIGKILL) which forces immediate termination
# This can cause data loss. Consider using kill -15 (SIGTERM) first for graceful shutdown
pkill-name() {
  pfind "$1" | awk '{print $2}' | xargs kill -9
}

# ═══════════════════════════════════════════════════════════════
# DEVELOPMENT HELPERS
# ═══════════════════════════════════════════════════════════════

# Smart development server starter
# Detects project type and runs appropriate dev command
srv() {
  if [[ -f "package.json" ]]; then
    # Node.js project
    if [[ -f "bun.lockb" ]]; then
      bun run dev
    elif [[ -f "yarn.lock" ]]; then
      yarn dev
    elif [[ -f "pnpm-lock.yaml" ]]; then
      pnpm dev
    else
      npm run dev
    fi
  elif [[ -f "./bin/dev" ]]; then
    # Rails with bin/dev
    ./bin/dev
  elif [[ -f "Gemfile" ]]; then
    # Ruby/Rails project
    if [[ -f "Procfile.dev" ]]; then
      foreman start -f Procfile.dev
    else
      bundle exec rails server
    fi
  elif [[ -f "mix.exs" ]]; then
    # Elixir/Phoenix project
    mix phx.server
  elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
    # Python project
    if [[ -f "manage.py" ]]; then
      python manage.py runserver
    else
      echo "Python project detected but no known dev server command"
    fi
  else
    echo "Could not detect project type"
  fi
}

# ═══════════════════════════════════════════════════════════════
# GIT WORKFLOW FUNCTIONS
# ═══════════════════════════════════════════════════════════════

# Git add all and commit with message
# Usage: gacm "Initial commit"
# WARNING: This adds ALL files with 'git add .'
# Always run 'git status' first to avoid accidentally committing secrets
gacm() {
  git add .
  git commit -m "$1"
}

# Create new branch and push to origin
# Usage: gnrb feature/new-feature
gnrb() {
  git checkout -b "$1"
  git push --set-upstream origin "$1"
}

# Set upstream for current branch
git_set_upstream() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local remote_branch="origin/${branch}"
  git branch --set-upstream-to=${remote_branch} ${branch}
}

# Push with automatic upstream setting
git_push_with_upstream() {
  git_set_upstream
  git push
}

# Alias for easier usage
alias gps="git_push_with_upstream"

# Interactive git rebase
# Usage: grbi 3 (rebase last 3 commits)
grbi() {
  git rebase -i HEAD~${1:-3}
}

# ═══════════════════════════════════════════════════════════════
# YOUTUBE DOWNLOAD FUNCTIONS (requires yt-dlp)
# ═══════════════════════════════════════════════════════════════

# Download YouTube video as MP3
# Usage: youtube-mp3 "https://youtube.com/..."
youtube-mp3() {
  yt-dlp -f 'bestaudio' --extract-audio --audio-format mp3 "$1"
}

# Download YouTube video in best quality
# Usage: youtube-video "https://youtube.com/..."
youtube-video() {
  yt-dlp -f bestvideo+bestaudio --merge-output-format mp4 "$1"
}

# Download entire YouTube playlist
# Usage: youtube-playlist "https://youtube.com/playlist?..."
youtube-playlist() {
  yt-dlp -f bestvideo+bestaudio --merge-output-format mp4 --yes-playlist "$1"
}

# ═══════════════════════════════════════════════════════════════
# DEVELOPMENT PROJECT NAVIGATION
# ═══════════════════════════════════════════════════════════════

# Create your own project navigation functions
# Example:
# myproject() {
#   cd ~/Development/myproject
# }

# ═══════════════════════════════════════════════════════════════
# PERFORMANCE & DEBUGGING
# ═══════════════════════════════════════════════════════════════

# Benchmark shell startup time
# Usage: timezsh
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do
    /usr/bin/time $shell -i -c exit
  done
}

# ═══════════════════════════════════════════════════════════════
# WEB DEVELOPMENT
# ═══════════════════════════════════════════════════════════════

# Open localhost in browser
# Usage: localhost 3000
localhost() {
  local port=${1:-3000}
  open "http://localhost:$port"
}

# Kill process on a specific port
# Usage: killport 3000
# WARNING: Uses kill -9 (SIGKILL) which forces immediate termination without cleanup
killport() {
  lsof -ti:$1 | xargs kill -9
}

# ═══════════════════════════════════════════════════════════════
# RAILS HELPERS
# ═══════════════════════════════════════════════════════════════

# Create new Rails app with preferred options
# Usage: rails-new myapp
rails-new() {
  if [ -z "$1" ]; then
    echo "Error: Please provide an application name" >&2
    return 1
  fi

  rails new "$1" \
    --main \
    --skip-test \
    --skip-system-test \
    --css=tailwind \
    --database=postgresql
}

# ═══════════════════════════════════════════════════════════════
# DOCKER HELPERS
# ═══════════════════════════════════════════════════════════════

# Docker Compose shortcut
alias d-c="docker-compose"
alias dc="docker compose"

# Stop all Docker containers
docker-stop-all() {
  docker stop $(docker ps -aq)
}

# Remove all Docker containers
docker-rm-all() {
  docker rm $(docker ps -aq)
}

# Docker system cleanup
# DANGER: This deletes ALL unused containers, images, networks, AND volumes without confirmation!
# This can destroy important data. Remove the -f flag to get confirmation prompts.
# Consider using: docker system prune -a --volumes (without -f)
docker-cleanup() {
  docker system prune -a --volumes -f
}

# ═══════════════════════════════════════════════════════════════
# SYSTEM UTILITIES
# ═══════════════════════════════════════════════════════════════

# Show PATH in readable format
path() {
  echo $PATH | tr ':' '\n'
}

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ═══════════════════════════════════════════════════════════════
# NETWORK UTILITIES
# ═══════════════════════════════════════════════════════════════

# Get public IP
myip() {
  curl -s https://ipinfo.io/ip
  echo
}

# Test network speed
speedtest-cli() {
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
}

# ═══════════════════════════════════════════════════════════════
# CUSTOM ALIASES
# ═══════════════════════════════════════════════════════════════

# Common command shortcuts
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# Safety aliases
# WARNING: These create muscle memory expecting confirmation prompts
# This can be dangerous on systems without these aliases where you might
# accidentally delete files expecting a prompt that never comes.
# Consider removing these and using explicit -i flags when needed.
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Colorful outputs
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

# Quick edits
alias hosts="sudo $EDITOR /etc/hosts"

# Git shortcuts (in addition to Oh My Zsh git plugin)
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"
alias gla="git log --oneline --graph --decorate --all"

# Bundle shortcuts
alias be="bundle exec"
alias bi="bundle install"
alias bu="bundle update"

# Rails shortcuts
alias rc="rails console"
alias rs="rails server"
alias rg="rails generate"
alias rgm="rails generate migration"
alias rake="bundle exec rake"
alias rspec="bundle exec rspec"

# npm/yarn shortcuts
alias ni="npm install"
alias yi="yarn install"
alias ya="yarn add"
alias yd="yarn dev"
alias yb="yarn build"

# Python
alias py="python3"
alias pip="pip3"
alias venv="python3 -m venv"
alias activate="source venv/bin/activate"

# ═══════════════════════════════════════════════════════════════
# LOAD LOCAL CUSTOMIZATIONS
# ═══════════════════════════════════════════════════════════════

# Source local functions if they exist (for personal customizations)
if [[ -f "$HOME/.config/zshfunctions.local.sh" ]]; then
  source "$HOME/.config/zshfunctions.local.sh"
fi
