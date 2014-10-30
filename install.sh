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

# vim
echo "Setting up atom...\n"
lnif $dotfiles/styles.less $HOME/.atom/styles.less
