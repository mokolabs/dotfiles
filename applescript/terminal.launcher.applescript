-- Use this script to quickly switch all Terminal tabs to a specific web app or directory

-- Move this script to ~/.launcher.applescript:
-- mv launcher.applescript ~/.applescript/terminal.launcher.applescript

-- Add this alias to your ~/.bash_profile:
-- alias launch="osascript ~/.applescript/terminal.launcher.applescript"

-- Add aliases to your ~/.bash_profile for each app you need to launch
-- alias cinema="cd ~/Sites/beekman"

-- Then run the launch command like so:
-- launch cinema

on run command
	
	-- Clear bash history in all windows	
	tell application "Terminal"
		-- Switch to Terminal app
		activate

		-- Get list of all windows
		set windows_list to every window
		set windows_count to count(windows_list)
		repeat with win in windows_list

			-- Clear terminal
			do script "clear;" in win

			-- Switch to app directory
			do script command in win

			-- Clear terminal
			do script "clear;" in win
			
			-- Get window position
			set win_bounds to bounds of win
			set win_left_edge to item 1 of win_bounds
			
			-- Start app in right-most window
			if windows_count = 3 then
				if win_left_edge > 1700 then
					-- Launch app in Atom
					do script "atom ." in win
					
					-- Clear terminal
					do script "clear;" in win
					
					-- Start app
					do script "start;" in win
				end
			else if windows_count = 2 then
				if win_left_edge > 850 then
					-- Launch app in Atom
					do script "atom ." in win
					
					-- Clear terminal
					do script "clear;" in win
					
					-- Start app
					do script "start;" in win
				end
			end
		
		end repeat
		
	end tell

end run
