#!/usr/bin/env sh

dotfiles="$HOME/.dotfiles"

link() {
  # link file unless link already exists
  if [ ! -e $2 ] ; then
    ln -s $1 $2
  fi
}

# Get latest changes
echo "UPDATING DOTFILES\n"
cd $dotfiles && git pull > /dev/null 2>&1

# Bash
echo "...Bash profile and completion\n"
link $dotfiles/bash_profile $HOME/.bash_profile
link $dotfiles/bash_completion $HOME/.bash_completion

# Ruby
echo "...Git config and completion\n"
link $dotfiles/gitconfig $HOME/.gitconfig
link $dotfiles/git-completion.bash $HOME/.git-completion.bash

# Atom
# (manually copy stylesheet because atom can't use symlinks)
echo "...Atom styles\n"
rm $HOME/.atom/styles.less > /dev/null 2>&1
cp $dotfiles/styles.less $HOME/.atom/styles.less

# Launcher
echo "...Launcher applescript\n"
link $dotfiles/launcher.applescript $HOME/.launcher.applescript

# Drive tools
echo "...Drive tools\n"
link $dotfiles/drive_mount.sh $HOME/.drive_mount.sh
link $dotfiles/drive_unmount.sh $HOME/.drive_unmount.sh

# Crontab
# (show sample cron if user wants to see it)
echo "...Crontab (must be installed manually)"
tput sc
echo "\n   Show sample? (y/n)"
read -s input
tput rc
tput ed

if [ "$input" == "y" ] || [ "$input" == "yes" ]; then
  echo "\n\n"
  cat ~/.dotfiles/crontab
else
  echo ""
fi
