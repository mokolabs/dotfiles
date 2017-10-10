#!/bin/bash

# Switch Heroku account
/usr/local/bin/heroku accounts:set cinema

# Grab temporary backup link
/usr/local/bin/heroku pg:backups public-url --app beekman > /Users/patrick/Sites/beekman/database.url

# Backup database
TIME=/Users/patrick/Library/Backup/Cinema/$(date +'%Y-%m-%d').sql && curl -o $TIME `cat /Users/patrick/Sites/beekman/database.url`

# Remove temporary backup link
/bin/rm -rfd /Users/patrick/Sites/beekman/database.url

# Notify user
format="+%l:%M %p" && timestamp=$(date "$format") && timestamp=${timestamp/AM/am} && timestamp=${timestamp/PM/pm} && /usr/local/bin/terminal-notifier -sound default -title "Cinema Treasures" -message "The database was backed up at $timestamp." -group "Cinema Treasures"
