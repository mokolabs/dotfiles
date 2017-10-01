#!/bin/bash

PATH="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:$PATH"

# Switch Heroku account
/usr/local/bin/heroku accounts:set cinema

# Grab temporary backup link
/usr/local/bin/heroku pg:backups public-url --app beekman > /Users/patrick/Sites/beekman/database.url

# Backup database
TIME=/Users/patrick/Library/Backup/Cinema/$(date +'%Y-%m-%d').sql && curl -o $TIME `cat /Users/patrick/Sites/beekman/database.url`

# Remove temporary backup link
rm -rfd /Users/patrick/Sites/beekman/database.url

# Notify user
format="+%l:%M %p" && timestamp=$(date "$format") && timestamp=${timestamp/AM/am} && timestamp=${timestamp/PM/pm} && terminal-notifier -sound default -title "Cinema Treasures" -message "The database was backed up at $timestamp." -group "Cinema Treasures"
