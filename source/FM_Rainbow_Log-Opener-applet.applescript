-- FM_Rainbow_Log-Opener-applet
-- version 2023-09-07, Daniel A. Shockley

(*
	A simple AppleScript applet that opens a FileMaker Import.log file in same folder using fmrl (FM_Rainbow_Log) in a new Terminal window.
	
	To get an APPLET, while this file is open in Script Editor, choose "Save As…" (hold option key to see this), then in the save dialog that appears, FIRST change the "File Format" to "Application" then choose a name ("fmrl on This Folder.app" is the default) and where to save it. 
	
	FM_Rainbow_Log can be found at https://github.com/jwillinghalpern/fm_rainbow_log
	
	HISTORY: 
		2023-09-07 ( danshockley ): Created.  
*)



on run
	set pathMyFolder to parentFolderOfPath(path to me)
	set folderName to fileNameFromPath({filePath:pathMyFolder, pathDelim:":"})
	
	set pathToImportLog to pathMyFolder & "Import.log"
	
	set shellScriptCode to "fmrl -p " & quoted form of POSIX path of pathToImportLog
	
	tell application "Terminal"
		activate
		do script shellScriptCode
		set custom title of tab 1 of window 1 to "FRML: " & folderName
	end tell
	
end run


on parentFolderOfPath(incomingPath)
	--version 1.1, Daniel A. Shockley
	-- returns path to parent folder, or ERROR if path is a disk
	
	set incomingPath to incomingPath as string
	if incomingPath is "" then
		error "Cannot find a parent folder for a path that is blank." number -1027
	end if
	
	if last character of incomingPath is ":" then
		-- if it ends with ":" (a folder), leave that off for the code below
		set incomingPath to (text 1 through -2 of incomingPath) as string
	end if
	
	set {od, AppleScript's text item delimiters} to {AppleScript's text item delimiters, ":"}
	if (count of text items of incomingPath) is 1 then
		-- the item in question is a disk, so CANNOT return a parent folder
		set AppleScript's text item delimiters to od
		error "Cannot find a parent folder of a DISK: " & incomingPath & "." number -1027
	else
		set enclosingFolder to (text items 1 through -2 of incomingPath as string)
	end if
	
	set AppleScript's text item delimiters to od
	return enclosingFolder & ":"
	
end parentFolderOfPath


on fileNameFromPath(prefs)
	-- version 2023-09-07, Daniel A. Shockley
	
	set filePath to filePath of prefs
	set pathDelim to pathDelim of prefs
	
	if filePath ends with pathDelim then set filePath to text 1 thru -2 of filePath
	
	(reverse of characters of filePath) as string
	
	text 1 thru ((offset of pathDelim in result) - 1) of result
	
	return (reverse of characters of result) as string
	
end fileNameFromPath

