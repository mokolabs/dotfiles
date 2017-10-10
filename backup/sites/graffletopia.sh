#!/bin/bash

# Switch Heroku account
/usr/local/bin/heroku accounts:set graffletopia

# Grab temporary backup link
/usr/local/bin/heroku pg:backups public-url --app graffletopia > /Users/patrick/Sites/graffletopia/database.url

# Backup database
TIME=/Users/patrick/Library/Backup/Graffletopia/$(date +'%Y-%m-%d').sql && /usr/bin/curl -o $TIME `cat /Users/patrick/Sites/graffletopia/database.url`

# Remove temporary backup link
/bin/rm -rfd /Users/patrick/Sites/graffletopia/database.url

# Notify user
format="+%l:%M %p" && timestamp=$(date "$format") && timestamp=${timestamp/AM/am} && timestamp=${timestamp/PM/pm} && /usr/local/bin/terminal-notifier -sound default -title "Graffletopia" -message "The database was backed up at $timestamp." -group "Graffletopia"
