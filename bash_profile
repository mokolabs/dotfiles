# Set PATH variable
export PATH="/usr/local:/usr/local/bin:usr/local/sbin:/usr/local/share/npm/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"

# Customize prompt
export DISPLAY=:0.0
export PS1="\h:\w $ "

# Open gems with TextMate
export GEM_OPEN_EDITOR=atom

# Edit with nano (because vim blows)
export EDITOR=nano

# Use rake without stupid bundle rake prefix
rake() { if [ -e ./Gemfile.lock ]; then bundle exec rake "$@"; else /usr/bin/env rake "$@"; fi; }

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Auto-trash ~/Applications
[ -d "~Applications" ] || mv ~/Applications/ ~/.Trash > /dev/null 2>&1

# Git auto completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Default to ~/Sites
cd ~/Sites

# Aliases (system)
alias desktop="cd ~/Desktop"

# Aliases (backup)
alias backup="cd ~/Library/Backup/Scripts"
alias daily="/usr/sbin/diskutil mount Daily &> /dev/null"
alias weekly="/usr/sbin/diskutil mount Weekly &> /dev/null"
alias monthly="/usr/sbin/diskutil mount Monthly &> /dev/null"
alias mount="sh ~/Library/Backup/Scripts/drives/mount.sh"
alias unmount="sh ~/Library/Backup/Scripts/drives/unmount.sh"

# Aliases (web apps)
alias launch="osascript ~/.launcher.app"
alias beekman="cd ~/Sites/beekman"
alias cinema="cd ~/Sites/beekman"
alias crowley="cd ~/Sites/crowleyportraits"
alias crowleyportraits="cd ~/Sites/crowleyportraits"
alias graffle="cd ~/Sites/graffletopia"
alias graffletopia="cd ~/Sites/graffletopia"
alias icalshare="cd ~/Sites/icalshare"
alias jarvis="cd ~/Sites/jarvis"
alias moko="cd ~/Sites/mokolabs"
alias mokolabs="cd ~/Sites/mokolabs"
alias raise="cd ~/Sites/raise"
alias sdruby="cd ~/Sites/sdruby"
alias sites="cd ~/Sites/"

# Launch Ruby apps
function start {
  # Modern Rails/Sinatra apps
  if [ -e ./Procfile ]; then
    bundle exec foreman start
  # Rails 2.3.x apps
  else
    script/server
  fi
}
