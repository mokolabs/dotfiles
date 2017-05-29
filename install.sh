#!/bin/bash

# Load .bash_profile
source $HOME/.bash_profile

# Get path for .dotfiles
dotfiles="$HOME/.dotfiles"

# Define some functions
copy() {
  # copy file (when we can't use symlinks)
  echo "... copied file from $1 -> $2";
  cp -R $1 $2
}

remove() {
  # remove file
  echo "... removed $1";
  rm -rfd $1 > /dev/null 2>&1
}

link() {
  # link file (unless link already exists)
  if [ ! -e $2 ] ; then
    echo "... add link from $2 -> $1";
    ln -s $1 $2;
  else
    echo "... found link from $2 -> $1";
  fi
}

# Check for changes
echo "\nCHECKING FOR CHANGES"
OUTPUT="$(ssh-agent bash -c 'ssh-add -A /Users/patrick/.ssh/id_rsa > /dev/null 2>&1; cd /Users/patrick/.dotfiles; git status -u no | grep "up-to-date";')";

# If changes found (or `force` param is passed), update dotfiles
if [ -z "$OUTPUT" ] || [ "$1" == "force" ]; then

  echo "\nUPDATING DOTFILES"
  echo "... Loading SSH key"
  echo "... Switching to ~/.dotfiles directory"
  echo "... Pulling changes from master repo"
  ssh-agent bash -c "ssh-add -A /Users/patrick/.ssh/id_rsa > /dev/null 2>&1; cd /Users/patrick/.dotfiles; git pull -q origin master;";
  
  # Bash
  echo "\nBASH PROFILE AND COMPLETION"
  link $dotfiles/bash_profile $HOME/.bash
  link $dotfiles/bash_profile $HOME/.bash_profile
  link $dotfiles/bash_completion $HOME/.bash_completion
  
  # Git
  echo "\nGIT CONFIG AND COMPLETION"
  link $dotfiles/gitconfig $HOME/.gitconfig
  link $dotfiles/gitignore $HOME/.gitignore
  link $dotfiles/git-completion.bash $HOME/.git-completion.bash
  
  # Ruby
  echo "\nRUBY CONFIG"
  link $dotfiles/gemrc $HOME/.gemrc
  
  echo "\nATOM CONFIG"
  remove $HOME/.atom/styles.less
  copy $dotfiles/styles.less $HOME/.atom/styles.less
  link $dotfiles/.atom_handler.app $HOME/.atom_handler.app
  
  # Launcher
  echo "\nLAUNCHER APPLESCRIPT"
  link $dotfiles/launcher.applescript $HOME/.launcher.applescript
  
  # Services
  echo "\nSERVICES"
  echo "... copied Resize Finder Windows"
  cp -fR Resize\ Finder\ Windows.workflow/ ~/Library/Services/Resize\ Finder\ Windows.workflow/
  
  # Drive tools
  echo "\nDRIVE TOOLS"
  link $dotfiles/drive_mount.sh $HOME/.drive_mount.sh
  link $dotfiles/drive_unmount.sh $HOME/.drive_unmount.sh
  
  # Backup
  echo "\nBACKUP TOOLS"
  mkdir -p $HOME/Library/Backup/Scripts/
  mkdir -p $HOME/Library/Logs/Backup/
  link $dotfiles/backup/carboncopycloner $HOME/Library/Backup/Scripts/carboncopycloner
  link $HOME/Library/Logs/Backup $HOME/Library/Backup/Logs

  # Dropbox
  echo "\nDROPBOX"
  link $dotfiles/dropbox.remover.sh $HOME/.dropbox.remover.sh
  
  # Crontab (optional)
  if [ $# -eq 0 ]; then
    
    tput sc                             # Save cursor position
    echo "\nShow sample crontab? (y/n)" # Ask question
    read -s input                       # Get input for question
    tput rc                             # Restore cursor to saved position
    tput el                             # Clear to end of line
    tput cud1                           # Move cursor down one line
    tput dl1                            # Delete one cursor line
    tput dl1                            # Delete one cursor line
  
    # Show sample crontab if requested
    if [ "$input" == "y" ] || [ "$input" == "yes" ]; then
      echo "SAMPLE CRONTAB\n"
      cat ~/.dotfiles/crontab
    fi

  else
    
    # Hide question prompt if any command line argument is present
    # so we can use this script via cron and ignore the cron question
    # example: `/usr/bin/env sh install.sh bypass`
    echo ""
  
  fi
  
  # Reload shell
  osascript reload_terminal.applescript > /dev/null 2>&1

  # Notify user we've updated dotfiles
  format="+%l:%M %p";           # customize time format
  timestamp=$(date "$format");  # get current time
  timestamp=${timestamp/AM/am}; # lowercase AM
  timestamp=${timestamp/PM/pm}; # lowercase PM
  terminal-notifier -sound default -title 'Dotfiles Updated' -message "Your dotfiles were updated at $timestamp."
  
# If no changes found, leave dotfiles as-is
else
  
  echo "\nNo changes found!\n";
  
fi
