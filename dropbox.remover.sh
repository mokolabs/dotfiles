#!/bin/bash

# Check if overlay-uptodate.icns exists
# If exists...
# - Rename overlay-uptodate.icns to overlay-uptodate.icns.bak
# - Restart Finder
# If missing...
# - Do nothing (since overlay-uptodate.icns has already been renamed)

[ -f /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns ] && mv /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns /Applications/Dropbox.app/Contents/PlugIns/garcon.appex/Contents/Resources/overlay-uptodate.icns.bak && killall Finder
