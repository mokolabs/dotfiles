dotfiles
========

Just a few basic dotfiles that I like to use.

### Install

1. `git clone git@github.com:mokolabs/dotfiles.git ~/.dotfiles/`
2. `cd ~/.dotfiles`
2. `sh install.sh force`

### Updating via cron

You can update your dotfiles automatically by adding the following to your crontab:

```
# Update dotfiles every minute
*     *       *       *       *       /bin/sh /Users/patrick/.dotfiles/install.sh bypass
```
