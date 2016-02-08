## ####################################
## Tasks
## ####################################
## * Research
##   - Rename files in bulk https://www.google.com/search?q=how+to+change+a+filename+in+powershell&ie=utf-8&oe=utf-8
##   - Regex https://www.youtube.com/watch?v=tjtOhZ6hq80
##   - Power Tab 

## ####################################
## Links
## ####################################
## * Restriction Settings http://www.dailyfreecode.com/code/hello-world-powershell-334.aspx
## * Why Powershell > Cmd.exe Batch Files http://windowsitpro.com/windows/powershell-why-youll-never-go-back-cmdexe-batch-files
## * Powershell vs Bash vs Cmd https://www.google.com/search?q=powershell+vs+bash+vs+cmd&ie=utf-8&oe=utf-8
## * Powershell Intro http://www.makeuseof.com/tag/6-basic-powershell-commands-get-windows/
## * CLI vs Executable https://www.google.com/search?q=powershell+vs+making+an+executable&ie=utf-8&oe=utf-8#safe=off&q=can+you+do+the+same+things+as+a+script+from+an+executable
## * RegexPal http://www.regexpal.com/
## * .net Regex Tester http://regexstorm.net/tester

## ####################################
## Notes
## ####################################
## * Syntax Reference http://cecs.wright.edu/~pmateti/Courses/233/Labs/Scripting/bashVsPowerShellTable.html
## * Syntax Reference 02 http://poshoholic.com/2009/07/08/essential-powershell-know-your-operator-and-enclosure-precedence/
## * Powershell Commands http://blogs.technet.com/b/heyscriptingguy/archive/2015/06/11/table-of-basic-powershell-commands.aspx
## * Vanilla Functions Documentation Reference https://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/ntcmds_shelloverview.mspx?mfr=true
## * Scope http://www.howtogeek.com/203778/how-scopes-affect-powershell-scripts/?PageSpeed=noscript
## * Function Parameters http://stackoverflow.com/questions/4988226/how-do-i-pass-multiple-parameters-into-a-function-in-powershell
## * Regular Expressions http://www.johndcook.com/blog/powershell_perl_regex/
## * Notepad++ CodeFolding: alt+0 // alt+shift+0

## ####################################
## Code Snippets
## ####################################
## [regex]::matches($string, '.*')
## Above expression gives whole string and returns hash table of string value and metadata.
## [regex]::matches($string, '.*') | % { $_.Value }
## Above expression gives just the value of the matched string.
##Get-ChildItem -Filter "*current*" -Recurse | Rename-Item -NewName {$_.name -replace 'current','old' } -whatif
##Get-ChildItem -Filter "*current*" -Recurse | Rename-Item -NewName {$_.name -replace 'current','old' }

## ####################################
## Debugging Shortcut
## ####################################
## Do: "Run -> Run..."
## C:\NotepadRun.bat "$(FULL_CURRENT_PATH)"



## ####################################
## Code
## ####################################

## ###########
## Functions
function Prompt([string]$message) {
	if ($message) {
		echo "Press any key to $message ..."
	} else {
		echo "Press any key to continue ..."
	}
	
	$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Exit-Prompt {
	$script:ExitMessage = "exit"
	Prompt($ExitMessage)
}

function Renaming-Walkthrough($FileNames) {
	if($FileMatches -Or $FileMatches) {
		echo ""
		echo "...Analyzing Files..."
		echo ""
		echo ""
		echo "* Original Filename Metadata: "
		echo ""
		showAnalysis
		
		$script:newFileNames = renamePreparation
		echo ""
		echo "Preparing to rename files as:"
		echo ""
		echo $newFileNames
		echo ""
		Prompt
		
	} else {
		echo ""
		echo "No file matches were found."
		Exit-Prompt
	}
}

function analyzeText ($regexInput) {
	## Regexes
	$leadWord_Exp = "^([A-Za-z]*)\b" ## WrightR
	$allWords_Exp = "\b[A-Za-z]+\b" ## This one is more complicated.
	$digits_Exp = "\b(\d+)\b" ## 1128
	$suffixes1 = "\B*(-)\B*" ## - <-- Only hyphen
	$suffixes2 = "[A-Za-z\s,_-]*" ## Dates, Signatures, etc
	$suffixes_Exp = $suffixes1 + $suffixes2 ## - Dates, Signatures, etc
	$fileExtension_Exp = "\.[A-Za-z]+" ## .txt
	
	##Implement Metadata Array
	$FileNameMetadata = @{}
	
	## Matching
	$regexInput -match $leadWord_Exp | out-null
	if($regexInput -match $leadWord_Exp) {
		$leadWord = $matches[0]
	} else {
		$leadWord = ""
	}
	$regexInput -match $digits_Exp | out-null
	if($regexInput -match $digits_Exp) {
		$digits = $matches[0]
	} else {
		$digits = ""
	}
	$regexInput -match $fileExtension_Exp | out-null
	if($regexInput -match $fileExtension_Exp) {
		$fileExtension = $matches[0]
	} else {
		$fileExtension = ""
	}
	
	$allWords = [regex]::matches($regexInput, $allWords_Exp) | % { $_.Value }
	if([regex]::matches($regexInput, $allWords_Exp) | % { $_.Value }) {
		$2ndWord = $allWords[1]
	} else {
		$2ndWord = ""
	}
	
	### Making a List ###
	$wordCount = $allWords.Length
	$suffixes = New-Object System.Collections.Generic.List[System.Object]
	
	for($i=2; $i -lt $wordCount -1; $i++) {
		if($i -eq $wordCount -2) {
			$suffixes.Add($allWords[$i])
		} else {
			$suffixes.Add($allWords[$i] + ",")
		}
	}
	
	
	## Write to Metadata Array
	$FileNameMetadata["leadWord"] = $leadWord
	$FileNameMetadata["2ndWord"] = $2ndWord
	$FileNameMetadata["digits"] = $digits
	$FileNameMetadata["fileExtension"] = $fileExtension
	
	$FileNameMetadata["suffixes"] = $suffixes
		
	return $FileNameMetadata
}

function showAnalysis {
	foreach($File in $FileNames) {
		$FileNameKeyValues = analyzeText($File)
		foreach($MetaData in $FileNameKeyValues.GetEnumerator()) {
			echo "$($MetaData.Name): `t $($MetaData.Value)"
		}
		echo ""
	}
}

function renamePreparation {
	$newFilenames= @()
	
	foreach($File in $FileNames) {
		$FileNameKeyValues = analyzeText($File)
		
		$newLeadWord = $FileNameKeyValues["2ndWord"]
		$newDigits = $FileNameKeyValues["digits"]
		$new2ndWord = $FileNameKeyValues["leadWord"]
		$newSuffixes = $FileNameKeyValues["suffixes"]
		$newFileExtension = $FileNameKeyValues["fileExtension"]
		
		$hasSuffixes = $newSuffixes
		if($hasSuffixes) {
			$newFilename = $newLeadWord + " " + $newDigits + " " + $new2ndWord + " - " + $newSuffixes + $newFileExtension
		} else {
			$newFilename = $newLeadWord + " " + $newDigits + " " + $new2ndWord + $newFileExtension
		}
		
		$newFilenames += $newFilename
	}
	
	return $newFilenames
}

function Get-Files {
	$path = Get-Location
	$script:FileMatches = Get-Childitem "* *" -File -Path "$path"
		
	$FoundFiles = @()
	foreach ($File in $FileMatches) {
		$FoundFiles += $file.name
	}
	$script:FileNames = $FoundFiles
	return $FileNames
}

function Show-Files($FileNames) {
	echo "####################################"
	echo "File Matches"
	echo "####################################"
	echo ""
	echo "The following files were found which can be renamed: "
	echo ""
	echo $FileNames
	echo ""
	echo "####################################"
	echo ""
	Prompt
}

function Rename-Files {
	if($FileMatches){
		$script:filesToRename = $FileNames
		$newNames = $newFileNames
		$newFiles = $newFileNames
				
		echo ""	
		for($i=0; $i -lt $filesToRename.Length; $i++) {
			Rename-Item $filesToRename[$i] $newNames[$i]
		}
	}
	echo ""
	echo ""
	echo "####################################"
	echo ""
	echo "Files renamed from: "
	echo ""
	echo $filesToRename
	echo ""
	echo ""
	echo "To: "
	echo ""
	echo $newFiles
	echo ""
	echo "####################################"
	echo ""
}

## ###########
## Script Runtime
$FilesNames = Get-Files
Show-Files($FileNames)
Renaming-Walkthrough($FilesNames)
Rename-Files