#!/Users/patrick/.rbenv/shims/ruby

# Grab temporary backup link
system "/usr/local/heroku/bin/heroku pg:backups public-url --app beekman > /Users/patrick/Sites/beekman/database.url"

# Backup database
system "TIME=/Users/patrick/Library/Backup/Cinema/$(date +'%Y-%m-%d').sql && curl -o $TIME `cat /Users/patrick/Sites/beekman/database.url`"

# Remove temporary backup link
system "rm -rfd /Users/patrick/Sites/beekman/database.url"

# Notify user
system '
format="+%l:%M %p" && timestamp=$(date "$format") && timestamp=${timestamp/AM/am} && timestamp=${timestamp/PM/pm} && terminal-notifier -sound default -title "Cinema Treasures" -message "The database was backed up at $timestamp." -group "Cinema Treasures"
'
