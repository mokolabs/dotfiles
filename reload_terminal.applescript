tell application "Terminal"
	# Switch to Terminal app
	activate
	
	# Get list of all windows
	set windows_list to every window
	
	# Reload bash and clear each window
	repeat with win in windows_list
		do script "reload; clear;" in win
	end repeat
end tell
