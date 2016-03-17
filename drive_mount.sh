#!/bin/bash

# FUNCTIONS
mount_all () {
	mount_daily
	mount_weekly
	mount_monthly
}

mount_daily () {
	/usr/sbin/diskutil mount Daily &> /dev/null
	`echo "$(/bin/date +"%Y-%m-%d %T %p") => Daily drive mounted" >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
}

mount_weekly () {
	/usr/sbin/diskutil mount Weekly &> /dev/null
	`echo "$(/bin/date +"%Y-%m-%d %T %p") => Weekly drive mounted" >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
}

mount_monthly () {
	/usr/sbin/diskutil mount Monthly &> /dev/null
	`echo "$(/bin/date +"%Y-%m-%d %T %p") => Monthly drive mounted" >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
}

# Add line break between mounts
`echo '' >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`

# Mount single drives (with `mount {drive}`)
if [ "$1" = "daily" ]; then
	mount_daily
elif [ "$1" = "weekly" ]; then
	mount_weekly
elif [ "$1" = "monthly" ]; then
	mount_monthly
# Mount all backup drives (with `mount` or `mount all`)
elif [ "$1" = "all" ]; then
	mount_all
else
	mount_all
fi
