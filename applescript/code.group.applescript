-- Move app to left display on iMac Retina
set this_mac to computer name of (system info)
if this_mac = "iMac Retina" then
	delay 1
	tell application "Visual Studio Code"
		activate
		tell application "System Events"
			keystroke "f" using {control down, option down}
		end tell
	end tell
end if