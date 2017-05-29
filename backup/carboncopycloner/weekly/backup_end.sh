#!/bin/sh

# Finish backup process
`echo "$(/bin/date +"%Y-%m-%d %T %p") => Weekly backup finished" >> /Users/patrick/Library/Logs/Backup/backup.log`

# Exit with a non-zero status so that Carbon Copy Cloner can finish backup
exit 0
