#!/bin/bash

# Unmount backup drives on startup
# (try twice in case drives are stubborn)
sleep 3
COUNT=1
while [ "$COUNT" -le 2 ]
do

	/usr/sbin/diskutil unmount Daily &> /dev/null
	/usr/sbin/diskutil unmount Weekly &> /dev/null
	/usr/sbin/diskutil unmount Monthly &> /dev/null

	COUNT=`expr $COUNT + 1`
	sleep 2
	
done
