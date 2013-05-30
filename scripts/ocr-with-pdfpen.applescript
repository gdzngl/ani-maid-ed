on run argv
	set this_file to POSIX file (item 1 of argv)
	tell application "PDFpen"
		open this_file as alias
		tell document 1
			ocr
			repeat while performing ocr
				delay 1
			end repeat
			delay 1
			close with saving
		end tell
	end tell
end run
