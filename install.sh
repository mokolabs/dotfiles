#!/bin/bash

# Load .bash_profile
source $HOME/.dotfiles/bash/bash_profile

# Get path for .dotfiles
dotfiles="$HOME/.dotfiles"

# Get hostname
HOST="$(hostname)"
HOST=${HOST%.local}

# Set variables for formatting text
normal=$(tput sgr0)
bold=$(tput bold)
white=$(tput setaf 7)
green=$(tput setaf 2)

# Define some functions
copy() {
  # copy file (when we can't use symlinks)
  echo "... copied file from:"
  source_file "$1"
  target_file "$2"
  cp -fR "$1" "$2"
}

remove() {
  # remove file
  echo "... removed file:"
  source_file "$1"
  printf "\n"
  rm -rfd "$1" > /dev/null 2>&1
}

link() {
  # link file
  if [ ! -e "$2" ] ; then
    echo "... added link from:"
  else
    echo "... updated link from:"
  fi
  source_file "$1"
  target_file "$2"
  ln -sfn "$1" "$2"
}

source_file() {
  # print the path to our source file
  printf "    ${bold}$1 -> ${normal}"
}

target_file() {
  # print the path to our target file
  printf "${white}$1\n${green}"
}

add_task() {  
  # add to crontab
  (crontab -l ; echo "" ; cat "$dotfiles/cron/$1") | crontab -
  #  load cron; add breaks; add new task ; save crontab

  # log action
  ACTIONS+="...   added -> cron/$1\n"

  # clear terminal
  clear_terminal
}

skip_task() {  
  # don't add to crontab

  # log action
  ACTIONS+="... skipped -> cron/$1\n"

  # clear terminal
  clear_terminal
}

clear_terminal() {
  # clear terminal output
  tput rc   # Restore cursor to saved position
  tput el   # Clear to end of line
  tput cud1 # Move cursor down one line
  tput dl1  # Delete one cursor line
  tput dl1  # Delete one cursor line
}

# Check for changes
# say "checking for changes"
echo "\nCHECKING FOR CHANGES"

# Get repo status
STATUS="$(ssh-agent bash -c 'ssh-add -A /Users/patrick/.ssh/id_rsa > /dev/null 2>&1; cd /Users/patrick/.dotfiles; git fetch; git status -u no;')";

# Update if changes found
if echo "$STATUS" | grep -q "behind"; then
  UPDATE="true"
elif [ "$1" == "force" ]; then
  UPDATE="true"
fi

# If changes found (or `force` param is passed), update dotfiles
if [ "$UPDATE" = true ]; then

  # say "updating dotfiles now, sir"
   
  echo "\nUPDATING DOTFILES"
  echo "... Loading SSH key"
  echo "... Switching to ~/.dotfiles directory"
  echo "... Pulling changes from master repo"
  ssh-agent bash -c "ssh-add -A /Users/patrick/.ssh/id_rsa > /dev/null 2>&1; cd /Users/patrick/.dotfiles; git pull -q origin master;"
  
  # Applescript
  echo "\nAPPLESCRIPT"
  mkdir -p $HOME/.applescript/
  link $dotfiles/applescript/atom.group.applescript $HOME/.applescript/atom.group.applescript
  link $dotfiles/applescript/finder.fix.window.applescript $HOME/.applescript/finder.fix.window.applescript
  link $dotfiles/applescript/finder.fix.windows.applescript $HOME/.applescript/finder.fix.windows.applescript
  link $dotfiles/applescript/terminal.launcher.applescript $HOME/.applescript/terminal.launcher.applescript
  link $dotfiles/applescript/terminal.reload.applescript $HOME/.applescript/terminal.reload.applescript

  # Atom  
  echo "\nATOM"
  copy $dotfiles/atom/styles.less $HOME/.atom/styles.less
  link $dotfiles/atom/.atom_handler.app $HOME/.atom_handler.app
    
  # Backup
  echo "\nBACKUP"
  mkdir -p $HOME/Library/Backup/Scripts/
  mkdir -p $HOME/Library/Logs/Backup/
  link $dotfiles/backup/carboncopycloner $HOME/Library/Backup/Scripts/carboncopycloner
  link $dotfiles/backup/sites $HOME/Library/Backup/Scripts/sites
  link $HOME/Library/Logs/Backup $HOME/Library/Backup/Logs

  # Bash
  echo "\nBASH"
  link $dotfiles/bash/bash_profile $HOME/.bash
  link $dotfiles/bash/bash_profile $HOME/.bash_profile
  link $dotfiles/bash/bash_completion $HOME/.bash_completion
  
  # Drive tools
  echo "\nDRIVE"
  link $dotfiles/drive/mount.sh $HOME/.drive_mount.sh
  link $dotfiles/drive/unmount.sh $HOME/.drive_unmount.sh
  
  # Dropbox
  echo "\nDROPBOX"
  link $dotfiles/dropbox/remove_checkmarks.sh $HOME/.dropbox.remove_checkmarks.sh
  
  # Git
  echo "\nGIT"
  link $dotfiles/git/gitconfig $HOME/.gitconfig
  link $dotfiles/git/gitignore $HOME/.gitignore
  link $dotfiles/git/git-completion.bash $HOME/.git-completion.bash
  
  # LaunchAgents
  echo "\nLAUNCH AGENTS"
  copy "$dotfiles/launchagents/Load SSH key.plist" "$HOME/Library/LaunchAgents/Load SSH key.plist"
  copy "$dotfiles/launchagents/Resize Finder.plist" "$HOME/Library/LaunchAgents/Resize Finder.plist"
  if [[ "$HOST" =~ iMac ]]; then
    copy "$dotfiles/launchagents/Unmount Drives.plist" "$HOME/Library/LaunchAgents/Unmount Drives.plist"
  fi
  if [[ "$HOST" == iMac ]]; then
    copy "$dotfiles/launchagents/Homebridge.plist" "$HOME/Library/LaunchAgents/Homebridge.plist"
  fi
  if [[ "$HOST" == iMac-Retina ]]; then
    copy "$dotfiles/launchagents/Merge Atom Windows.plist" "$HOME/Library/LaunchAgents/Merge Atom Windows.plist"
  fi
  
  # Ruby
  echo "\nRUBY"
  link $dotfiles/ruby/gemrc $HOME/.gemrc
  
  # Remove old files
  echo "\nCLEANUP"
  remove $HOME/.applescript/finder.resize.applescript
  remove $HOME/.applescript/finder.window.applescript
  remove $HOME/.applescript/finder.windows.applescript
  
  # Crontab (optional)
  if [ "$1" == "force" ]; then
    
    echo "\nCRONTAB"
    tput sc
    echo "\nInstall crontab? (y/n)"
    read -s input
    clear_terminal

    # Log actions       
    ACTIONS=""

    # Show sample crontab if requested
    if [ "$input" == "y" ] || [ "$input" == "yes" ]; then

      # Remove current crontab
      crontab -r &> /dev/null;

      # Config
      crontab "$dotfiles/cron/config"

      # Development
      add_task "development"
      
      # Dropbox
      add_task "dropbox"
      
      # Photos
      add_task "photos"
      
      # Sound
      add_task "sound"
      
      # iTunes
      add_task "itunes"
      
      # Wifi
      add_task "wifi"

      # Homebridge
      tput cuu1
      echo "\nInstall tasks for Homebridge? (y/n)"
      read -s input                   
      if [ "$input" == "y" ] || [ "$input" == "yes" ]; then
        add_task "homebridge"
      else
        skip_task "homebridge"
      fi
      
      # Database
      tput cuu1
      echo "\nInstall tasks for database? (y/n)"
      read -s input                   
      if [ "$input" == "y" ] || [ "$input" == "yes" ]; then
        add_task "database"
      else
        skip_task "database"
      fi
      
      # Graffletopia
      tput cuu1
      echo "\nInstall tasks for graffletopia? (y/n)"
      read -s input                   
      if [ "$input" == "y" ] || [ "$input" == "yes" ]; then
        add_task "graffletopia"
      else
        skip_task "graffletopia"
      fi
      
      # Display
      tput cuu1
      echo "\nInstall tasks for display? (y/n)"
      read -s input                   
      if [ "$input" == "y" ] || [ "$input" == "yes" ]; then
        add_task "display"
      else
        skip_task "display"
      fi
      
      # Screensaver
      tput cuu1
      echo "\nInstall tasks for screensaver? (y/n)"
      read -s input                   
      if [ "$input" == "y" ] || [ "$input" == "yes" ]; then
        add_task "screensaver"
      else
        skip_task "screensaver"
      fi
      
      tput cuu1
      tput dl1
      # Finish and add closing line break
      (crontab -l ; echo "") | crontab -

      echo "$ACTIONS"
      
    else
      
      tput cuu1
      tput cuu1
      tput dl1
      echo "... skipped crontab install"
      
    fi

    # Reload terminal that was running install.sh
    # (so we load changes here too)
    reload

  else
    
    # Hide question prompt if any command line argument is present
    # so we can use this script via cron and ignore the cron question
    # example: `/usr/bin/env sh install.sh bypass`
    echo ""
  
  fi
  
  # Reload shell in open, non-busy Terminal windows
  /usr/bin/osascript $HOME/.applescript/terminal.reload.applescript > /dev/null 2>&1

  # Notify user we've updated dotfiles
  format="+%l:%M %p";           # customize time format
  timestamp=$(date "$format" | xargs);  # get current time
  timestamp=${timestamp/AM/am}; # lowercase AM
  timestamp=${timestamp/PM/pm}; # lowercase PM
  /usr/local/bin/terminal-notifier -sound default -title 'Dotfiles' -message "Your dotfiles were updated at $timestamp." -group "Dotfiles"
  
# If no changes found, leave dotfiles as-is
else
  
  # say "No changes found, sir!"
  echo "\nNo changes found!\n";
  
fi
