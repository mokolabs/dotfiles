#!/Users/patrick/.rbenv/shims/ruby

# Grab temporary backup link
system `/usr/local/heroku/bin/heroku pg:backups public-url --app graffletopia > /Users/patrick/Sites/graffletopia/database.url`

# Backup database
system "TIME=/Users/patrick/Library/Backup/Graffletopia/$(date +'%Y-%m-%d').sql && curl -o $TIME `cat /Users/patrick/Sites/graffletopia/database.url`"

# Remove temporary backup link
system "rm -rfd /Users/patrick/Sites/graffletopia/database.url"

# Notify user
system '
format="+%l:%M %p" && timestamp=$(date "$format") && timestamp=${timestamp/AM/am} && timestamp=${timestamp/PM/pm} && terminal-notifier -sound default -title "Graffletopia" -message "The database was backed up at $timestamp." -group "Graffletopia"
'
