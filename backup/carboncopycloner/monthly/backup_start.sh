#!/bin/bash

# Add line break between backups
`echo '' >> /Users/patrick/Library/Logs/Backup/backup.log`

# Start backup process
`echo "$(/bin/date +"%Y-%m-%d %T %p") => Monthly backup started" >> /Users/patrick/Library/Logs/Backup/backup.log`

# Exit with a non-zero status so that Carbon Copy Cloner can start backup
exit 0
