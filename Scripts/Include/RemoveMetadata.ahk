#NoEnv
#SingleInstance Force
SetBatchLines, -1

; -------------------------------------------------------------
; Variable Setup
; -------------------------------------------------------------
TargetRoot := A_ScriptDir . "\..\..\Accounts\Saved\"
InputChars := ""
RenameCount := 0
SkipCount := 0
DebugMode := 0  ; Set to 1 to enable debug mode

; -------------------------------------------------------------
; Script Start
; -------------------------------------------------------------
GoSub, GetUserInput

if (InputChars = "CANCEL") {
    MsgBox, 64, Exit, User cancelled the operation.
    ExitApp
}

GoSub, RenameFiles

MsgBox, 64, Complete, File renaming operation finished.`n`nFiles renamed: %RenameCount%`nFiles skipped: %SkipCount%
ExitApp

; -------------------------------------------------------------
; Function: Get user input
; -------------------------------------------------------------
GetUserInput:
    global InputChars
    
    InputBox, InputChars, Remove Characters, Please enter one or more letters you want to remove from within parentheses in the XML file names (e.g., XB):
    
    if (ErrorLevel) {
        InputChars := "CANCEL"
        return
    }
    
    StringReplace, InputChars, InputChars, %A_Space%, , All
    StringUpper, InputChars, InputChars
    
    if (!RegExMatch(InputChars, "^[A-Z]+$")) {
        MsgBox, 48, Error, Invalid input. Please enter one or more English letters (no numbers or symbols).
        GoSub, GetUserInput
        return
    }
return

; -------------------------------------------------------------
; Function: Execute file renaming
; -------------------------------------------------------------
RenameFiles:
    global TargetRoot, InputChars, RenameCount, SkipCount, DebugMode
    RenameCount := 0
    SkipCount := 0
    DebugLog := ""
    FileCount := 0
    
    if !InStr(FileExist(TargetRoot), "D") {
        MsgBox, 16, Error, Target directory does not exist:`n%TargetRoot%
        return
    }
    
    Loop, %TargetRoot%*, 2, 0
    {
        FolderName := A_LoopFileName
        
        ; Only process folders numbered 1-30
        if (FolderName < 1 || FolderName > 30)
            continue
        
        ; Ensure it's a pure number (no letters or symbols)
        if FolderName is not integer
            continue
        
        CurrentDir := A_LoopFileFullPath
        
        if (DebugMode && FileCount = 0) {
            DebugLog .= "Processing folder: " . FolderName . "`n`n"
        }
            
            Loop, %CurrentDir%\*.xml, 1, 0
            {
                FileCount++
                OldFullPath := A_LoopFileFullPath
                OldFileName := A_LoopFileName
                
                ; Manually extract BaseName (filename without extension)
                BaseName := A_LoopFileName
                StringReplace, BaseName, BaseName, .xml, , All
                
                ; Debug: Show first 3 files
                if (DebugMode && FileCount <= 3) {
                    DebugLog .= "File #" . FileCount . ": " . OldFileName . "`n"
                    DebugLog .= "  BaseName: " . BaseName . "`n"
                }
                
                ; Extract content from the LAST set of parentheses
                if (!RegExMatch(BaseName, ".*\((.*?)\)$", Match) || Match1 = "") {
                    if (DebugMode && FileCount <= 3) {
                        DebugLog .= "  Result: No parentheses found or empty`n`n"
                    }
                    SkipCount++
                    continue
                }
                
                ParenthesesContent := Match1
                OriginalContent := ParenthesesContent
                
                if (DebugMode && FileCount <= 3) {
                    DebugLog .= "  Found in (): " . ParenthesesContent . "`n"
                }
                
                ; Remove specified characters
                ShouldRename := 0
                Loop, Parse, InputChars
                {
                    CharToRemove := A_LoopField
                    if InStr(ParenthesesContent, CharToRemove) {
                        StringReplace, ParenthesesContent, ParenthesesContent, %CharToRemove%, , All
                        ShouldRename := 1
                    }
                }
                
                if (DebugMode && FileCount <= 3) {
                    DebugLog .= "  After removal: " . ParenthesesContent . "`n"
                    DebugLog .= "  Should rename: " . ShouldRename . "`n"
                }
                
                if (!ShouldRename) {
                    if (DebugMode && FileCount <= 3) {
                        DebugLog .= "  Result: No matching characters to remove`n`n"
                    }
                    SkipCount++
                    continue
                }
                
                ; Construct new filename (replace the LAST occurrence)
                NewContent := ParenthesesContent
                
                ; If all characters removed, remove the entire parentheses
                if (NewContent = "") {
                    NewBaseName := RegExReplace(BaseName, "_?\(" . RegExEscape(OriginalContent) . "\)$", "")
                } else {
                    ; Otherwise, replace with new content
                    NewBaseName := RegExReplace(BaseName, "\(" . RegExEscape(OriginalContent) . "\)$", "(" . NewContent . ")")
                }
                
                NewFileName := NewBaseName . ".xml"
                NewFullPath := CurrentDir . "\" . NewFileName
                
                if (DebugMode && FileCount <= 3) {
                    DebugLog .= "  New name: " . NewFileName . "`n"
                }
                
                if (NewFileName = OldFileName) {
                    if (DebugMode && FileCount <= 3) {
                        DebugLog .= "  Result: New name same as old`n`n"
                    }
                    SkipCount++
                    continue
                }
                
                ; Check for conflicts
                if FileExist(NewFullPath) {
                    MsgBox, 48, Warning, Target file already exists:`n%NewFileName%`nSkipping this file.
                    SkipCount++
                    continue
                }
                
                ; Preserve modification time and rename
                FileGetTime, OldMTime, %OldFullPath%, M
                FileMove, %OldFullPath%, %NewFullPath%
                
                if (ErrorLevel) {
                    MsgBox, 16, Error, Failed to rename file:`n%OldFileName% -> %NewFileName%`nError Code: %ErrorLevel%
                    SkipCount++
                } else {
                    FileSetTime, %OldMTime%, %NewFullPath%, M
                    RenameCount++
                    ToolTip, Processing: %RenameCount% files renamed...
                    
                    if (DebugMode && FileCount <= 3) {
                        DebugLog .= "  Result: SUCCESS!`n`n"
                    }
                }
            }
        }
    
    
    ; Show debug log if enabled
    if (DebugMode && DebugLog != "") {
        MsgBox, 64, Debug Info, %DebugLog%
    }
    
    ToolTip
return

RegExEscape(Text) {
    StringReplace, Text, Text, \, \\, All
    StringReplace, Text, Text, [, \[, All
    StringReplace, Text, Text, ], \], All
    StringReplace, Text, Text, (, \(, All
    StringReplace, Text, Text, ), \), All
    StringReplace, Text, Text, {, \{, All
    StringReplace, Text, Text, }, \}, All
    StringReplace, Text, Text, *, \*, All
    StringReplace, Text, Text, +, \+, All
    StringReplace, Text, Text, ?, \?, All
    StringReplace, Text, Text, ., \., All
    StringReplace, Text, Text, $, \$, All
    StringReplace, Text, Text, ^, \^, All
    StringReplace, Text, Text, |, \|, All
    Return Text
}