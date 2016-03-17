#!/bin/sh

# FUNCTIONS
unmount_all () {
		unmount_daily
		unmount_weekly
		unmount_monthly
		`echo '' >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
}

unmount_daily () {
	/usr/sbin/diskutil unmount Daily &> /dev/null
	`echo "$(/bin/date +"%Y-%m-%d %T %p") => Daily drive unmounted" >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
}

unmount_weekly () {
	/usr/sbin/diskutil unmount Weekly &> /dev/null
	`echo "$(/bin/date +"%Y-%m-%d %T %p") => Weekly drive unmounted" >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
}

unmount_monthly () {
	/usr/sbin/diskutil unmount Monthly &> /dev/null
	`echo "$(/bin/date +"%Y-%m-%d %T %p") => Monthly drive unmounted" >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
}

# Wait one second
sleep 1

# Add line break between unmounts (except if unmounting all drives)
if ls -1 /Volumes/ | grep ly &> /dev/null ; then 
	`echo '' >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
fi

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
