-- Move app to left display on iMac Retina
set this_mac to computer name of (system info)
if this_mac = "iMac Retina" then
  delay 1
  tell application "Atom"
    activate
    set windows_list to every window
    repeat with win in windows_list
      set bounds of win to {-1296, 23, 0, 2304}
    end repeat
  end tell
end if
