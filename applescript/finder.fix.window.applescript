-- Resize specific Finder window
tell application "Finder"
	
	-- Get macintosh name
	set macintosh to computer name of (system info)

	-- Change window size and sidebar width	
	if macintosh is "iMac Retina" then
		set bounds of first window to {901, 469, 1659, 915}
	end if
	
	if macintosh is "iMac" then
		set bounds of first window to {901, 469, 1659, 915}
	end if
	
	if macintosh is "MacBook Pro" then
		set bounds of first window to {335, 210, 1105, 670}
	end if

	if macintosh is "MacBook Air" then
		set bounds of first window to {335, 191, 1105, 665}
	end if
	
	if macintosh is "MacBook Air (Spare)" then
		set display_bounds to bounds of window of desktop
		set display_width to item 3 of display_bounds
		
		if display_width = 2560 then
			set bounds of first window to {901, 458, 1659, 926}
		else
			set bounds of first window to {298, 172, 1068, 640}
		end if
	end if
	
	-- Change sidebar width
	set the sidebar width of first window to 142
	
end tell
