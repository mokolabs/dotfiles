#!/bin/bash

# FUNCTIONS
unmount_all () {
		unmount_daily
		unmount_weekly
		unmount_monthly
		`echo '' >> /Users/patrick/Library/Logs/Backup/backup.log`
}

unmount_daily () {
	/usr/sbin/diskutil unmount Daily &> /dev/null
	`echo "$(/bin/date +"%Y-%m-%d %T %p") => Daily drive unmounted" >> /Users/patrick/Library/Logs/Backup/backup.log`
}

unmount_weekly () {
	/usr/sbin/diskutil unmount Weekly &> /dev/null
	`echo "$(/bin/date +"%Y-%m-%d %T %p") => Weekly drive unmounted" >> /Users/patrick/Library/Logs/Backup/backup.log`
}

unmount_monthly () {
	/usr/sbin/diskutil unmount Monthly &> /dev/null
	`echo "$(/bin/date +"%Y-%m-%d %T %p") => Monthly drive unmounted" >> /Users/patrick/Library/Logs/Backup/backup.log`
}

# Add line break to backup console output before we start
`echo '' >> /Users/patrick/Library/Logs/Backup/backup.log`

# Unmount single drives (with `unmount {drive}`)
if [ "$1" = "daily" ]; then
	unmount_daily
elif [ "$1" = "weekly" ]; then
	unmount_weekly
elif [ "$1" = "monthly" ]; then
	unmount_monthly
# Unmount all backup drives (with `unmount` or `unmount all`)
elif [ "$1" = "all" ]; then
	unmount_all
else
	unmount_all
fi

# Add line break to backup console output when we finish
`echo '' >> /Users/patrick/Library/Logs/Backup/backup.log`
