#!/bin/bash
source $HOME/.bash_profile

# Get path for .dotfiles
dotfiles="$HOME/.dotfiles"

# Define some functions
copy() {
  # copy file
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

# Get latest changes
echo "\nUPDATING DOTFILES"
echo "... Switching to ~/.dotfiles directory"
echo "... Pulling changes from master repo"
cd $dotfiles && git pull > /dev/null 2>&1

# Bash
echo "\nBASH PROFILE AND COMPLETION"
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

# Atom
# (manually copy stylesheet because atom can't use symlinks)
echo "\nATOM STYLES"
remove $HOME/.atom/styles.less
copy $dotfiles/styles.less $HOME/.atom/styles.less

# Launcher
echo "\nLAUNCHER APPLESCRIPT"
link $dotfiles/launcher.applescript $HOME/.launcher.applescript

# Services
echo "\nSERVICES"
echo "... removed Resize Finder Windows"
echo "... copied Resize Finder Windows"
rm -rfd ~/Library/Services/Resize\ Finder\ Windows.workflow/
cp -R Resize\ Finder\ Windows.workflow/ ~/Library/Services/Resize\ Finder\ Windows.workflow/

# Drive tools
echo "\nDRIVE TOOLS"
link $dotfiles/drive_mount.sh $HOME/.drive_mount.sh
link $dotfiles/drive_unmount.sh $HOME/.drive_unmount.sh

# Dropbox
echo "\nDROPBOX"
link $dotfiles/dropbox.remover.sh $HOME/.dropbox.remover.sh

# Crontab
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

# Hide question prompt if any command line argument is present
# so we can this script via cron and ignore the question
# example: `/usr/bin/env sh install.sh bypass`  
else
  
  echo ""

fi
