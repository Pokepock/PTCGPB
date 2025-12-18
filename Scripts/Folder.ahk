#Include %A_ScriptDir%\Include\Logging.ahk
#Include %A_ScriptDir%\Include\ADB.ahk
#Include %A_ScriptDir%\Include\Gdip_All.ahk
#Include %A_ScriptDir%\Include\Gdip_Imagesearch.ahk

#Include *i %A_ScriptDir%\Include\Gdip_Extra.ahk
#Include *i %A_ScriptDir%\Include\StringCompare.ahk
#Include *i %A_ScriptDir%\Include\OCR.ahk

#SingleInstance on
;SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
;SetWinDelay, -1
;SetControlDelay, -1
SetBatchLines, -1
SetTitleMatchMode, 3
CoordMode, Pixel, Screen

; Allocate and hide the console window to reduce flashing
DllCall("AllocConsole")
WinHide % "ahk_id " DllCall("GetConsoleWindow", "ptr")

global RESTART_LOOP_EXCEPTION := { message: "Restarting main loop" }
global winTitle, changeDate, failSafe, openPack, Delay, failSafeTime, StartSkipTime, Columns, failSafe, scriptName, GPTest, StatusText, setSpeed, jsonFileName, pauseToggle, SelectedMonitorIndex, swipeSpeed, godPack, scaleParam, skipInvalidGP, deleteXML, packs, FriendID, AddFriend, Instances, showStatus, AutoSolo
global triggerTestNeeded, testStartTime, firstRun, minStars, minStarsA2b, vipIdsURL
global autoUseGPTest, autotest, autotest_time, A_gptest, TestTime, captureWebhookURL, tesseractPath, titleHeight, folderPosX

deleteAccount := false
scriptName := StrReplace(A_ScriptName, ".ahk")
winTitle := scriptName
pauseToggle := false
showStatus := true
AutoSolo := false
jsonFileName := A_ScriptDir . "\..\json\Packs.json"
IniRead, FriendID, %A_ScriptDir%\..\Settings.ini, UserSettings, FriendID
IniRead, Instances, %A_ScriptDir%\..\Settings.ini, UserSettings, Instances
IniRead, Delay, %A_ScriptDir%\..\Settings.ini, UserSettings, Delay, 250
IniRead, folderPath, %A_ScriptDir%\..\Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
IniRead, Variation, %A_ScriptDir%\..\Settings.ini, UserSettings, Variation, 20
IniRead, Columns, %A_ScriptDir%\..\Settings.ini, UserSettings, Columns, 5
IniRead, openPack, %A_ScriptDir%\..\Settings.ini, UserSettings, openPack, 1
IniRead, setSpeed, %A_ScriptDir%\..\Settings.ini, UserSettings, setSpeed, 2x
IniRead, SelectedMonitorIndex, %A_ScriptDir%\..\Settings.ini, UserSettings, SelectedMonitorIndex, 1:
IniRead, swipeSpeed, %A_ScriptDir%\..\Settings.ini, UserSettings, swipeSpeed, 350
IniRead, skipInvalidGP, %A_ScriptDir%\..\Settings.ini, UserSettings, skipInvalidGP, No
IniRead, godPack, %A_ScriptDir%\..\Settings.ini, UserSettings, godPack, Continue
IniRead, deleteMethod, %A_ScriptDir%\..\Settings.ini, UserSettings, deleteMethod, Hoard
IniRead, sendXML, %A_ScriptDir%\..\Settings.ini, UserSettings, sendXML, 0
IniRead, vipIdsURL, %A_ScriptDir%\..\Settings.ini, UserSettings, vipIdsURL
IniRead, ocrLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, ocrLanguage, en
IniRead, clientLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, clientLanguage, en
IniRead, minStars, %A_ScriptDir%\..\Settings.ini, UserSettings, minStars, 0
IniRead, minStarsA2b, %A_ScriptDir%\..\Settings.ini, UserSettings, minStarsA2b, 0

IniRead, tesseractPath, %A_ScriptDir%\..\Settings.ini, UserSettings, tesseractPath, C:\Program Files\Tesseract-OCR\tesseract.exe
IniRead, autoUseGPTest, %A_ScriptDir%\..\Settings.ini, UserSettings, autoUseGPTest, 0
IniRead, TestTime, %A_ScriptDir%\..\Settings.ini, UserSettings, TestTime, 3600
IniRead, captureWebhookURL, %A_ScriptDir%\..\Settings.ini, UserSettings, captureWebhookURL, ""
IniRead, folderPosX, %A_ScriptDir%\..\Settings.ini, UserSettings, folderPosX, 0
global fileDir, selectedFilePath, fileName, FDaddfriend, FDwishlist
global MuMuv5
MuMuv5 := isMuMuv5()
; connect adb
instanceSleep := scriptName * 1000
Sleep, %instanceSleep%

; Attempt to connect to ADB
ConnectAdb(folderPath)

resetWindows()
MaxRetries := 10
RetryCount := 0
Loop {
    try {
        WinGetPos, x, y, Width, Height, %winTitle%
        sleep, 2000
        ;Winset, Alwaysontop, On, %winTitle%
        OwnerWND := WinExist(winTitle)
        x4 := x + 4
        y4 := y + Height - 4 + 2
        buttonWidth := 45

        Gui, ToolBar:New, +Owner%OwnerWND% -AlwaysOnTop +ToolWindow -Caption +LastFound -DPIScale
        Gui, ToolBar:Default
        Gui, ToolBar:Margin, 4, 4  ; Set margin for the GUI
        Gui, ToolBar:Font, s5 cGray Norm Bold, Segoe UI  ; Normal font for input labels
        Gui, ToolBar:Add, Button, % "x" . (buttonWidth * 0) . " y0 w" . buttonWidth . " h25 gReloadScript", Reload  (Shift+F5)
        Gui, ToolBar:Add, Button, % "x" . (buttonWidth * 1) . " y0 w" . buttonWidth . " h25 gPauseScript", Pause (Shift+F6)
        Gui, ToolBar:Add, Button, % "x" . (buttonWidth * 2) . " y0 w" . buttonWidth . " h25 gResumeScript", Resume (Shift+F6)
        Gui, ToolBar:Add, Button, % "x" . (buttonWidth * 3) . " y0 w" . buttonWidth . " h25 gStopScript", Stop (Shift+F7)
        Gui, ToolBar:Add, Button, % "x" . (buttonWidth * 4) . " y0 w" . buttonWidth . " h25 gDevMode", Dev Mode (Shift+F8)
        Gui, ToolBar:Add, Button, % "x" . (buttonWidth * 5) . " y0 w" . buttonWidth . " h25 gToggleFolderInjectScript", Folder
        DllCall("SetWindowPos", "Ptr", WinExist(), "Ptr", 1  ; HWND_BOTTOM
            , "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x13)  ; SWP_NOSIZE, SWP_NOMOVE, SWP_NOACTIVATE
        Gui, ToolBar:Show, NoActivate x%x4% y%y4%  w275 h30
        break
    }
    catch {
        RetryCount++
        if (RetryCount >= MaxRetries) {
            CreateStatusMessage("Failed to create button GUI.",,,, false)
            break
        }
        Sleep, 1000
    }
    Sleep, %Delay%
    CreateStatusMessage("Creating button GUI...",,,, false)
}

rerollTime := A_TickCount
autotest := A_TickCount
A_gptest := 0

initializeAdbShell()
CreateStatusMessage("Initializing bot...",,,, false)
adbShell.StdIn.WriteLine("rm /data/data/jp.pokemon.pokemontcgp/files/UserPreferences/v1/SoloBattleResumeUserPrefs")
sleep, 5000
pToken := Gdip_Startup()
firstRun := true

global 99Configs := {}
99Configs["en"] := {leftx: 123, rightx: 162}
99Configs["es"] := {leftx: 68, rightx: 107}
99Configs["fr"] := {leftx: 56, rightx: 95}
99Configs["de"] := {leftx: 72, rightx: 111}
99Configs["it"] := {leftx: 60, rightx: 99}
99Configs["pt"] := {leftx: 127, rightx: 166}
99Configs["jp"] := {leftx: 84, rightx: 127}
99Configs["ko"] := {leftx: 65, rightx: 100}
99Configs["cn"] := {leftx: 63, rightx: 102}

99Path := "99" . clientLanguage
99Leftx := 99Configs[clientLanguage].leftx
99Rightx := 99Configs[clientLanguage].rightx
FDaddfriend := 0

Loop {
    CreateStatusMessage("Waiting for injection")
    Sleep, 200
    if (FDaddfriend)
        FolderAccountAddfriend()
    if (FDwishlist)
        FolderWishlist()

}
return

FindOrLoseImage(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", EL := 1, safeTime := 0) {
    global winTitle, Variation, failSafe
    if(searchVariation = "")
        searchVariation := Variation
    imagePath := A_ScriptDir . "\Scale125\"
    confirmed := false

    CreateStatusMessage("Finding " . imageName . "...")
    pBitmap := from_window(WinExist(winTitle))
    Path = %imagePath%%imageName%.png
    pNeedle := GetNeedle(Path)

    yBias := titleHeight - 45

    ; ImageSearch within the region
    vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, X1, Y1+yBias, X2, Y2+yBias, searchVariation)
    Gdip_DisposeImage(pBitmap)
    if(EL = 0)
        GDEL := 1
    else
        GDEL := 0
    if (!confirmed && vRet = GDEL && GDEL = 1) {
        confirmed := vPosXY
    } else if(!confirmed && vRet = GDEL && GDEL = 0) {
        confirmed := true
    }
    pBitmap := from_window(WinExist(winTitle))
    Path = %imagePath%App.png
    if (MuMuv5)
        Path = %imagePath%App2.png
    pNeedle := GetNeedle(Path)
    ; ImageSearch within the region
    vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 140, 270, 429, searchVariation)
    Gdip_DisposeImage(pBitmap)
    if (vRet = 1) {
        restartGameInstance("*Stuck at " . imageName . "...")
    }
    pBitmap := from_window(WinExist(winTitle))
    Path = %imagePath%Error.png
    pNeedle := GetNeedle(Path)
    ; ImageSearch within the region
    vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 120, 187+yBias, 155, 219+yBias, searchVariation)
    Gdip_DisposeImage(pBitmap)
    if (vRet = 1) {
        CreateStatusMessage("Error message in " . scriptName . ". Clicking retry...")
        LogToFile("Error message in " . scriptName . ". Clicking retry...")
        adbClick(139, 386)
        Sleep, 1000
        adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")
        waitadb()
    }

    if(imageName = "Social" || imageName = "Shop"){
        Notice()
    }

    if(imageName = "Country" || imageName = "Social")
        FSTime := 90
    else if(imageName = "Button")
        FSTime := 240
    else if(imageName = "Solo2")
        FSTime := 600
    else
        FSTime := 180
    if (safeTime >= FSTime) {
        LogToFile("Instance " . scriptName . " has been stuck at " . imageName . " for 90s. (EL: " . EL . ", sT: " . safeTime . ") Killing it...")
        restartGameInstance("Stuck at " . imageName . "...")
        failSafe := A_TickCount
    }
    return confirmed
}

Notice() {
    if(FindOrLoseImage(133, 479, 147, 493, , "noticex", 0)){
        Delay(3)
        adbClick_wbb(137, 485)
        Delay(1)
    }
    
    if(FindOrLoseImage(7, 311, 20, 332, , "PrivacyPolicy", 0)) {
        adbClick_wbb(136, 371)
        Delay(2)
    }

    if(FindOrLoseImage(36, 318, 56, 352, , "PrivacyPolicy2", 0)) 
        PolicyCheckScript() 

    Delay(1)

    
}

PolicyCheckScript() {
    Sleep, 1250
    adbClick_wbb(138, 335)
    Sleep, 1250
    adbClick_wbb(138, 486)
    Sleep, 1250
    loop {
        adbClick_wbb(44, 372)
        Sleep, 500
        if(FindOrLoseImage(32, 357, 59, 382, , "PolicyChecked", 0))
            break
        else if(FindOrLoseImage(233, 400, 264, 428, , "Points", 0))
            Break
        adbClick_wbb(138, 486)
        Sleep, 500
    }
    adbClick_wbb(138, 486)
    Sleep, 1250
}

FindImageAndClick(X1, Y1, X2, Y2, searchVariation := "", imageName := "DEFAULT", clickx := 0, clicky := 0, sleepTime := "", skip := false, safeTime := 0) {
    global winTitle, Variation, failSafe, confirmed
    if(searchVariation = "")
        searchVariation := Variation
    if (sleepTime = "") {
        global Delay
        sleepTime := Delay
    }
    imagePath := A_ScriptDir . "\Scale125\"
    click := false
    if(clickx > 0 and clicky > 0)
        click := true
    x := 0
    y := 0
    StartSkipTime := A_TickCount

    confirmed := false

    yBias := titleHeight - 45

    if(click) {
        adbClick(clickx, clicky)
        clickTime := A_TickCount
    }
    CreateStatusMessage("Finding and clicking " . imageName . "...")

    Loop { ; Main loop
        Sleep, 10
        if(click) {
            ElapsedClickTime := A_TickCount - clickTime
            if(ElapsedClickTime > sleepTime) {
                adbClick(clickx, clicky)
                clickTime := A_TickCount
            }
        }

        pBitmap := from_window(WinExist(winTitle))
        Path = %imagePath%%imageName%.png
        pNeedle := GetNeedle(Path)
        ;bboxAndPause(X1, Y1, X2, Y2)
        ; ImageSearch within the region
        vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, X1, Y1+yBias, X2, Y2+yBias, searchVariation)
        Gdip_DisposeImage(pBitmap)
        if (!confirmed && vRet = 1) {
            confirmed := vPosXY
        } else {
            if(skip < 45) {
                ElapsedTime := (A_TickCount - StartSkipTime) // 1000
                FSTime := 180
                if (ElapsedTime >= FSTime || safeTime >= FSTime) {
                    LogToFile("Instance " . scriptName . " has been stuck at " . imageName . " for 90s. (EL: " . ElapsedTime . ", sT: " . safeTime . ") Killing it...")
                    restartGameInstance("Stuck at " . imageName . "...") ; change to reset the instance and delete data then reload script
                    StartSkipTime := A_TickCount
                    failSafe := A_TickCount
                }
            }
        }

        pBitmap := from_window(WinExist(winTitle))
        Path = %imagePath%App.png
        if (MuMuv5)
            Path = %imagePath%App2.png
        pNeedle := GetNeedle(Path)
        ; ImageSearch within the region
        vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 15, 140, 270, 429, searchVariation)
        Gdip_DisposeImage(pBitmap)
        if (vRet = 1) {
            restartGameInstance("*Stuck at " . imageName . "...")
        }
        pBitmap := from_window(WinExist(winTitle))
        Path = %imagePath%Error.png
        pNeedle := GetNeedle(Path)
        ; ImageSearch within the region
        vRet := Gdip_ImageSearch(pBitmap, pNeedle, vPosXY, 120, 187+yBias, 155, 219+yBias, searchVariation)
        Gdip_DisposeImage(pBitmap)
        if (vRet = 1) {
            CreateStatusMessage("Error message in " . scriptName . ". Clicking retry...")
            LogToFile("Error message in " . scriptName . ". Clicking retry...")
            adbClick(139, 386)
            Sleep, 1000
        }
        
        if(imageName = "Social" || imageName = "Shop"){
            Notice()
        }

        if(skip) {
            ElapsedTime := (A_TickCount - StartSkipTime) // 1000
            if (ElapsedTime >= skip) {
                return false
                ElapsedTime := ElapsedTime/2
                break
            }
        }
        if (confirmed) {
            break
        }

    }
    return confirmed
}

resetWindows(){
    global Columns, winTitle, SelectedMonitorIndex, scaleParam, titleHeight
    IniRead, defaultLanguage, %A_ScriptDir%\..\Settings.ini, UserSettings, defaultLanguage, Scale125
    ; CreateStatusMessage("Arranging window positions and sizes")
    RetryCount := 0
    MaxRetries := 10
    Loop
    {
        try {
            ; Get monitor origin from index
            SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
            SysGet, Monitor, Monitor, %SelectedMonitorIndex%
            Title := winTitle

            instanceIndex := folderPosX

            if (MuMuv5) {
                if (defaultLanguage = "Scale125")
                    titleHeight := 50
                else if (defaultLanguage = "Scale100")
                    titleHeight := 40
            } else {
                if (defaultLanguage = "Scale125")
                    titleHeight := 45
                else if (defaultLanguage = "Scale100")
                    titleHeight := 36
            }
            borderWidth := 4 - 1
            scaleParam := 275 + 4 * 2
            rowHeight :=  titleHeight + 489 + 4  ; Adjust the height of each row
            currentRow := Floor((instanceIndex - 1) / Columns)
            y := MonitorTop + (currentRow * rowHeight) + (currentRow * 100)
            x := MonitorLeft + (Mod((instanceIndex - 1), Columns) * (scaleParam - borderWidth * 2)) - borderWidth
            WinMove, %Title%, , %x%, %y%, %scaleParam%, %rowHeight%
            break
        }
        catch {
            if (RetryCount > MaxRetries)
                CreateStatusMessage("Pausing. Can't find window " . winTitle . ".",,,, false)
            Pause
        }
        Sleep, 1000
    }
    return true
}


restartGameInstance(reason, RL := true) {
    global Delay, scriptName, adbShell, adbPath, adbPort
    Screenshot("restartGameInstance")
    ; initializeAdbShell()

    
    CreateStatusMessage("Restarting game...",,,, false)
    LogToFile("Restarted game for instance " . scriptName . ". Reason: " . reason, "Restart.txt")
    try {
        adbShell.StdIn.WriteLine("rm /data/data/jp.pokemon.pokemontcgp/files/UserPreferences/v1/SoloBattleResumeUserPrefs")
        waitadb()
        adbShell.StdIn.WriteLine("am start -S -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")
        waitadb()
    } catch e {
        LogToFile("Device not responsive during restartGameInstance. Error: " . e.Message, "Error.txt")
    }
    Sleep, 1000
    CreateStatusMessage("RESTART_LOOP_EXCEPTION")

}

ControlClick(X, Y) {
    global winTitle
    ControlClick, x%X% y%Y%, %winTitle%
}

RandomUsername() {
    FileRead, content, %A_ScriptDir%\..\usernames.txt

    values := StrSplit(content, "`r`n") ; Use `n if the file uses Unix line endings

    ; Get a random index from the array
    Random, randomIndex, 1, values.MaxIndex()

    ; Return the random value
    return values[randomIndex]
}

Screenshot(filename := "Valid") {
    global packs
    SetWorkingDir %A_ScriptDir%  ; Ensures the working directory is the script's directory

    ; Define folder and file paths
    screenshotsDir := A_ScriptDir "\..\Screenshots\Restart"
    if !FileExist(screenshotsDir)
        FileCreateDir, %screenshotsDir%

    ; File path for saving the screenshot locally
    screenshotFile := screenshotsDir "\" . A_Now . "_" . winTitle . "_" . filename . "_" . packs . "_packs.png"

    pBitmap := from_window(WinExist(winTitle))
    Gdip_SaveBitmapToFile(pBitmap, screenshotFile)

    return screenshotFile
}

; Pause Script
PauseScript:
    CreateStatusMessage("Pausing...",,,, false)
    Pause, On
return

; Resume Script
ResumeScript:
    CreateStatusMessage("Resuming...",,,, false)
    Pause, Off
    StartSkipTime := A_TickCount ;reset stuck timers
    failSafe := A_TickCount
return

; Stop Script
StopScript:
    CreateStatusMessage("Stopping script...",,,, false)
ExitApp
return

CaptureScript:
    CreateStatusMessage("Capturing...",,,, false)
    subDir := "Capture"
    global adbShell, adbPath
    SetWorkingDir %A_ScriptDir%  ; Ensures the working directory is the script's directory

    ; Define folder and file paths
    fileDir := A_ScriptDir "\..\Screenshots"
    if !FileExist(fileDir)
        FileCreateDir, fileDir
    if (subDir) {
        fileDir .= "\" . subDir
        if !FileExist(fileDir)
            FileCreateDir, fileDir
    }

    ; File path for saving the screenshot locally
    fileName := A_Now . "_" . winTitle . "_capture.png"
    filePath := fileDir "\temp.png"

    adbTakeScreenshot(filePath)
    pBitmapW := Gdip_CreateBitmapFromFile(filePath)
    pBitmap := Gdip_CloneBitmapArea(pBitmapW, 0, 108, 540, 596)
    Gdip_DisposeImage(pBitmapW)
    
    filePath := fileDir "\" . fileName
    Gdip_SaveBitmapToFile(pBitmap, filePath)
    Gdip_DisposeImage(pBitmap)
    if (captureWebhookURL)
        LogToDiscord("", filePath, True, , , captureWebhookURL)

return

ReloadScript:
    Reload
return

TestScript:
    ToggleTestScript()
return

ToggleTestScript() {
    global GPTest, triggerTestNeeded, testStartTime, firstRun
    if(!GPTest) {
        GPTest := true
        triggerTestNeeded := true
        testStartTime := A_TickCount
        CreateStatusMessage("In GP Test Mode",,,, false)
        StartSkipTime := A_TickCount ;reset stuck timers
        failSafe := A_TickCount
    }
    else {
        GPTest := false
        triggerTestNeeded := false
        totalTestTime := (A_TickCount - testStartTime) // 1000
        if (testStartTime != "" && (totalTestTime >= 180))
        {
            firstRun := True
            testStartTime := ""
        }
        CreateStatusMessage("Exiting GP Test Mode",,,, false)
    }
}

FriendAdded() {
    global AddFriend
    AddFriend++
}

; Function to create or select the JSON file
InitializeJsonFile() {
    global jsonFileName
    fileName := A_ScriptDir . "\..\json\Packs.json"
    if !FileExist(fileName) {
        ; Create a new file with an empty JSON array
        FileAppend, [], %fileName%  ; Write an empty JSON array
        jsonFileName := fileName
        return
    }
}

; Function to append a time and variable pair to the JSON file
AppendToJsonFile(variableValue) {
    global jsonFileName
    if (jsonFileName = "") {
        return
    }

    ; Read the current content of the JSON file
    FileRead, jsonContent, %jsonFileName%
    if (jsonContent = "") {
        jsonContent := "[]"
    }

    ; Parse and modify the JSON content
    jsonContent := SubStr(jsonContent, 1, StrLen(jsonContent) - 1) ; Remove trailing bracket
    if (jsonContent != "[")
        jsonContent .= ","
    jsonContent .= "{""time"": """ A_Now """, ""variable"": " variableValue "}]"

    ; Write the updated JSON back to the file
    Try FileDelete, %jsonFileName%
    FileAppend, %jsonContent%, %jsonFileName%
}

; Function to sum all variable values in the JSON file
SumVariablesInJsonFile() {
    global jsonFileName
    if (jsonFileName = "") {
        return 0
    }

    ; Read the file content
    FileRead, jsonContent, %jsonFileName%
    if (jsonContent = "") {
        return 0
    }

    ; Parse the JSON and calculate the sum
    sum := 0
    ; Clean and parse JSON content
    jsonContent := StrReplace(jsonContent, "[", "") ; Remove starting bracket
    jsonContent := StrReplace(jsonContent, "]", "") ; Remove ending bracket
    Loop, Parse, jsonContent, {, }
    {
        ; Match each variable value
        if (RegExMatch(A_LoopField, """variable"":\s*(-?\d+)", match)) {
            sum += match1
        }
    }

    ; Write the total sum to a file called "total.json"
    totalFile := A_ScriptDir . "\json\total.json"
    totalContent := "{""total_sum"": " sum "}"
    Try FileDelete, %totalFile%
    FileAppend, %totalContent%, %totalFile%

    return sum
}

from_window(ByRef image) {
    ; Thanks tic - https://www.autohotkey.com/boards/viewtopic.php?t=6517

    ; Get the handle to the window.
    image := (hwnd := WinExist(image)) ? hwnd : image

    ; Restore the window if minimized! Must be visible for capture.
    if DllCall("IsIconic", "ptr", image)
        DllCall("ShowWindow", "ptr", image, "int", 4)

    ; Get the width and height of the client window.
    VarSetCapacity(Rect, 16) ; sizeof(RECT) = 16
    DllCall("GetClientRect", "ptr", image, "ptr", &Rect)
        , width  := NumGet(Rect, 8, "int")
        , height := NumGet(Rect, 12, "int")

    ; struct BITMAPINFOHEADER - https://docs.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-bitmapinfoheader
    hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
    VarSetCapacity(bi, 40, 0)                ; sizeof(bi) = 40
        , NumPut(       40, bi,  0,   "uint") ; Size
        , NumPut(    width, bi,  4,   "uint") ; Width
        , NumPut(  -height, bi,  8,    "int") ; Height - Negative so (0, 0) is top-left.
        , NumPut(        1, bi, 12, "ushort") ; Planes
        , NumPut(       32, bi, 14, "ushort") ; BitCount / BitsPerPixel
        , NumPut(        0, bi, 16,   "uint") ; Compression = BI_RGB
        , NumPut(        3, bi, 20,   "uint") ; Quality setting (3 = low quality, no anti-aliasing)
    hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", &bi, "uint", 0, "ptr*", pBits:=0, "ptr", 0, "uint", 0, "ptr")
    obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")

    ; Print the window onto the hBitmap using an undocumented flag. https://stackoverflow.com/a/40042587
    DllCall("PrintWindow", "ptr", image, "ptr", hdc, "uint", 0x3) ; PW_CLIENTONLY | PW_RENDERFULLCONTENT
    ; Additional info on how this is implemented: https://www.reddit.com/r/windows/comments/8ffr56/altprintscreen/

    ; Convert the hBitmap to a Bitmap using a built in function as there is no transparency.
    DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hbm, "ptr", 0, "ptr*", pBitmap:=0)

    ; Cleanup the hBitmap and device contexts.
    DllCall("SelectObject", "ptr", hdc, "ptr", obm)
    DllCall("DeleteObject", "ptr", hbm)
    DllCall("DeleteDC",     "ptr", hdc)

    return pBitmap
}

~+F5::Reload
~+F6::Pause
~+F7::ExitApp
~+F8::ToggleDevMode()
~+F9::ToggleTestScript() ; hoytdj Add

ToggleSoloScript() {
    if(AutoSolo)
        AutoSolo := false
    else
        AutoSolo := true
}

bboxAndPause(X1, Y1, X2, Y2, doPause := False) {
    BoxWidth := X2-X1
    BoxHeight := Y2-Y1
    ; Create a GUI
    Gui, BoundingBox:+AlwaysOnTop +ToolWindow -Caption +E0x20
    Gui, BoundingBox:Color, 123456
    Gui, BoundingBox:+LastFound  ; Make the GUI window the last found window for use by the line below. (straght from documentation)
    WinSet, TransColor, 123456 ; Makes that specific color transparent in the gui

    ; Create the borders and show
    Gui, BoundingBox:Add, Progress, x0 y0 w%BoxWidth% h2 BackgroundRed
    Gui, BoundingBox:Add, Progress, x0 y0 w2 h%BoxHeight% BackgroundRed
    Gui, BoundingBox:Add, Progress, x%BoxWidth% y0 w2 h%BoxHeight% BackgroundRed
    Gui, BoundingBox:Add, Progress, x0 y%BoxHeight% w%BoxWidth% h2 BackgroundRed
    Gui, BoundingBox:Show, x%X1% y%Y1% NoActivate
    Sleep, 100

    if (doPause) {
        Pause
    }

    if GetKeyState("F4", "P") {
        Pause
    }

    Gui, BoundingBox:Destroy
}


MonthToDays(year, month) {
    static DaysInMonths := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    days := 0
    Loop, % month - 1 {
        days += DaysInMonths[A_Index]
    }
    if (month > 2 && IsLeapYear(year))
        days += 1
    return days
}

IsLeapYear(year) {
    return (Mod(year, 4) = 0 && Mod(year, 100) != 0) || Mod(year, 400) = 0
}

ReadFile(filename, numbers := false) {
    FileRead, content, %A_ScriptDir%\..\%filename%.txt

    if (!content)
        return false

    values := []
    for _, val in StrSplit(Trim(content), "`n") {
        cleanVal := RegExReplace(val, "[^a-zA-Z0-9]") ; Remove non-alphanumeric characters
        if (cleanVal != "")
            values.Push(cleanVal)
    }

    return values.MaxIndex() ? values : false
}

; ^e::
; msgbox ss
; pToken := Gdip_Startup()
; Screenshot()
; return

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ~~~ GP Test Mode Everying Below ~~~
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


isMuMuv5(){
    global folderPath
    mumuFolder := folderPath . "\MuMuPlayerGlobal-12.0"
    if !FileExist(mumuFolder)
        mumuFolder := folderPath . "\MuMu Player 12"
    if FileExist(mumuFolder . "\nx_main")
        return true
    return false
}

ToggleFolderInjectScript:
    global adbShell, scriptName, ocrLanguage, loadDir, fileDir
    SetWorkingDir %A_ScriptDir%
    
    ; 設定要查找的資料夾路徑
    fileDir := A_ScriptDir "\..\Accounts\Folders"
    if !FileExist(fileDir){
        msgbox Cannot find files path : %fileDir%
        return
    }
    
    ; 如果 GUI 已經存在，只需顯示即可，避免重複建立
    if WinExist("Inject Folder Account") {
        Gui, FolderInject:Show
        return
    }

    try {
        ; 建立 GUI 視窗
        Gui, FolderInject:New, , Inject Folder Account
        Gui, FolderInject:Font, s10, Segoe UI
        
        ; 提示文字
        Gui, FolderInject:Add, Text, x10 y10 w280, Enter the number of folder account (digs):
        Gui, FolderInject:Add, Edit, x10 y+5 vFileNumber w280 ; vFileNumber 用於儲存輸入
        
        buttonWidth := 90
        ; gHandleAction 處理兩個操作按鈕
        Gui, FolderInject:Add, Button, % "x10 y+15 w" . buttonWidth . " gHandleAction", Inject
        Gui, FolderInject:Add, Button, % "x+10 yp w" . buttonWidth . " gHandleAction", Addfriend
        ;Gui, FolderInject:Add, Button, % "x+10 yp w" . buttonWidth . " gHandleAction", Wishlist
        
        ; 註冊 GUI 關閉動作：讓使用者點擊 X 時隱藏視窗
        Gui, FolderInject:Show, , Inject Folder Account
        
    } catch {
        msgbox, 16, Error, Failed to create Inject Folder Account GUI
    }
return

; --- 讓使用者點擊 X 或 Alt+F4 時隱藏視窗 ---
FolderInject_Close:
    ; 清空輸入框內容，避免下次彈出時保留舊值
    GuiControl, FolderInject:, FileNumber, 
    Gui, FolderInject:Hide ; 隱藏視窗，而不是 ExitApp
return

HandleAction:
    ; 1. 獲取輸入框的內容
    Gui, FolderInject:Submit, NoHide 
    
    ; 2. 檢查輸入是否為空
    if (FileNumber = "") {
        MsgBox, 16, Error, Number cannot be empty！
        return
    }
    
    ; 3. 隱藏 GUI，讓腳本可以在後台執行
    Gui, FolderInject:Hide 
    
    ; 4. 執行檔案檢查（注入和加好友都需要知道檔案路徑）
    searchPattern := fileDir . "\" . FileNumber . "_*.xml"
    foundFile := ""
    Loop, Files, %searchPattern%
    {
        foundFile := A_LoopFileFullPath
        break
    }
    
    if (foundFile = "") {
        MsgBox, 16, Error, Number %FileNumber% _*.xml not founded .。
        return
    }
    
    ; --- 5. 根據按鈕執行不同的動作 ---
    if (A_GuiControl = "Inject") {
        ; 注入邏輯
        selectedFilePath := foundFile
        ; 假設 loadAccount() 已經定義且可行
        loadAccount() 
        tradedDir := A_ScriptDir "\..\Accounts\FolderTraded\"
        if(!FileExist(tradedDir))
            FileCreateDir, %tradedDir%
        FileMove, %selectedFilePath% , %tradedDir% 
        
    } else if (A_GuiControl = "Addfriend") {
        global UserFC
        InputBox, UserFC, ,"Enter the user friend code"
        selectedFilePath := foundFile
        loadAccount() 
        FDaddfriend := 1
        tradedDir := A_ScriptDir "\..\Accounts\FolderTraded\"
        if(!FileExist(tradedDir))
            FileCreateDir, %tradedDir%
        FileMove, %selectedFilePath% , %tradedDir% 
    } else if (A_GuiControl = "Wishlist") {
        global UserFC
        InputBox, UserFC, ,"Enter the user friend code"
        selectedFilePath := foundFile
        loadAccount() 
        FDaddfriend := 1
        FDwishlist := 1
        tradedDir := A_ScriptDir "\..\Accounts\FolderTraded\"
        if(!FileExist(tradedDir))
            FileCreateDir, %tradedDir%
        FileMove, %selectedFilePath% , %tradedDir% 
    }
return


loadAccount() {
    ; *** 必須替換成您的應用程式包名 (Package Name) ***
    PackageName := "jp.pokemon.pokemontcgp" 
    ActivityName1 := "jp.pokemon.pokemontcgp.UnityPlayerActivity"
    ActivityName2 := "com.unity3d.player.UnityPlayerActivity"
    
    ; 這是儲存使用者設定的目錄
    UserPreferencesPath := "/data/data/jp.pokemon.pokemontcgp/files/UserPreferences/v1/"
    
    ; 這是需要清理的設定檔案清單 (請根據您的應用程式調整)
    UserPreferences := ["BattleUserPrefs"
        ,"FeedUserPrefs"
        ,"FilterConditionUserPrefs"
        ,"HomeBattleMenuUserPrefs"
        ,"MissionUserPrefs"
        ,"NotificationUserPrefs"
        ,"PackUserPrefs"
        ,"PvPBattleResumeUserPrefs"
        ,"RankMatchPvEResumeUserPrefs"
        ,"RankMatchUserPrefs"
        ,"SoloBattleResumeUserPrefs"
        ,"SortConditionUserPrefs"]

    ; --- 步驟 II: 停止程式並清除舊設定 ---
    adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp") ; 
    Sleep, 200
    
    ; 刪除舊的帳號 XML 檔案
    adbShell.StdIn.WriteLine("rm -f /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml") ; 
    Sleep, 200

    ; 迴圈刪除暫存檔案 (可選，取決於您的需求)
    Loop, % UserPreferences.MaxIndex() {
        adbShell.StdIn.WriteLine("rm -f " . UserPreferencesPath . UserPreferences[A_Index])
        Sleep, 200
    }
    

    ; --- 步驟 III: 推送並配置新的 XML 檔案 ---
    
    ; 決定 XML 檔案路徑 (邏輯與源代碼相同 )
    loadFile := selectedFilePath
    ; 檢查檔案是否存在
    if (!FileExist(loadFile)) {
        MsgBox, Error, Cannot find the XML file: %loadDir%
        ExitApp
    }

    RunWait, % adbPath . " -s 127.0.0.1:" . adbPort . " push " . loadFile . " /sdcard/deviceAccount.xml",, Hide
    adbShell.StdIn.WriteLine("cp /sdcard/deviceAccount.xml /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml")
    waitadb()
    adbShell.StdIn.WriteLine("chmod 664 /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml && chown system:system /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml")
    Sleep, 200
    waitadb()
    clearMissionCache()
    waitadb()
    ; Reliably restart the app: Wait for launch, and start in a clean, new task without animation.
    adbShell.StdIn.WriteLine("am start -S -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity -f 0x10018000")
    waitadb()
    
}

clearMissionCache() {
    adbShell.StdIn.WriteLine("rm /data/data/jp.pokemon.pokemontcgp/files/UserPreferences/v1/MissionUserPrefs")
    waitadb()
    Sleep, 500
    ;TODO delete all user preferences?
}

FolderAccountAddfriend() {
    loop{
        if(FindOrLoseImage(120, 500, 155, 530, , "Social", 0))
            break
        adbClick(143,518)
        Sleep, 500

    }
    FindImageAndClick(226, 100, 270, 135, , "Add", 38, 460, 500)
    FindImageAndClick(205, 430, 255, 475, , "Search", 240, 120, 1500)
    FindImageAndClick(0, 475, 25, 495, , "OK2", 138, 454)
    value := UserFC
    if (StrLen(value) != 16) {
            MsgBox, Wrong id value !
            return
        }
    
    Loop {
            adbInput(value)
            Sleep, 250
            if(FindOrLoseImage(205, 430, 255, 475, , "Search2", 0, failSafeTime)) {
                break
            }
    }
    Loop {
            adbClick(232, 453)
            if(FindOrLoseImage(165, 250, 190, 275, , "Send", 0, failSafeTime)) {
                adbClick(243, 258)
                adbClick(243, 258)
                adbClick(243, 258)
                break
            }
            else if(FindOrLoseImage(165, 240, 255, 270, , "Withdraw", 0, failSafeTime)) {
                break
            }
            else if(FindOrLoseImage(165, 250, 190, 275, , "Accepted", 0, failSafeTime)) {
                break
            }
            Sleep, 250
    }
    loop{
        if(FindOrLoseImage(120, 500, 155, 530, , "Social", 0))
            break
        adbClick(143,518)
        Sleep, 500

    }
    FDaddfriend := 0
}

Folderwishlist(){
    loop{
        adbClick_wbb(176, 418)
        Sleep, 2000
        if(FindOrLoseImage(71, 171, 81, 181, , "friendintrade", 0))
            Break
        adbClick_wbb(141, 506)
        Sleep, 2000
        if(FindOrLoseImage(120, 500, 155, 530, , "Social", 0)){
            adbClick_wbb(176, 418)
            Sleep, 2000
        }
    }
    FindImageAndClick(71, 171, 81, 181, , "friendintrade", 176, 418, 500)
    Sleep, 500
    adbClick_wbb(214, 184)
    Sleep, 500
    loop{
        adbClick_wbb(60, 265)
        Sleep, 500
        if(FindOrLoseImage(32, 288, 77, 299, , "trade25kdusts", 0)){
            Sleep, 2000
            adbClick_wbb(142, 461)
            Break
        }
        Sleep, 200
    }
    Sleep, 2000
    FindImageAndClick(114, 71, 126, 85, , "tradecomfirm", 160, 455, 500)
    Sleep, 2000
    adbClick_wbb(180, 461)
    Sleep, 2000
    loop{
        adbClick_wbb(196, 373)
        Sleep, 500        
        if(FindOrLoseImage(187, 373, 200, 384, , "traderenew", 0))
            break
        adbClick_wbb(139, 443)
        Sleep, 500  
    }
    FindImageAndClick(51, 143, 134, 208, , "tradefinish", 226, 382, 3000)
    Sleep, 1000
    adbClick_wbb(203, 465)
    Sleep, 500
    adbClick_wbb(198, 373)
    FDwishlist := 0
}

ToggleDevMode() {

    try {
        OwnerWND := WinExist(winTitle)
        x4 := x + 5
        y4 := y + 44
        buttonWidth := 40

        Gui, DevMode%winTitle%:New, +LastFound
        Gui, DevMode%winTitle%:Font, s5 cGray Norm Bold, Segoe UI  ; Normal font for input labels
        Gui, DevMode%winTitle%:Add, Button, % "x" . (buttonWidth * 0) . " y0 w" . buttonWidth . " h25 gbboxScript", bound box

        Gui, DevMode%winTitle%:Add, Button, % "x" . (buttonWidth * 1) . " y0 w" . buttonWidth . " h25 gbboxNpauseScript", bbox pause

        Gui, DevMode%winTitle%:Add, Button, % "x" . (buttonWidth * 2) . " y0 w" . buttonWidth . " h25 gscreenshotscript", screen grab

        Gui, DevMode%winTitle%:Show, w250 h100, Dev Mode %winTitle%

    }
    catch {
        CreateStatusMessage("Failed to create button GUI.",,,, false)
    }
}

screenshotscript:
    Screenshot_dev()
return

bboxScript:
    ToggleBBox()
return

ToggleBBox() {
    dbg_bbox := !dbg_bbox
}

bboxNpauseScript:
    TogglebboxNpause()
return

TogglebboxNpause() {
    dbg_bboxNpause := !dbg_bboxNpause
}

dbg_bbox :=0
dbg_bboxNpause :=0
dbg_bbox_click :=0

ToggleStatusMessages() {
    if(showStatus) {
        showStatus := False
    }
    else
        showStatus := True
}

bboxDraw(X1, Y1, X2, Y2, color) {
    WinGetPos, xwin, ywin, Width, Height, %winTitle%
    BoxWidth := X2-X1
    BoxHeight := Y2-Y1
    ; Create a GUI
    Gui, BoundingBox%winTitle%:+AlwaysOnTop +ToolWindow -Caption +E0x20
    Gui, BoundingBox%winTitle%:Color, 123456
    Gui, BoundingBox%winTitle%:+LastFound  ; Make the GUI window the last found window for use by the line below. (straght from documentation)
    WinSet, TransColor, 123456 ; Makes that specific color transparent in the gui

    ; Create the borders and show
    Gui, BoundingBox%winTitle%:Add, Progress, x0 y0 w%BoxWidth% h2 %color%
    Gui, BoundingBox%winTitle%:Add, Progress, x0 y0 w2 h%BoxHeight% %color%
    Gui, BoundingBox%winTitle%:Add, Progress, x%BoxWidth% y0 w2 h%BoxHeight% %color%
    Gui, BoundingBox%winTitle%:Add, Progress, x0 y%BoxHeight% w%BoxWidth% h2 %color%

    xshow := X1+xwin
    yshow := Y1+ywin
    Gui, BoundingBox%winTitle%:Show, x%xshow% y%yshow% NoActivate
    Sleep, 100

}

bboxDraw2(X1, Y1, X2, Y2, color) {
    WinGetPos, xwin, ywin, Width, Height, %winTitle%
    BoxWidth := 10
    BoxHeight := 10
    Xm1:=X1-(BoxWidth/2)
    Xm2:=X2-(BoxWidth/2)
    Ym1:=Y1-(BoxWidth/2)
    Ym2:=Y2-(BoxWidth/2)
    Xh1:=Xm1+BoxWidth
    Xh2:=Xm2+BoxWidth
    Yh1:=Ym1+BoxHeight
    Yh2:=Ym2+BoxHeight

    ; Create a GUI
    Gui, BoundingBox%winTitle%:+AlwaysOnTop +ToolWindow -Caption +E0x20
    Gui, BoundingBox%winTitle%:Color, 123456
    Gui, BoundingBox%winTitle%:+LastFound  ; Make the GUI window the last found window for use by the line below. (straght from documentation)
    WinSet, TransColor, 123456 ; Makes that specific color transparent in the gui

    ; Create the borders and show
    Gui, BoundingBox%winTitle%:Add, Progress, x%Xm1% y%Ym1% w%BoxWidth% h2 %color%
    Gui, BoundingBox%winTitle%:Add, Progress, x%Xm1% y%Ym1% w2 h%BoxHeight% %color%
    Gui, BoundingBox%winTitle%:Add, Progress, x%Xh1% y%Ym1% w2 h%BoxHeight% %color%
    Gui, BoundingBox%winTitle%:Add, Progress, x%Xm1% y%Yh1% w%BoxWidth% h2 %color%

    ; Create the borders and show
    Gui, BoundingBox%winTitle%:Add, Progress, x%Xm2% y%Ym2% w%BoxWidth% h2 %color%
    Gui, BoundingBox%winTitle%:Add, Progress, x%Xm2% y%Ym2% w2 h%BoxHeight% %color%
    Gui, BoundingBox%winTitle%:Add, Progress, x%Xh2% y%Ym2% w2 h%BoxHeight% %color%
    Gui, BoundingBox%winTitle%:Add, Progress, x%Xm2% y%Yh2% w%BoxWidth% h2 %color%

    xshow := xwin
    yshow := ywin
    Gui, BoundingBox%winTitle%:Show, x%xshow% y%yshow% NoActivate
    Sleep, 100

}

adbSwipe_wbb(params) {
    if(dbg_bbox)
        bboxAndPause_swipe(params, dbg_bboxNpause)
    adbSwipe(params)
}

bboxAndPause_swipe(params, doPause := False) {
    paramsplit := StrSplit(params , " ")
    X1:=round(paramsplit[1] / 535 * 277)
    Y1:=round((paramsplit[2] / 960 * 489) + 44)
    X2:=round(paramsplit[3] / 535 * 277)
    Y2:=round((paramsplit[4] / 960 * 489) + 44)
    speed:=paramsplit[5]
    CreateStatusMessage("Swiping (" . X1 . "," . Y1 . ") to (" . X2 . "," . Y2 . ") speed " . speed,,,, false)

    color := "BackgroundYellow"

    ;bboxDraw2(X1, Y1, X2, Y2, color)

    bboxDraw(X1-5, Y1-5, X1+5, Y1+5, color)
    if (doPause) {
        Pause
    }
    Gui, BoundingBox%winTitle%:Destroy

    bboxDraw(X2-5, Y2-5, X2+5, Y2+5, color)
    if (doPause) {
        Pause
    }
    Gui, BoundingBox%winTitle%:Destroy
}

adbClick_wbb(X,Y)  {
    if(dbg_bbox)
        bboxAndPause_click(X, Y, dbg_bboxNpause)
    adbClick(X,Y)
}

bboxAndPause_click(X, Y, doPause := False) {
    CreateStatusMessage("Clicking X " . X . " Y " . Y,,,, false)

    color := "BackgroundBlue"

    bboxDraw(X-5, Y-5, X+5, Y+5, color)

    if (doPause) {
        Pause
    }

    if GetKeyState("F4", "P") {
        Pause
    }
    Gui, BoundingBox%winTitle%:Destroy
}

bboxAndPause_immage(X1, Y1, X2, Y2, pNeedleObj, vret := False, doPause := False) {
    CreateStatusMessage("Searching " . pNeedleObj.Name . " returns " . vret,,,, false)

    if(vret>0) {
        color := "BackgroundGreen"
    } else {
        color := "BackgroundRed"
    }

    bboxDraw(X1, Y1, X2, Y2, color)

    if (doPause && vret) {
        Pause
    }

    if GetKeyState("F4", "P") {
        Pause
    }
    Gui, BoundingBox%winTitle%:Destroy
}

Gdip_ImageSearch_wbb(pBitmapHaystack,pNeedle,ByRef OutputList=""
    ,OuterX1=0,OuterY1=0,OuterX2=0,OuterY2=0,Variation=0,Trans=""
    ,SearchDirection=1,Instances=1,LineDelim="`n",CoordDelim=",") {
    yBias := titleHeight - 45
    vret := Gdip_ImageSearch(pBitmapHaystack,pNeedle.needle,OutputList,OuterX1,OuterY1+yBias,OuterX2,OuterY2+yBias,Variation,Trans,SearchDirection,Instances,LineDelim,CoordDelim)
    if(dbg_bbox)
        bboxAndPause_immage(OuterX1, OuterY1+yBias, OuterX2, OuterY2+yBias, pNeedle, vret, dbg_bboxNpause)
    return vret
}

GetNeedle(Path) {
    static NeedleBitmaps := Object()
    if (NeedleBitmaps.HasKey(Path)) {
        return NeedleBitmaps[Path]
    } else {
        pNeedle := Gdip_CreateBitmapFromFile(Path)
        NeedleBitmaps[Path] := pNeedle
        return pNeedle
    }
}

Screenshot_dev(fileType := "Dev",subDir := "") {
    global adbShell, scriptName, ocrLanguage, loadDir

    SetWorkingDir %A_ScriptDir%  ; Ensures the working directory is the script's directory

    ; Define folder and file paths
    fileDir := A_ScriptDir "\..\Screenshots"
    if !FileExist(fileDir)
        FileCreateDir, %fileDir%
    if (subDir) {
        fileDir .= "\" . subDir
    }
    if !FileExist(fileDir)
        FileCreateDir, %fileDir%

    ; File path for saving the screenshot locally
    fileName := A_Now . "_" . winTitle . "_" . fileType . ".png"
    filePath := fileDir "\" . fileName

    pBitmapW := from_window(WinExist(winTitle))
    Gdip_SaveBitmapToFile(pBitmapW, filePath)

    sleep 100

    try {
        OwnerWND := WinExist(winTitle)
        buttonWidth := 40
        yBias := titleHeight - 45

        Gui, DevMode_ss%winTitle%:New, +LastFound -DPIScale
        Gui, DevMode_ss%winTitle%:Add, Picture, x0 y0 w275 h534, %filePath%
        Gui, DevMode_ss%winTitle%:Show, w275 h534, Screensho %winTitle%

        sleep 100
        msgbox click on top-left corner and bottom-right corners

        KeyWait, LButton, D
        MouseGetPos , X1, Y1, OutputVarWin, OutputVarControl
        KeyWait, LButton, U
        Y1 -= 31 + yBias
        ;MsgBox, The cursor is at X%X1% Y%Y1%.

        KeyWait, LButton, D
        MouseGetPos , X2, Y2, OutputVarWin, OutputVarControl
        KeyWait, LButton, U
        Y2 -= 31 + yBias
        ;MsgBox, The cursor is at X%X2% Y%Y2%.

        W:=X2-X1
        H:=Y2-Y1

        pBitmap := Gdip_CloneBitmapArea(pBitmapW, X1, Y1, W, H)

        InputBox, fileName, ,"Enter the name of the needle to save"

        fileDir := A_ScriptDir . "\Scale125"
        filePath := fileDir "\" . fileName . ".png"
        Gdip_SaveBitmapToFile(pBitmap, filePath)

        msgbox click on coordinate for adbClick

        KeyWait, LButton, D
        MouseGetPos , X3, Y3, OutputVarWin, OutputVarControl
        KeyWait, LButton, U
        Y3 -= 31 + yBias

        MsgBox,
        (LTrim
            ctrl+C to copy:
            FindOrLoseImage(%X1%, %Y1%, %X2%, %Y2%, , "%fileName%", 0, failSafeTime)
            FindImageAndClick(%X1%, %Y1%, %X2%, %Y2%, , "%fileName%", %X3%, %Y3%, sleepTime)
            adbClick_wbb(%X3%, %Y3%)
        )
    }
    catch {
        msgbox Failed to create screenshot GUI
    }
    return filePath
}


DevMode:
    ToggleDevMode()
return