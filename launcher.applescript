# Use this script to quickly switch all Terminal tabs to a specific web app or directory

# Move to ~/.launcher.applescript

# Add this alias to your ~/.bash_profile
# alias launch="osascript ~/.launcher.applescript"

# Add aliases to your ~/.bash_profile for each web app
# alias beekman="cd ~/Sites/beekman"
# alias cinema="cd ~/Sites/beekman"
# alias crowley="cd ~/Sites/crowleyportraits"
# alias crowleyportraits ="cd ~/Sites/crowleyportraits"
# alias graffle="cd ~/Sites/graffletopia"
# alias graffletopia="cd ~/Sites/graffletopia"
# alias icalshare="cd ~/Sites/icalshare"
# alias jarvis="cd ~/Sites/jarvis"
# alias mokolabs="cd ~/Sites/mokolabs"
# alias raise="cd ~/Sites/raise"
# alias sdruby="cd ~/Sites/sdruby"
# alias sites="cd ~/Sites/"

on run command
	
	# Clear bash history in all windows
	repeat 3 times
		tell application "System Events"
			keystroke "`" using command down
			keystroke "k" using command down
		end tell
	end repeat
	
	delay 1
	
	# Switch to app directory
	tell application "Terminal"
		activate
		do script command in window 1
		do script command in window 2
	end tell
	
	delay 1
	
	# Start app in Window 3
	tell application "System Events" to tell process "Terminal.app" to keystroke "2" using command down
	tell application "System Events" to tell process "Terminal.app" to keystroke "k" using command down
	tell application "System Events" to tell process "Terminal.app" to keystroke "start"
	tell application "System Events" to tell process "Terminal.app" to key code 36
	
	delay 1
	
	# Clear bash history in Window 1
	tell application "System Events"
		keystroke "1" using command down
		keystroke "k" using command down
	end tell
	
	delay 1
	
	# Launch app in TextMate and clear bash history in Windows 1 and 2
	tell application "Terminal"
		activate
		do script "atom README.md" in window 1
		
		tell application "System Events" to tell process "Terminal.app" to keystroke "1" using command down
		tell application "System Events" to tell process "Terminal.app" to keystroke "k" using command down
	end tell
	
end run



