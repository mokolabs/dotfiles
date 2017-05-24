dotfiles
========

Just a few basic dotfiles that I like to use.

### Install

1. `git clone git@github.com:mokolabs/dotfiles.git ~/.dotfiles/`
2. `sh install.sh`

### Updating via cron

You can update your dotfiles automatically by adding the following to your crontab:

```
# Update dotfiles every five minutes
*/5     *       *       *       *       /bin/sh /Users/patrick/.dotfiles/install.sh bypass
```
