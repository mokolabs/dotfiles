#!/usr/bin/env sh

dotfiles="$HOME/.dotfiles"

# to error out
warn() {
  echo "$1" >&2
}

die() {
  warn "$1"
  exit 1
}

lnif() {
  if [ ! -e $2 ] ; then
    ln -s $1 $2
  fi
}

# Get latest changes
echo "UPDATING DOTFILES\n"
cd $dotfiles && git pull > /dev/null 2>&1

# bash
echo "Setting up bash...\n"
lnif $dotfiles/bash_profile $HOME/.bash_profile

# ruby
echo "Setting up dev tools...\n"
lnif $dotfiles/gitconfig $HOME/.gitconfig
lnif $dotfiles/git-completion.bash $HOME/.git-completion.bash

# atom
# (manually copy stylesheet because atom can't use symlinks)
echo "Setting up atom...\n"
rm $HOME/.atom/styles.less > /dev/null 2>&1
cp $dotfiles/styles.less $HOME/.atom/styles.less

# crontab
echo "Setting up crontab...\n"
echo "Reminder: crontab must be installed manually!\n"
echo "crontab -e, copy paste ~/.dotfiles/crontab into cron, and then save\n"
