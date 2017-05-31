#!/bin/bash

# Load .bash_profile
source $HOME/.dotfiles/bash/bash_profile

# Get path for .dotfiles
dotfiles="$HOME/.dotfiles"

# Set variables for formatting text
normal=$(tput sgr0)
bold=$(tput bold)
white=$(tput setaf 7)
green=$(tput setaf 2)

# Define some functions
copy() {
  # copy file (when we can't use symlinks)
  echo "... copied file from:"
  source_file $1
  target_file $2
  cp -fR $1 $2
}

remove() {
  # remove file
  echo "... removed file:"
  source_file $1
  rm -rfd $1 > /dev/null 2>&1
}

link() {
  # link file (unless link already exists)
  if [ ! -e $2 ] ; then
    echo "... add link from:"
  else
    echo "... update link from:"
  fi
  source_file $1
  target_file $2
  ln -sfn $1 $2
}

source_file() {
  # print the path to our source file
  printf "    ${bold}$1 -> ${normal}"
}

target_file() {
  # print the path to our target file
  printf "${white}$1\n${green}"
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
  link $dotfiles/applescript/launcher.applescript $HOME/.launcher.applescript
  echo "... copied file from:"
  source_file "/Users/patrick/.dotfiles/applescript/Resize Finder Windows"
  target_file "/Users/patrick/Library/Services/Resize Finder Windows"
  cp -fR $dotfiles/applescript/Resize\ Finder\ Windows.workflow/ $HOME/Library/Services/Resize\ Finder\ Windows.workflow/

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
  
  # Ruby
  echo "\nRUBY"
  link $dotfiles/ruby/gemrc $HOME/.gemrc

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
      cat $dotfiles/cron/crontab
    fi

  else
    
    # Hide question prompt if any command line argument is present
    # so we can use this script via cron and ignore the cron question
    # example: `/usr/bin/env sh install.sh bypass`
    echo ""
  
  fi
  
  # Reload shell
  /usr/bin/osascript $dotfiles/applescript/reload_terminal.applescript > /dev/null 2>&1

  # Notify user we've updated dotfiles
  format="+%l:%M %p";           # customize time format
  timestamp=$(date "$format" | xargs);  # get current time
  timestamp=${timestamp/AM/am}; # lowercase AM
  timestamp=${timestamp/PM/pm}; # lowercase PM
  /usr/local/bin/terminal-notifier -sound default -title 'Dotfiles Updated' -message "Your dotfiles were updated at $timestamp."
  
# If no changes found, leave dotfiles as-is
else
  
  # say "No changes found, sir!"
  
  echo "\nNo changes found!\n";
  
fi
