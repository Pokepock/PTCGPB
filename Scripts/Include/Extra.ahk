#Include %A_ScriptDir%\Dictionary.ahk
#SingleInstance Force

; GUI dimensions
global GUI_WIDTH := 510
global GUI_HEIGHT := 445

if not A_IsAdmin
{
    ; Relaunch script with admin rights
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

isNumeric(var) {
  if var is number
    return true
  return false
}

LoadSettingsFromIni() {
  global
  IniPath := A_ScriptDir . "\..\..\Settings.ini"
  ; Check if Settings.ini exists
  if (FileExist(IniPath)) {
    IniRead, discordUserId, %A_ScriptDir%\..\..\Settings.ini, UserSettings, discordUserId, ""
    IniRead, heartBeatName, %A_ScriptDir%\..\..\Settings.ini, UserSettings, heartBeatName, ""
    IniRead, altWebhookSettings, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altWebhookSettings, 0
    ;discord settings
    IniRead, altDiscordWebhookURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altDiscordWebhookURL, ""
    IniRead, altDiscordUserId, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altDiscordUserId, %discordUserId%
    IniRead, altheartBeat, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altheartBeat, 0
    IniRead, altheartBeatName, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altheartBeatName, %heartBeatName%
    IniRead, altheartBeatWebhookURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altheartBeatWebhookURL, ""
    if(altDiscordUserID = "")
      altDiscordUserID := discordUserId
    if(altheartBeatName = "")
      altheartBeatName := heartBeatName
    ;download settings
    IniRead, altmainIdsURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altmainIdsURL, ""
    IniRead, altvipIdsURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altvipIdsURL, ""

    IniRead, offlineReminder, %A_ScriptDir%\..\..\Settings.ini, UserSettings, offlineReminder, 1
    IniRead, folderPosX, %A_ScriptDir%\..\..\Settings.ini, UserSettings, folderPosX, 2
    IniRead, DashBoard, %A_ScriptDir%\..\..\Settings.ini, UserSettings, DashBoard, 0

    IniRead, CheckFolder, %A_ScriptDir%\..\..\Settings.ini, UserSettings, CheckFolder, 0
    IniRead, folderWebhookURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, folderWebhookURL, ""
    IniRead, folderNO, %A_ScriptDir%\..\..\Settings.ini, UserSettings, folderNO, 10000
    IniRead, mainMonitor, %A_ScriptDir%\..\..\Settings.ini, UserSettings, mainMonitor, 0
    IniRead, mainsMonitorCD, %A_ScriptDir%\..\..\Settings.ini, UserSettings, mainsMonitorCD, 20
    IniRead, autoRestartTimes, %A_ScriptDir%\..\..\Settings.ini, UserSettings, autoRestartTimes, 30
    IniRead, autoRestartMode, %A_ScriptDir%\..\..\Settings.ini, UserSettings, autoRestartMode, 0
    
    ; Return success
    return true
  } else {
    ; Settings file doesn't exist, will use defaults
    return false
  }
}

; Unified function to save all settings to INI file - FIXED VERSION
SaveAllSettings() {
  global altWebhookSettings, altDiscordWebhookURL, altDiscordUserId, altheartBeat, altheartBeatWebhookURL, altheartBeatName, altheartBeatDelay
  global altmainIdsURL, altvipIdsURL
  global offlineReminder, DashBoard, folderPosX, CheckFolder, folderWebhookURL, folderNO , mainMonitor, mainsMonitorCD, autoRestartMode, autoRestartTimes
  
  ; FIXED: Make sure all values are properly synced from GUI before saving
  Gui, Submit, NoHide
  IniWrite, %altWebhookSettings%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altWebhookSettings
  IniWrite, %altDiscordWebhookURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altDiscordWebhookURL
  IniWrite, %altDiscordUserId%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altDiscordUserId
  ; HeartBeat Settings
  IniWrite, %altheartBeat%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altheartBeat
  IniWrite, %altheartBeatWebhookURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altheartBeatWebhookURL
  IniWrite, %altheartBeatName%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altheartBeatName
  ; Save Download Settings
  IniWrite, %altmainIdsURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altmainIdsURL
  IniWrite, %altvipIdsURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altvipIdsURL
  ; Save showcase settings
  IniWrite, %offlineReminder%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, offlineReminder
  IniWrite, %DashBoard%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, DashBoard
  IniWrite, %folderPosX%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, folderPosX
  IniWrite, %CheckFolder%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, CheckFolder 
  IniWrite, %folderWebhookURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, folderWebhookURL
  IniWrite, %folderNO%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, folderNO
  IniWrite, %mainMonitor%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, mainMonitor
  IniWrite, %mainsMonitorCD%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, mainsMonitorCD
  IniWrite, %autoRestartMode%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, autoRestartMode
  IniWrite, %autoRestartTimes%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, autoRestartTimes
  

  ; FIXED: Debug logging if enabled
  if (debugMode) {
    FileAppend, % A_Now . " - Settings saved. DeleteMethod: " . deleteMethod . "`n", %A_ScriptDir%\..\..\debug_settings.log
  }
}
global saveSignalFile
saveSignalFile := A_ScriptDir "\save.signal"
global currentDictionary
LoadSettingsFromIni()
IniRead, IsLanguageSet, %A_ScriptDir%\..\..\Settings.ini, UserSettings, IsLanguageSet, 0
IniRead, defaultBotLanguage, %A_ScriptDir%\..\..\Settings.ini, UserSettings, defaultBotLanguage, 0
IniRead, BotLanguage, %A_ScriptDir%\..\..\Settings.ini, UserSettings, BotLanguage, English
currentDictionary := CreateGUITextByLanguage(defaultBotLanguage, "")
; Create a stylish GUI with custom colors and modern look
Gui, Color, 1E1E1E, 333333 ; Dark theme background
Gui, Font, s10 cWhite, Segoe UI ; Modern font


; ========== Column 1 ==========
; ==============================
sectionColor := "cRed" ; Hot pink
Gui, Add, GroupBox, xp+0 y0 w240 h55 %sectionColor%, Enable Alt Webhook Settings
Gui, Add, Checkbox, % (altWebhookSettings ? "Checked" : "") " valtWebhookSettings xp+15 yp+25 " . sectionColor, Alt Webhook Settings

; ========== Discord Settings Section ==========
sectionColor := "cFF69B4" ; Hot pink
Gui, Add, GroupBox, xp-15 yp+35 w240 h120 %sectionColor%, Alt Discord Settings
if(StrLen(altDiscordUserID) < 3)
  altDiscordUserID =
if(StrLen(altDiscordWebhookURL) < 3)
  altDiscordWebhookURL =
Gui, Add, Text, xp+15 yp+20 %sectionColor%, Alt Discord ID:
Gui, Add, Edit, valtDiscordUserId w210 xp+0 yp+20 h20 -E0x200 Background2A2A2A cWhite, %altDiscordUserId%
Gui, Add, Text, xp+0 yp+20 %sectionColor%, Alt Webhook URL:
Gui, Add, Edit, valtDiscordWebhookURL w210 xp+0 yp+20 h20 -E0x200 Background2A2A2A cWhite, %altDiscordWebhookURL%

; ========== Heartbeat Settings Section ==========
sectionColor := "c00FFFF" ; Cyan
Gui, Add, GroupBox, xp-15 yp+40 w240 h140 %sectionColor%, Alt Heartbeat Settings
Gui, Add, Checkbox, % (altheartBeat ? "Checked" : "") " valtheartBeat xp+15 yp+25 galtdiscordSettings " . sectionColor, % currentDictionary.Txt_heartBeat

if(StrLen(altheartBeatName) < 3)
  altheartBeatName =
if(StrLen(altheartBeatWebhookURL) < 3)
  altheartBeatWebhookURL =

if (altheartBeat) {
  Gui, Add, Text, vhbName xp+0 yp+20 %sectionColor%, % currentDictionary.hbName
  Gui, Add, Edit, valtheartBeatName w210 xp+0 yp+20 h20 -E0x200 Background2A2A2A cWhite, %altheartBeatName%
  Gui, Add, Text, vhbURL xp+0 yp+20 %sectionColor%, Webhook URL:
  Gui, Add, Edit, valtheartBeatWebhookURL w210 xp+0 yp+20 h20 -E0x200 Background2A2A2A cWhite, %altheartBeatWebhookURL%
} else {
  Gui, Add, Text, vhbName xp+0 yp+20 Hidden %sectionColor%, % currentDictionary.hbName
  Gui, Add, Edit, valtheartBeatName w210 xp+0 yp+20 h20 Hidden -E0x200 Background2A2A2A cWhite, %altheartBeatName%
  Gui, Add, Text, vhbURL xp+0 yp+20 Hidden %sectionColor%, Webhook URL:
  Gui, Add, Edit, valtheartBeatWebhookURL w210 xp+0 yp+20 h20 Hidden -E0x200 Background2A2A2A cWhite, %altheartBeatWebhookURL%
}

; ========== Download Settings Section (Bottom right) ==========
sectionColor := "cWhite"
Gui, Add, GroupBox, xp-15 yp+35 w240 h120 %sectionColor%, Alt Download Settings ;


if(StrLen(altmainIdsURL) < 3)
  altmainIdsURL =
if(StrLen(altvipIdsURL) < 3)
  altvipIdsURL =

Gui, Add, Text, xp+15 yp+25 %sectionColor%, Alt ids.txt API:
Gui, Add, Edit, valtmainIdsURL w210 xp+0 yp+20 h20 -E0x200 Background2A2A2A cWhite, %altmainIdsURL%
Gui, Add, Text, xp+0 yp+20 %sectionColor%, Alt vip_ids.txt (GP Test Mode) API:
Gui, Add, Edit, valtvipIdsURL w210 xp+0 yp+20 h20 -E0x200 Background2A2A2A cWhite, %AltvipIdsURL%

; ========== Column 2 ==========
; ==============================
sectionColor := "cFFDDAA"
; ========== Folder Settings Section ==========
Gui, Add, GroupBox, x260 y0 w240 h120 %sectionColor%, Check Folder Settings
Gui, Add, Checkbox, % (CheckFolder ? "Checked" : "") " vCheckFolder xp+15 yp+25 gcheckfoldersettings " . sectionColor, Check Folder Mode
if (CheckFolder) {
  Gui, Add, Text, vtxt_folderURL xp+0 yp+20 %sectionColor%, Folder Webhook URL
  Gui, Add, Edit, vfolderWebhookURL w210 xp+0 yp+20 h20 -E0x200 Background2A2A2A cWhite, %folderWebhookURL%
  Gui, Add, Text, vtxt_folderNo xp+0 yp+25 %sectionColor%, Folder No.:
  Gui, Add, Edit, vfolderNo w100 xp+80 yp+0 h20 -E0x200 Background2A2A2A cWhite, %folderNo%
} else {
  Gui, Add, Text, vtxt_folderURL xp+0 yp+20 hidden %sectionColor%, Folder Webhook URL
  Gui, Add, Edit, vfolderWebhookURL w210 xp+0 yp+20 h20 hidden -E0x200 Background2A2A2A cWhite, %folderWebhookURL%
  Gui, Add, Text, vtxt_folderNo xp+0 yp+25 hidden %sectionColor%, Folder No.:
  Gui, Add, Edit, vfolderNo w80 xp+80 yp+0 h20 hidden -E0x200 Background2A2A2A cWhite, %folderNo%
}

; ========== Other Settings Section ==========
sectionColor := "cE5CAFF"
Gui, Add, GroupBox, xp-95 yp+35 w240 h160 %sectionColor%, Other Settings
Gui, Add, Text, vtxt_folderPosX xp+15 yp+25 %sectionColor%, Folder.ahk Pos (Main0 = 1)
Gui, Add, Edit, vfolderPosX w35 xp+170 yp+0 h20 -E0x200 Background2A2A2A cWhite, %folderPosX%
Gui, Add, Checkbox, % (offlineReminder ? "Checked" : "") " vofflineReminde xp-170 yp+25 " . sectionColor, Offline Reminder
Gui, Add, Checkbox, % (DashBoard ? "Checked" : "") " vDashBoard xp+0 yp+25 " . sectionColor, DashBoard (python needed)
Gui, Add, Checkbox, % (mainMonitor ? "Checked" : "") " vmainMonitor xp+0 yp+25 " . sectionColor, Mains Monitor
Gui, Add, Edit, vmainsMonitorCD w30 xp+150 yp+0 h20 -E0x200 Background2A2A2A cWhite, %mainsMonitorCD%
Gui, Add, Text, vtxt_MonitorCD xp+30 yp+0 %sectionColor%, Mins
Gui, Add, Checkbox, % (autoRestartMode ? "Checked" : "") " vautoRestartMode xp-180 yp+25 " . sectionColor, Auto Restart after
Gui, Add, Edit, vautoRestartTimes w30 xp+150 yp+0 h20 -E0x200 Background2A2A2A cWhite, %autoRestartTimes%
Gui, Add, Text, vtxt_autoRestartTimesCD xp+30 yp+0 %sectionColor%, Runs

; ========== Action Buttons ==========
Gui, Add, Button, gPackSelector xp-195 yp+40 w240 h35, Detailed Pack Selects
Gui, Add, Button, gRemoveMetadata xp+0 yp+45 w240 h35, Metadata Renamer
Gui, Add, Button, gSave xp+0 yp+45 w240 h60, Save Settings



Gui, Show, w%GUI_WIDTH% h%GUI_HEIGHT%, Extra Settings
Return

mainSettings:
  Gui, Submit, NoHide
  
  if (runMain) {
    GuiControl, Show, Mains
  }
  else {
    GuiControl, Hide, Mains
  }
return

autoUseGPTestSettings:
  Gui, Submit, NoHide
  
  if (autoUseGPTest) {
    GuiControl, Show, TestTime
  }
  else {
    GuiControl, Hide, TestTime
  }
return

; NEW: Handle drop-down changes for sort method
SortByDropdownHandler:
  Gui, Submit, NoHide
  GuiControlGet, selectedOption,, SortByDropdown
  
  ; Update injectSortMethod based on selected option
  if (selectedOption = "Oldest First")
    injectSortMethod := "ModifiedAsc"
  else if (selectedOption = "Newest First")
    injectSortMethod := "ModifiedDesc"
  else if (selectedOption = "Fewest Packs First")
    injectSortMethod := "PacksAsc"
  else if (selectedOption = "Most Packs First")
    injectSortMethod := "PacksDesc"
  
  ; Save the updated setting
  IniWrite, %injectSortMethod%, Settings.ini, UserSettings, injectSortMethod
  
  ; Save all settings to ensure consistency
  SaveAllSettings()
return

altdiscordSettings:
  Gui, Submit, NoHide
  
  if (altheartBeat) {
    GuiControl, Show, altheartBeatName
    GuiControl, Show, altheartBeatWebhookURL
    GuiControl, Show, altheartBeatDelay
    GuiControl, Show, hbName
    GuiControl, Show, hbURL
    GuiControl, Show, hbDelay
  }
  else {
    GuiControl, Hide, altheartBeatName
    GuiControl, Hide, altheartBeatWebhookURL
    GuiControl, Hide, altheartBeatDelay
    GuiControl, Hide, hbName
    GuiControl, Hide, hbURL
    GuiControl, Hide, hbDelay
  }
return

checkfoldersettings:
  Gui, Submit, NoHide
  
  if (CheckFolder) {
    GuiControl, Show, txt_folderURL
    GuiControl, Show, folderWebhookURL
    GuiControl, Show, txt_folderNo
    GuiControl, Show, folderNo
  }
  else {
    GuiControl, Hide, txt_folderURL
    GuiControl, Hide, folderWebhookURL
    GuiControl, Hide, txt_folderNo
    GuiControl, Hide, folderNo
  }
return


defaultLangSetting:
  global scaleParam
  GuiControlGet, defaultLanguage,, defaultLanguage
  if (defaultLanguage = "Scale125")
    scaleParam := 277
  else if (defaultLanguage = "Scale100")
    scaleParam := 287
return

Save:
  Gui, Submit
  SaveAllSettings()
  Gui, Destroy
  FileAppend,, %saveSignalFile%
  Run, %A_ScriptDir%\..\..\PTCGPB.ahk
ExitApp
Return

GuiClose:
    ; Save all settings before exiting
    SaveAllSettings()
    
    ; Kill all related scripts
    KillAllScripts()
    FileAppend,, %saveSignalFile%
    Run, %A_ScriptDir%\..\..\PTCGPB.ahk
ExitApp
Return

PackSelector:
  Run, %A_ScriptDir%\..\..\Scripts\PackSelections.ahk
Return

RemoveMetadata:
  Run, %A_ScriptDir%\RemoveMetadata.ahk
Return

; Add this function to kill all related scripts
KillAllScripts() {
    ; Kill Monitor.ahk if running
    Process, Exist, Monitor.ahk
    if (ErrorLevel) {
        Process, Close, %ErrorLevel%
    }
    
    ; Kill all instance scripts
    Loop, 50 { ; Assuming you won't have more than 50 instances
        scriptName := A_Index . ".ahk"
        Process, Exist, %scriptName%
        if (ErrorLevel) {
            Process, Close, %ErrorLevel%
        }
        
        ; Also check for Main scripts
        if (A_Index = 1) {
            Process, Exist, Main.ahk
            if (ErrorLevel) {
                Process, Close, %ErrorLevel%
            }
        } else {
            mainScript := "Main" . A_Index . ".ahk"
            Process, Exist, %mainScript%
            if (ErrorLevel) {
                Process, Close, %ErrorLevel%
            }
        }
    }
    
    ; Close any status GUIs that might be open
    Gui, PackStatusGUI:Destroy
}