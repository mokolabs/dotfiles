#!/bin/bash

# Unmount Daily drive
COUNT=1
while [ "$COUNT" -le 3 ]
do

  # Attempt to unmount drive
  diskutil unmount Daily 2>/dev/null

  # Check if drive unmounted
	CHECK_DAILY="$?"
	
  # Unmount successful
	if [ "$CHECK_DAILY" = "0" ]; then
    
    `echo "$(/bin/date +"%Y-%m-%d %T %p") => Daily drive unmounted" >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
    
    echo "unmounted daily!"

    break
    
  # Unmount failed
	else
    # Sleep 2 seconds then try again
		COUNT=`expr $COUNT + 1`
		sleep 2
	fi	

done

# Unmount Weekly drive
COUNT=1
while [ "$COUNT" -le 3 ]
do

  # Attempt to unmount drive
  diskutil unmount Weekly 2>/dev/null

  # Check if drive unmounted
	CHECK_WEEKLY="$?"
	
  # Unmount successful
	if [ "$CHECK_WEEKLY" = "0" ]; then
    
    `echo "$(/bin/date +"%Y-%m-%d %T %p") => Weekly drive unmounted" >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
    
    echo "unmounted weekly!"
    break
    
  # Unmount failed
	else
    # Sleep 2 seconds then try again
		COUNT=`expr $COUNT + 1`
		sleep 2
	fi	

done

# Unmount Monthly drive
COUNT=1
while [ "$COUNT" -le 3 ]
do

	# Attempt to unmount drive
  diskutil unmount Monthly 2>/dev/null

  # Check if drive unmounted
	CHECK_MONTHLY="$?"
	
  # Unmount successful
	if [ "$CHECK_MONTHLY" = "0" ]; then
        
    `echo "$(/bin/date +"%Y-%m-%d %T %p") => Monthly drive unmounted" >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`

    echo "unmounted monthly!"

    break
    
  # Unmount failed
	else 
    # Sleep 2 seconds then try again
		COUNT=`expr $COUNT + 1`
		sleep 2
	fi	

done

# Add line break to backup console output when we finish
`echo '' >> ~/Library/Backup/Scripts/carboncopycloner/backup.log`
