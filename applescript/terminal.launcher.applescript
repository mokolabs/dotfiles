-- Use this script to quickly switch all Terminal tabs to a specific web app or directory

-- Move this script to ~/.launcher.applescript:
-- mv launcher.applescript ~/.launcher.applescript

-- Add this alias to your ~/.bash_profile:
-- alias launch="osascript ~/.launcher.applescript"

-- Add aliases to your ~/.bash_profile for each app you need to launch
-- alias cinema="cd ~/Sites/beekman"

-- Then run the launch command like so:
-- launch cinema

on run command
	
	-- Clear bash history in all windows
	repeat 3 times
		tell application "System Events"
			keystroke "`" using command down
			keystroke "k" using command down
		end tell
	end repeat
	
	delay 1
	
	-- Switch to app directory
	tell application "Terminal"
		activate
		do script command in window 1
		do script command in window 2
	end tell
	
	delay 1
	
	-- Start app in Window 3
	tell application "System Events" to tell process "Terminal.app" to keystroke "2" using command down
	tell application "System Events" to tell process "Terminal.app" to keystroke "k" using command down
	tell application "System Events" to tell process "Terminal.app" to keystroke "start"
	tell application "System Events" to tell process "Terminal.app" to key code 36
	
	delay 1
	
	-- Clear bash history in Window 1
	tell application "System Events"
		keystroke "1" using command down
		keystroke "k" using command down
	end tell
	
	delay 1
	
	-- Launch app in TextMate and clear bash history in Windows 1 and 2
	tell application "Terminal"
		activate
		do script "atom README.md" in window 1
		
		tell application "System Events" to tell process "Terminal.app" to keystroke "1" using command down
		tell application "System Events" to tell process "Terminal.app" to keystroke "k" using command down
	end tell
	
end run
