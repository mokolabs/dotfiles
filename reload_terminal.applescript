tell application "Terminal"
	# Switch to Terminal app
	activate
	
	# Get list of all windows
	set windows_list to every window
	
	# Reload bash and clear each window
	repeat with win in windows_list
		if win is not busy then
			do script "reload; clear;" in win
		end if
	end repeat
end tell
