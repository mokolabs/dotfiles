-- Wait three seconds
delay 3

-- Fix Finder windows
tell application "Finder"
	-- Open home directory
	open POSIX file "/Users/patrick"
	
	-- Change window size and sidebar width
	set macintosh to computer name of (system info)
	
	if macintosh is "iMac Retina" then
		set bounds of first window to {901, 441, 1659, 887}
	end if
	
	if macintosh is "iMac" then
		set bounds of first window to {901, 441, 1659, 887}
	end if
	
	if macintosh is "MacBook Air" then
		set bounds of first window to {335, 210, 1105, 678}
	end if
	
	if macintosh is "MacBook Air (Spare)" then
		set display_bounds to bounds of window of desktop
		set display_width to item 3 of display_bounds
		
		if display_width = 2560 then
			set bounds of first window to {902, 434, 1660, 902}
		else
			set bounds of first window to {298, 144, 1068, 612}
		end if
	end if
	
	-- Change sidebar width
	set the sidebar width of first window to 142
	
	-- Make a new window to save settings
	make new Finder window
	close Finder window 1
end tell
