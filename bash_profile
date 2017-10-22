# Configuring Our Prompt
# ======================

  # This function is called in your prompt to output your active git branch.
  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

  # This function builds your prompt. It is called below
  function prompt {
    # Define some local colors
    local         RED="\[\033[0;31m\]" # This syntax is some weird bash color thing I never
    local   LIGHT_RED="\[\033[1;31m\]" # really understood
    local        CHAR="♥"
    local   BLUE="\[\e[0;49;34m\]"

    # ♥ ☆ - Keeping some cool ASCII Characters for reference

    # Here is where we actually export the PS1 Variable which stores the text for your prompt
    export PS1="\[\e]2;\u@\h\a[\[\e[37;44;1m\]\t\[\e[0m\]]$RED\$(parse_git_branch) \[\e[32m\]\W\[\e[0m\]\n\[\e[0;31m\]$BLUE//$RED $CHAR \[\e[0m\]"
      PS2='> '
      PS4='+ '
    }

  # Finally call the function and our prompt is all pretty
  prompt

  # For more prompt coolness, check out Halloween Bash:
  # http://xta.github.io/HalloweenBash/

  # If you break your prompt, just delete the last thing you did.
  # And that's why it's good to keep your dotfiles in git too.

# Environment Variables
# =====================
  # Library Paths
  # These variables tell your shell where they can find certain
  # required libraries so other programs can reliably call the variable name
  # instead of a hardcoded path.

    # NODE_PATH
    # Node Path from Homebrew I believe
    export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

    # PYTHON_SHARE
    # Python Shared Path from Homebrew I believe
    export PYTHON_SHARE='/usr/local/share/python'

    # Those NODE & Python Paths won't break anything even if you
    # don't have NODE or Python installed. Eventually you will and
    # then you don't have to update your bash_profile

  # Configurations

    # GIT_MERGE_AUTO_EDIT
    # This variable configures git to not require a message when you merge.
    export GIT_MERGE_AUTOEDIT='no'

    # Editors
    # Tells your shell that when a program requires various editors, use sublime.
    # The -w flag tells your shell to wait until sublime exits
    export VISUAL="atom -w"
    export SVN_EDITOR="subl -w"
    export GIT_EDITOR="subl -w"
    export EDITOR="atom -w"

  # Paths

    # The USR_PATHS variable will just store all relevant /usr paths for easier usage
    # Each path is seperate via a : and we always use absolute paths.

    # A bit about the /usr directory
    # The /usr directory is a convention from linux that creates a common place to put
    # files and executables that the entire system needs access too. It tries to be user
    # independent, so whichever user is logged in should have permissions to the /usr directory.
    # We call that /usr/local. Within /usr/local, there is a bin directory for actually
    # storing the binaries (programs) that our system would want.
    # Also, Homebrew adopts this convetion so things installed via Homebrew
    # get symlinked into /usr/local
    export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"

    # Hint: You can interpolate a variable into a string by using the $VARIABLE notation as below.

    # We build our final PATH by combining the variables defined above
    # along with any previous values in the PATH variable.

    # Our PATH variable is special and very important. Whenever we type a command into our shell,
    # it will try to find that command within a directory that is defined in our PATH.
    # Read http://blog.seldomatt.com/blog/2012/10/08/bash-and-the-one-true-path/ for more on that.
    export PATH="$USR_PATHS:$PYTHON_SHARE:$PATH"
    export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH"
    # If you go into your shell and type: $PATH you will see the output of your current path.
    # For example, mine is:
    # /Users/avi/.rvm/gems/ruby-1.9.3-p392/bin:/Users/avi/.rvm/gems/ruby-1.9.3-p392@global/bin:/Users/avi/.rvm/rubies/ruby-1.9.3-p392/bin:/Users/avi/.rvm/bin:/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/local/mysql/bin:/usr/local/share/python:/bin:/usr/sbin:/sbin:

# Helpful Functions
# =====================

# A function to CD into the desktop from anywhere
# so you just type desktop.
# HINT: It uses the built in USER variable to know your OS X username

# USE: desktop
#      desktop subfolder
function desktop {
  cd /Users/$USER/Desktop/$@
}

function code {
  cd /Users/$USER/Development/code/$@
}

function cur {
  cd /Users/$USER/Development/curriculumns/$@
}

function learn-create {
  hub create learn-co-curriculum/${PWD##*/}
}

# Project Aliases
alias learn-code="cd /Users/avi/Development/code/learn-co"
alias webserver='python -m SimpleHTTPServer'
alias be='bundle exec'
# alias subl='atom'

# alias irb="pry"

# Semester Aliases
alias ruby006='cd /Users/avi/Development/semesters/ruby006'
alias ruby007='cd /Users/avi/Development/semesters/ruby007'
alias ruby009='cd /Users/avi/Development/semesters/ruby009'

# A function to easily grep for a matching process
# USE: psg postgres
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# A function to extract correctly any archive based on extension
# USE: extract imazip.zip
#      extract imatar.tar
function extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1      ;;
            *.tar.gz)   tar xzf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xjf $1      ;;
            *.tgz)      tar xzf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

bundler-installed()
{
    which bundle > /dev/null 2>&1
}

within-bundled-project()
{
    local dir="$(pwd)"
    while [ "$(dirname $dir)" != "/" ]; do
        [ -f "$dir/Gemfile" ] && return
        dir="$(dirname $dir)"
    done
    false
}

run-with-bundler()
{
    if bundler-installed && within-bundled-project; then
        bundle exec "$@"
    else
        "$@"
    fi
}

## Main program

BUNDLED_COMMANDS="${BUNDLED_COMMANDS:-
berks
cap
capify
chefspec
chef-apply
chef-client
chef-shell
chef-solo
cucumber
foodcritic
foreman
guard
haml
html2haml
jasmine
kitchen
knife
pry
rackup
rake
rake2thor
rspec
sass
sass-convert
serve
shotgun
spec
spork
strainer
thin
thor
tilt
tt
turn
tux
unicorn
unicorn_rails
}"

for CMD in $BUNDLED_COMMANDS; do
    if [[ $CMD != "bundle" && $CMD != "gem" ]]; then
        alias $CMD="run-with-bundler $CMD"
    fi
done

# Aliases
# =====================
  # LS
  alias l='ls -lah'

  # Git
  alias gst="git status"
  alias gl="git pull"
  alias gp="git push"
  alias gd="git diff | mate"
  alias gc="git commit -v"
  alias gca="git commit -v -a"
  alias gb="git branch"
  alias gba="git branch -a"

function gh-new () {
  curl -u 'aviflombaum:a6a4e3b7f60ddd811b492773aff18aa74f02de88' https://api.github.com/user/repos -d "{\"name\":\"$1\"}"
}

function cur-new () {
  curl -u 'aviflombaum:a6a4e3b7f60ddd811b492773aff18aa74f02de88' https://api.github.com/orgs/flatiron-school-curriculum/repos -d "{\"name\":\"$1\"}"
}

# Autocompletes
# =====================

  # Rake
  function _rake_cache_path() {
    # If in a Rails app, put the cache in the cache dir
    # so version control ignores it
    if [ -e 'tmp/cache' ]; then
      prefix='tmp/cache/'
    fi
    echo "${prefix}.rake_t_cache"
  }

  function rake_cache_store() {
    rake --tasks --silent > "$(_rake_cache_path)"
  }

  function rake_cache_clear() {
    rm -f .rake_t_cache
    rm -f tmp/cache/.rake_t_cache
  }

  export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}

  function _rakecomplete() {
    # error if no Rakefile
    if [ ! -e Rakefile ]; then
      echo "missing Rakefile"
      return 1
    fi

    # build cache if missing
    if [ ! -e "$(_rake_cache_path)" ]; then
      rake_cache_store
    fi

    local tasks=`awk '{print $2}' "$(_rake_cache_path)"`
    COMPREPLY=($(compgen -W "${tasks}" -- ${COMP_WORDS[COMP_CWORD]}))
    return 0
  }

  complete -o default -o nospace -F _rakecomplete rake

# Final Configurations and Plugins
# =====================
  # Git Bash Completion
  # Will activate bash git completion if installed
  # via homebrew
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi

  # RVM
  # Mandatory loading of RVM into the shell
  # This must be the last line of your bash_profile always

test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
