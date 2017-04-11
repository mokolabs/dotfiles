# Set PATH
export PATH="/usr/local/heroku/bin:$PATH"                                # Heroku CLI
export PATH="/usr/local/sbin:$PATH"                                      # Homebrew
export PATH="/usr/local/share/npm/bin:$PATH"                             # Node
export PATH="/Applications/Postgres.app/Contents/Versions/9.4/bin:$PATH" # Postgres.app

# Customize prompt
export DISPLAY=:0.0
export PS1="\h:\w $ "

# Use colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Open gems with Atom
export GEM_OPEN_EDITOR=atom

# Edit with nano
export EDITOR=nano

# Use rake without stupid bundle rake prefix
rake() { if [ -e ./Gemfile.lock ]; then bundle exec rake "$@"; else /usr/bin/env rake "$@"; fi; }

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
alias dotfiles="cd ~/.dotfiles"
alias dotfilesup="/usr/bin/env sh ~/.dotfiles/install.sh bypass"
alias setup="/usr/local/bin/atom ~/Dropbox/Config/Setup/"
alias dropbox="mv /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns.bak; killall Finder"

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
alias graffle="cd ~/Sites/graffletopia"
alias moko="cd ~/Sites/mokolabs"
for a in `cd ~/Sites; ls | grep -Ev "heroku"`; do
  alias "$a=cd ~/Sites/$a";
  complete -F _complete_alias $a;
done

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

# Switch Heroku accounts
function cd () { builtin cd "$@" && switch; }
function switch () {
  if [ -n "$1" ]; then
    if [ $1 == "cinema" ] || [ $1 == "beekman" ]; then
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
function set_account_before_running_heroku_command(){
  switch;
  /usr/local/heroku/bin/heroku "$@";
}
alias heroku=set_account_before_running_heroku_command;

# Bounce WiFi
function bounce {
  /usr/sbin/networksetup -setairportpower en1 off;
  /usr/sbin/networksetup -setairportpower en1 on;
}
