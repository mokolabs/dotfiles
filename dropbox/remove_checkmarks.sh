#!/bin/bash

# Check if overlay-uptodate.icns exists
# If exists...
# - Rename overlay-uptodate.icns to overlay-uptodate.icns.bak
# - Restart Finder
# If missing...
# - Do nothing (since overlay-uptodate.icns has already been renamed)

[ -f /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns ] && /bin/mv /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns.bak && /usr/bin/killall Finder && /usr/local/bin/terminal-notifier -sound default -title 'Dropbox' -message "The green checkmark icon has been removed."
