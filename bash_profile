# Set PATH
export PATH="/usr/local/heroku/bin:$PATH"                                # Heroku CLI
export PATH="/usr/local/sbin:$PATH"                                      # Homebrew
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH" # Postgres.app

# Set X11 display
export DISPLAY=:0.0

# Customize prompt
export PS1="\h:\w \$(get_git_branch)$ "

# Use colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Use case insensitivity for tab completion
bind "set completion-ignore-case on"

# Open gems with Atom
export GEM_OPEN_EDITOR=atom

# Edit with nano
export EDITOR=nano

# Simplify rake command
rake() {
  # If Gemfile is present, you can omit `bundle exec` prefix
  if [ -e ./Gemfile.lock ]; then 
    bundle exec rake "$@";
  # Otherwise, use rake normally
  else
    /usr/bin/env rake "$@";
  fi
}

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Auto-trash ~/Applications
[ -d "~Applications" ] || mv ~/Applications/ ~/.Trash > /dev/null 2>&1

# Git auto completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Aliases (system)
alias desktop="cd ~/Desktop"
alias dots="cd ~/.dotfiles"
alias dotfiles="cd ~/.dotfiles"
alias setup="/usr/local/bin/atom ~/Dropbox/Config/Setup/"
alias reload="source ~/.bash_profile"
alias reset="source ~/.bash_profile"

# Aliases (navigation)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Aliases (git)
alias add="git add"
alias branch="git branch"
alias checkout="git checkout"
alias commit="git commit"
alias pull="git pull"
alias push="git push"
alias stash="git stash"
alias status="git status"
alias diffc="git diff --cached"

# Aliases (backup)
alias backup="cd ~/Library/Backup/Scripts"
alias daily="/usr/sbin/diskutil mount Daily &> /dev/null"
alias weekly="/usr/sbin/diskutil mount Weekly &> /dev/null"
alias monthly="/usr/sbin/diskutil mount Monthly &> /dev/null"
alias mount="sh ~/.drive_mount.sh"
alias unmount="sh ~/.drive_unmount.sh"

# Aliases (web apps)
alias launch="osascript ~/.launcher.applescript"
alias sites="cd ~/Sites/"
alias cinema="cd ~/Sites/beekman"
alias crowley="cd ~/Sites/crowleyportraits"
alias g="cd ~/Sites/graffletopia"
alias graffle="cd ~/Sites/graffletopia"
alias moko="cd ~/Sites/mokolabs"
for a in `cd ~/Sites; ls | grep -Ev "heroku"`; do
  alias "$a=cd ~/Sites/$a";
  complete -F _complete_alias $a;
done

# Aliases (heroku)
alias heroku=set_account_before_running_heroku_command;

# Open current directory in Atom
function a() {
  /usr/local/bin/atom $PWD
}

# Remove (or restore) dropbox up-to-date checkmark icons
function dropbox() {
  if [[ "$1" == "restore" ]]; then
    mv /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns.bak /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns && killall Finder
  elif [[ "$1" == "remove" ]]; then
    sh ~/.dropbox.remover.sh
  else
    sh ~/.dropbox.remover.sh
  fi
}

# Launch Ruby apps
function start {
  # Modern Ruby apps with a Procfile
  if [ -e ./Procfile ]; then
    bundle exec foreman start
  # Sinatra apps named app.rb
  elif [ -e ./app.rb ]; then
    bundle exec shotgun config.ru -p 3000
  # Rails 2.3.x apps
  else
    script/server
  fi
}
alias s="start"

# Switch Heroku accounts
function switch () {
  # SWITCH ACCOUNT BY REQUEST
  #  You can force switch an Heroku account by passing an argument to switch()
  #  `switch cinema`       -> switch to cinema treasures account
  #  `switch graffletopia` -> switch to graffletopia account
  #  `switch mokolabs`     -> switch to mokolabs account
  if [ -n "$1" ]; then
    if [ $1 == "cinema" ] || [ $1 == "cinematreasures" ] || [ $1 == "beekman" ]; then
      echo 'switched to cinema'
      /usr/local/heroku/bin/heroku accounts:set cinema
    fi
    if [ $1 == "graffletopia" ] || [ $1 == "graffle" ]; then
      echo 'switched to graffletopia'
      /usr/local/heroku/bin/heroku accounts:set graffletopia
    fi
    if [ $1 == "moko" ] || [ $1 == "mokolabs" ]; then
      echo 'switched to mokolabs'
      /usr/local/heroku/bin/heroku accounts:set mokolabs
    fi
  fi

  # SWITCH ACCOUNT AUTOMATICALLY
  # Cinema Treasures
  if [[ "$PWD" =~ beekman ]]; then
    /usr/local/heroku/bin/heroku accounts:set cinema
  # Graffletopia
  elif [[ "$PWD" =~ graffletopia ]]; then
    /usr/local/heroku/bin/heroku accounts:set graffletopia
  # Use mokolabs (while in all other Sites directories)
  elif [[ "$PWD" =~ Sites ]]; then
    /usr/local/heroku/bin/heroku accounts:set mokolabs
  fi
}

# Switch to correct Heroku account when navigating into or within ~/Sites
# by overriding the cd command to first change directories and then switch heroku account
function cd () {
  # Always run default cd command
  builtin cd "$@";

  # Switch Heroku accounts (if needed)
  
  # Switch Heroku accounts when navigating directories within ~Sites
  if [[ "$PWD" =~ Sites ]]; then
    switch;
  # Switch Heroku accounts when changing to a directory within ~Sites
  elif [[ "$1" =~ Sites ]]; then
    switch;
  fi

  # Run optional actions if second argument is present
  
  # Start server (and clear previous terminal output)
  if [[ "$2" == "s" ]]; then
    clear;
    start;
  # Open directory in Atom
  elif [[ "$2" == "a" ]]; then
    a;
  # Clear previous terminal output
  elif [[ "$2" == "c" ]]; then
    clear;
  # Sync dotfiles
  elif [[ "$2" == "sync" ]]; then
    /usr/bin/env sh ~/.dotfiles/install.sh bypass;
  fi
}

# Use diff alias for git diff if directory is a git repo
function diff () {
  if [ -d "$PWD/.git" ]; then
    git diff "$@"
  else
    /usr/bin/diff
  fi
}

# Use diff alias for git log if directory is a git repo
function log () {
  if [ -d "$PWD/.git" ]; then
    git log "$@"
  else
    /usr/bin/log
  fi
}

# Use reset alias for git reset if directory is a git repo
function reset () {
  if [ -d "$PWD/.git" ]; then
    git reset "$@"
  else
    /usr/bin/reset
  fi
}

# Verify Heroku account is correct before running heroku command
function set_account_before_running_heroku_command () {
  # Switch Heroku account
  switch;
  
  # Then run heroku command as intended
  /usr/local/heroku/bin/heroku "$@";
}

# Bounce WiFi
function bounce() {
  if [ "$1" == "bluetooth" ] || [ "$1" == "blue" ]; then
    /usr/local/bin/blueutil off; /usr/local/bin/blueutil on
  else
    /usr/sbin/networksetup -setairportpower en1 off;
    /usr/sbin/networksetup -setairportpower en1 on;
  fi
}

# Get current git branch
function get_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}


# Tweak new message notification style for Messages app
function messages {
  if [[ "$1" == "off" ]]; then
    /Users/patrick/.dotfiles/NCutil.py -a none com.apple.iChat
  elif [[ "$1" == "on" ]]; then
    /Users/patrick/.dotfiles/NCutil.py -a banners com.apple.iChat
  fi
}
