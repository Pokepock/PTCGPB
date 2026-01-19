#Include %A_ScriptDir%\Dictionary.ahk
#Include %A_ScriptDir%\ADB.ahk
#Include %A_ScriptDir%\Logging.ahk 
#SingleInstance Force

global githubUser := "Pokepock"
global repoName := "PTCGPB"
global localVersion := "7.0.9.4(C)" 
global jsonFileName := ""
global scaleParam

global GUI_WIDTH := 1250
global GUI_HEIGHT := 600
global IsLanguageSet, defaultBotLanguage

IniRead, IsLanguageSet, %A_ScriptDir%\..\..\Settings.ini, UserSettings, IsLanguageSet, 0
IniRead, defaultBotLanguage, %A_ScriptDir%\..\..\Settings.ini, UserSettings, defaultBotLanguage, 1
IniRead, BotLanguage, %A_ScriptDir%\..\..\Settings.ini, UserSettings, BotLanguage, English

global LicenseDictionary, ProxyDictionary, currentDictionary, SetUpDictionary, HelpDictionary
    LicenseDictionary := CreateLicenseNoteLanguage(defaultBotLanguage)
    ProxyDictionary := CreateProxyLanguage(defaultBotLanguage)
    currentDictionary := CreateGUITextByLanguage(defaultBotLanguage, localVersion)
    SetUpDictionary := CreateSetUpByLanguage(defaultBotLanguage)
    HelpDictionary := CreateHelpByLanguage(defaultBotLanguage)

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
    ; Read basic settings with default values if they don't exist in the file
    ;friend id
    IniRead, FriendID, %A_ScriptDir%\..\..\Settings.ini, UserSettings, FriendID, ""
    ;instance settings
    IniRead, Instances, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Instances, 1
    IniRead, instanceStartDelay, %A_ScriptDir%\..\..\Settings.ini, UserSettings, instanceStartDelay, 0
    IniRead, Columns, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Columns, 5
    IniRead, runMain, %A_ScriptDir%\..\..\Settings.ini, UserSettings, runMain, 1
    IniRead, Mains, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Mains, 1
    IniRead, AccountName, %A_ScriptDir%\..\..\Settings.ini, UserSettings, AccountName, ""
    IniRead, autoLaunchMonitor, %A_ScriptDir%\..\..\Settings.ini, UserSettings, autoLaunchMonitor, 1
    IniRead, autoUseGPTest, %A_ScriptDir%\..\..\Settings.ini, UserSettings, autoUseGPTest, 0
    IniRead, TestTime, %A_ScriptDir%\..\..\Settings.ini, UserSettings, TestTime, 3600
    ;Time settings
    IniRead, Delay, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Delay, 250
    IniRead, waitTime, %A_ScriptDir%\..\..\Settings.ini, UserSettings, waitTime, 5
    IniRead, swipeSpeed, %A_ScriptDir%\..\..\Settings.ini, UserSettings, swipeSpeed, 300
    IniRead, slowMotion, %A_ScriptDir%\..\..\Settings.ini, UserSettings, slowMotion, 0
    IniRead, NineMod, %A_ScriptDir%\..\..\Settings.ini, UserSettings, NineMod, 0
    
    
    ;system settings
    IniRead, SelectedMonitorIndex, %A_ScriptDir%\..\..\Settings.ini, UserSettings, SelectedMonitorIndex, 1
    IniRead, defaultLanguage, %A_ScriptDir%\..\..\Settings.ini, UserSettings, defaultLanguage, Scale125
    IniRead, rowGap, %A_ScriptDir%\..\..\Settings.ini, UserSettings, rowGap, 100
    IniRead, folderPath, %A_ScriptDir%\..\..\Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
    IniRead, ocrLanguage, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ocrLanguage, en
    IniRead, clientLanguage, %A_ScriptDir%\..\..\Settings.ini, UserSettings, clientLanguage, en
    IniRead, instanceLaunchDelay, %A_ScriptDir%\..\..\Settings.ini, UserSettings, instanceLaunchDelay, 5
    
    ; Extra Settings
    IniRead, tesseractPath, %A_ScriptDir%\..\..\Settings.ini, UserSettings, tesseractPath, C:\Program Files\Tesseract-OCR\tesseract.exe
    IniRead, applyRoleFilters, %A_ScriptDir%\..\..\Settings.ini, UserSettings, applyRoleFilters, 0
    IniRead, debugMode, %A_ScriptDir%\..\..\Settings.ini, UserSettings, debugMode, 0
    IniRead, tesseractOption, %A_ScriptDir%\..\..\Settings.ini, UserSettings, tesseractOption, 0
    IniRead, statusMessage, %A_ScriptDir%\..\..\Settings.ini, UserSettings, statusMessage, 1
    
    ;pack settings
    IniRead, minStars, %A_ScriptDir%\..\..\Settings.ini, UserSettings, minStars, 0
    IniRead, minStarsShiny, %A_ScriptDir%\..\..\Settings.ini, UserSettings, minStarsShiny, 0
    IniRead, deleteMethod, %A_ScriptDir%\..\..\Settings.ini, UserSettings, deleteMethod, 13 Pack
    IniRead, packMethod, %A_ScriptDir%\..\..\Settings.ini, UserSettings, packMethod, 0
    IniRead, nukeAccount, %A_ScriptDir%\..\..\Settings.ini, UserSettings, nukeAccount, 0
    IniRead, spendHourGlass, %A_ScriptDir%\..\..\Settings.ini, UserSettings, spendHourGlass, 0
    IniRead, openExtraPack, %A_ScriptDir%\..\..\Settings.ini, UserSettings, openExtraPack, 0
    IniRead, injectSortMethod, %A_ScriptDir%\..\..\Settings.ini, UserSettings, injectSortMethod, ModifiedAsc
    
    IniRead, Palkia, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Palkia, 0
    IniRead, Dialga, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Dialga, 0
    IniRead, Arceus, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Arceus, 0
    IniRead, Shining, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Shining, 0
    IniRead, Mew, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Mew, 0
    IniRead, Pikachu, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Pikachu, 0
    IniRead, Charizard, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Charizard, 0
    IniRead, Mewtwo, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Mewtwo, 0
    IniRead, Solgaleo, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Solgaleo, 0
    IniRead, Lunala, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Lunala, 0
    IniRead, Buzzwole, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Buzzwole, 0
    IniRead, Eevee, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Eevee, 0
    IniRead, HoOh, %A_ScriptDir%\..\..\Settings.ini, UserSettings, HoOh, 0
    IniRead, Lugia, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Lugia, 0
    IniRead, Suicune, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Suicune, 0
    IniRead, Deluxe, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Deluxe, 0
    IniRead, MegaBlaziken, %A_ScriptDir%\..\..\Settings.ini, UserSettings, MegaBlaziken, 0
    IniRead, MegaGyarados, %A_ScriptDir%\..\..\Settings.ini, UserSettings, MegaGyarados, 0
    IniRead, MegaAltaria, %A_ScriptDir%\..\..\Settings.ini, UserSettings, MegaAltaria, 0
    IniRead, MegaCharizardY, %A_ScriptDir%\..\..\Settings.ini, UserSettings, MegaCharizardY, 1
    
    IniRead, CheckShinyPackOnly, %A_ScriptDir%\..\..\Settings.ini, UserSettings, CheckShinyPackOnly, 0
    IniRead, TrainerCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, TrainerCheck, 0
    IniRead, FullArtCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, FullArtCheck, 0
    IniRead, RainbowCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, RainbowCheck, 0
    IniRead, ShinyCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ShinyCheck, 0
    IniRead, CrownCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, CrownCheck, 0
    IniRead, ImmersiveCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ImmersiveCheck, 0
    IniRead, InvalidCheck, %A_ScriptDir%\..\..\Settings.ini, UserSettings, InvalidCheck, 0
    IniRead, PseudoGodPack, %A_ScriptDir%\..\..\Settings.ini, UserSettings, PseudoGodPack, 0
    
    ; Read S4T settings
    IniRead, s4tEnabled, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tEnabled, 0
    IniRead, s4tSilent, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tSilent, 1
    IniRead, s4t3Dmnd, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4t3Dmnd, 0
    IniRead, s4t4Dmnd, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4t4Dmnd, 0
    IniRead, s4t1Star, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4t1Star, 0
    IniRead, s4tFoil, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tFoil, 0
    IniRead, s4tTrainer, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tTrainer, 0
    IniRead, s4tRainbow, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tRainbow, 0
    IniRead, s4tFullart, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tFullart, 0
    IniRead, s4tShiny, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tShiny, 0
    IniRead, s4tGholdengo, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tGholdengo, 0
    IniRead, s4tWP, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tWP, 0
    IniRead, s4tWPMinCards, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tWPMinCards, 1
    IniRead, s4tDiscordWebhookURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tDiscordWebhookURL, ""
    IniRead, s4tDiscordUserId, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tDiscordUserId, ""
    IniRead, s4tSendAccountXml, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tSendAccountXml, 0

    
    ;discord settings
    IniRead, DiscordWebhookURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, DiscordWebhookURL, ""
    IniRead, DiscordUserId, %A_ScriptDir%\..\..\Settings.ini, UserSettings, DiscordUserId, ""
    IniRead, heartBeat, %A_ScriptDir%\..\..\Settings.ini, UserSettings, heartBeat, 0
    IniRead, heartBeatWebhookURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, heartBeatWebhookURL, ""
    IniRead, heartBeatName, %A_ScriptDir%\..\..\Settings.ini, UserSettings, heartBeatName, ""
    IniRead, heartBeatDelay, %A_ScriptDir%\..\..\Settings.ini, UserSettings, heartBeatDelay, 30
    IniRead, sendAccountXml, %A_ScriptDir%\..\..\Settings.ini, UserSettings, sendAccountXml, 0

    ;download settings
    IniRead, mainIdsURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, mainIdsURL, ""
    IniRead, vipIdsURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, vipIdsURL, ""
    IniRead, showcaseEnabled, %A_ScriptDir%\..\..\Settings.ini, UserSettings, showcaseEnabled, 0

    IniRead, classicModeOnly, %A_ScriptDir%\..\..\Settings.ini, UserSettings, classicModeOnly, 0
    
    
    ;rename settings
    IniRead, renameMode, %A_ScriptDir%\..\..\Settings.ini, UserSettings, renameMode, 0
    IniRead, renameAndSaveAndReload, %A_ScriptDir%\..\..\Settings.ini, UserSettings, renameAndSaveAndReload, 0
    IniRead, targetUsername, %A_ScriptDir%\..\..\Settings.ini, UserSettings, TargetUsername, ""
    IniRead, renameXML, %A_ScriptDir%\..\..\Settings.ini, UserSettings, renameXML, 0
    IniRead, renameXMLwithFC, %A_ScriptDir%\..\..\Settings.ini, UserSettings, renameXMLwithFC, 0

    IniRead, ChangeLNMode, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ChangeLNMode, 0
    IniRead, targetLN, %A_ScriptDir%\..\..\Settings.ini, UserSettings, targetLN, 0


    ;claim bonus settings
    IniRead, redeemTokens, %A_ScriptDir%\..\..\Settings.ini, UserSettings, redeemTokens, 0
    IniRead, ClaimBonusWeek, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ClaimBonusWeek, 0
    IniRead, BonusWeekPos, %A_ScriptDir%\..\..\Settings.ini, UserSettings, BonusWeekPos, -1
    IniRead, claimAnnivCountdown, %A_ScriptDir%\..\..\Settings.ini, UserSettings, claimAnnivCountdown, 0
    IniRead, AnnivPos, %A_ScriptDir%\..\..\Settings.ini, UserSettings, AnnivPos, -1
    IniRead, claimFutureBonusPrep, %A_ScriptDir%\..\..\Settings.ini, UserSettings, claimFutureBonusPrep, 0
    IniRead, FutureBonusPos, %A_ScriptDir%\..\..\Settings.ini, UserSettings, FutureBonusPos, -1
    IniRead, ClaimMail, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ClaimMail, 0

    


    IniRead, captureWebhookURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, captureWebhookURL, ""
    IniRead, insMonitorCD , %A_ScriptDir%\..\..\Settings.ini, UserSettings, insMonitorCD , 10
    
    
    
    ; Validate numeric values
    if (!IsNumeric(Instances))
      Instances := 1
    if (!IsNumeric(Columns) || Columns < 1)
      Columns := 5
    if (!IsNumeric(waitTime))
      waitTime := 5
    if (!IsNumeric(Delay) || Delay < 10)
      Delay := 250
    
    ; Return success
    return true
  } else {
    ; Settings file doesn't exist, will use defaults
    return false
  }
}

; Unified function to save all settings to INI file - FIXED VERSION
SaveAllSettings() {
  global FriendID, AccountName, waitTime, Delay, folderPath, discordWebhookURL, discordUserId, Columns, godPack
  global Instances, instanceStartDelay, defaultLanguage, SelectedMonitorIndex, swipeSpeed, deleteMethod
  global runMain, Mains, heartBeat, heartBeatWebhookURL, heartBeatName, nukeAccount, packMethod
  global autoLaunchMonitor, autoUseGPTest, TestTime
  global CheckShinyPackOnly, TrainerCheck, FullArtCheck, RainbowCheck, ShinyCheck, CrownCheck
  global InvalidCheck, ImmersiveCheck, PseudoGodPack, minStars, Palkia, Dialga, Arceus, Shining
  global Mew, Pikachu, Charizard, Mewtwo, Solgaleo, Lunala, Buzzwole, Eevee, HoOh, Lugia, Suicune, Deluxe, MegaBlaziken, MegaGyarados, MegaAltaria, MegaCharizardY, slowMotion, ocrLanguage, clientLanguage
  global CurrentVisibleSection, heartBeatDelay, sendAccountXml, showcaseEnabled, showcaseURL, isDarkTheme
  global useBackgroundImage, tesseractPath, applyRoleFilters, debugMode, tesseractOption, statusMessage
  global s4tEnabled, s4tSilent, s4t3Dmnd, s4t4Dmnd, s4t1Star, s4tGholdengo, s4tWP, s4tWPMinCards, s4tFoil, s4tTrainer, s4tRainbow, s4tFullart, s4tShiny
  global s4tDiscordUserId, s4tDiscordWebhookURL, s4tSendAccountXml, minStarsShiny, instanceLaunchDelay, mainIdsURL, vipIdsURL
  global spendHourGlass, openExtraPack, injectSortMethod, rowGap, SortByDropdown
  global waitForEligibleAccounts, maxWaitHours, skipMissionsInjectMissions, NineMod, Bankai, classicModeOnly
  global renameMode, renameAndSaveAndReload, targetUsername, renameXML, renameXMLwithFC, ChangeLNMode, targetLN
  global redeemTokens, ClaimBonusWeek, claimAnnivCountdown, ClaimMail, AnnivPos, BonusWeekPos, FutureBonusPos, claimFutureBonusPrep, captureWebhookURL, insMonitorCD 

  
  ; === MISSING ADVANCED SETTINGS VARIABLES ===
  global minStarsA1Mewtwo, minStarsA1Charizard, minStarsA1Pikachu, minStarsA1a
  global minStarsA2Dialga, minStarsA2Palkia, minStarsA2a, minStarsA2b
  global minStarsA3Solgaleo, minStarsA3Lunala, minStarsA3a
  
  ; FIXED: Make sure all values are properly synced from GUI before saving
  Gui, Submit, NoHide
  
  ; FIXED: Explicitly get the deleteMethod from the dropdown control with validation
  GuiControlGet, currentDeleteMethod,, deleteMethod
  if (currentDeleteMethod != "" && currentDeleteMethod != "ERROR") {
    deleteMethod := currentDeleteMethod
  } else if (deleteMethod = "" || deleteMethod = "ERROR") {
    ; Set default if empty or invalid
    deleteMethod := "13 Pack"
  }
  
  ; FIXED: Validate deleteMethod against known valid options
  validMethods := "13 Pack|Inject|Inject Missions|Inject for Reroll"
  if (!InStr(validMethods, deleteMethod)) {
    deleteMethod := "13 Pack" ; Reset to default if invalid
  }
  
  ; Update injectSortMethod based on dropdown if available
  if (sortByCreated) {
    GuiControlGet, selectedOption,, SortByDropdown
    if (selectedOption = "Oldest First")
      injectSortMethod := "ModifiedAsc"
    else if (selectedOption = "Newest First")
      injectSortMethod := "ModifiedDesc"
    else if (selectedOption = "Fewest Packs First")
      injectSortMethod := "PacksAsc"
    else if (selectedOption = "Most Packs First")
      injectSortMethod := "PacksDesc"
  }
  
  ; Do not initalize friend IDs or id.txt if Inject or Inject Missions
  IniWrite, %deleteMethod%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, deleteMethod
  if (deleteMethod = "Inject for Reroll" || deleteMethod = "13 Pack") {
    IniWrite, %FriendID%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, FriendID
    IniWrite, %mainIdsURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, mainIdsURL
  } else {
    idsPath := A_ScriptDir . "\..\..\ids.txt"
    if(FileExist(idsPath))
      FileDelete, %idsPath%
    IniWrite, "", %A_ScriptDir%\..\..\Settings.ini, UserSettings, FriendID
    IniWrite, "", %A_ScriptDir%\..\..\Settings.ini, UserSettings, mainIdsURL
    mainIdsURL := ""
    FriendID := ""
  }
  ; Save Reroll settings
  IniWrite, %Instances%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Instances
  IniWrite, %instanceStartDelay%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, instanceStartDelay
  IniWrite, %Columns%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Columns
  IniWrite, %runMain%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, runMain
  IniWrite, %Mains%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Mains
  IniWrite, %autoUseGPTest%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, autoUseGPTest
  IniWrite, %TestTime%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, TestTime
  IniWrite, %AccountName%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, AccountName  
  IniWrite, %Delay%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Delay
  IniWrite, %waitTime%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, waitTime
  IniWrite, %swipeSpeed%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, swipeSpeed
  IniWrite, %slowMotion%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, slowMotion
  IniWrite, %NineMod%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, NineMod
  
  ; System Settings
  IniWrite, %SelectedMonitorIndex%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, SelectedMonitorIndex
  IniWrite, %defaultLanguage%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, defaultLanguage
  IniWrite, %rowGap%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, rowGap
  IniWrite, %folderPath%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, folderPath
  IniWrite, %ocrLanguage%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ocrLanguage
  IniWrite, %clientLanguage%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, clientLanguage
  IniWrite, %autoLaunchMonitor%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, autoLaunchMonitor
  IniWrite, %instanceLaunchDelay%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, instanceLaunchDelay
  ; Save extra settings
  IniWrite, %tesseractPath%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, tesseractPath
  IniWrite, %applyRoleFilters%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, applyRoleFilters
  IniWrite, %debugMode%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, debugMode
  IniWrite, %tesseractOption%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, tesseractOption
  IniWrite, %statusMessage%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, statusMessage
  ; Save Pack Settings
  IniWrite, %minStars%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, minStars
  IniWrite, %minStarsShiny%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, minStarsShiny
  IniWrite, %nukeAccount%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, nukeAccount
  IniWrite, %packMethod%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, packMethod
  IniWrite, %spendHourGlass%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, spendHourGlass
  IniWrite, %openExtraPack%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, openExtraPack
  IniWrite, %injectSortMethod%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, injectSortMethod
  ; Save pack selections directly without resetting them
  IniWrite, %Palkia%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Palkia
  IniWrite, %Dialga%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Dialga
  IniWrite, %Arceus%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Arceus
  IniWrite, %Shining%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Shining
  IniWrite, %Mew%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Mew
  IniWrite, %Pikachu%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Pikachu
  IniWrite, %Charizard%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Charizard
  IniWrite, %Mewtwo%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Mewtwo
  IniWrite, %Solgaleo%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Solgaleo
  IniWrite, %Lunala%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Lunala
  IniWrite, %Buzzwole%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Buzzwole
  IniWrite, %Eevee%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Eevee
  IniWrite, %HoOh%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, HoOh
  IniWrite, %Lugia%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Lugia
  IniWrite, %Suicune%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Suicune
  IniWrite, %Deluxe%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, Deluxe
  IniWrite, %MegaBlaziken%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, MegaBlaziken
  IniWrite, %MegaGyarados%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, MegaGyarados
  IniWrite, %MegaAltaria%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, MegaAltaria
  IniWrite, %MegaCharizardY%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, MegaCharizardY
 
  ; Card Detection
  IniWrite, %CheckShinyPackOnly%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, CheckShinyPackOnly
  IniWrite, %TrainerCheck%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, TrainerCheck
  IniWrite, %FullArtCheck%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, FullArtCheck
  IniWrite, %RainbowCheck%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, RainbowCheck
  IniWrite, %ShinyCheck%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ShinyCheck
  IniWrite, %CrownCheck%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, CrownCheck
  IniWrite, %InvalidCheck%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, InvalidCheck
  IniWrite, %ImmersiveCheck%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ImmersiveCheck
  IniWrite, %PseudoGodPack%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, PseudoGodPack
  ; Save S4T settings
  IniWrite, %s4tEnabled%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tEnabled
  IniWrite, %s4tSilent%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tSilent
  IniWrite, %s4t3Dmnd%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4t3Dmnd
  IniWrite, %s4t4Dmnd%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4t4Dmnd
  IniWrite, %s4t1Star%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4t1Star
  IniWrite, %s4tFoil%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tFoil
  IniWrite, %s4tRainbow%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tRainbow
  IniWrite, %s4tFullart%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tFullart
  IniWrite, %s4tTrainer%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tTrainer
  IniWrite, %s4tShiny%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tShiny
  IniWrite, %s4tGholdengo%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tGholdengo
  IniWrite, %s4tWP%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tWP
  IniWrite, %s4tWPMinCards%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tWPMinCards
  IniWrite, %s4tDiscordUserId%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tDiscordUserId
  IniWrite, %s4tDiscordWebhookURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tDiscordWebhookURL
  IniWrite, %s4tSendAccountXml%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, s4tSendAccountXml
  ; Save Discord Settings
  IniWrite, %discordWebhookURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, discordWebhookURL
  IniWrite, %discordUserId%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, discordUserId
  IniWrite, %sendAccountXml%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, sendAccountXml
  ; HeartBeat Settings
  IniWrite, %heartBeat%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, heartBeat
  IniWrite, %heartBeatWebhookURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, heartBeatWebhookURL
  IniWrite, %heartBeatName%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, heartBeatName
  IniWrite, %heartBeatDelay%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, heartBeatDelay
  ; Save Download Settings
  IniWrite, %mainIdsURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, mainIdsURL
  IniWrite, %vipIdsURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, vipIdsURL
  ; Save showcase settings
  IniWrite, %showcaseEnabled%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, showcaseEnabled 
  IniWrite, %classicModeOnly%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, classicModeOnly

  
  ; Save Rename Settings
  IniWrite, %renameMode%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, renameMode
  IniWrite, %renameAndSaveAndReload%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, renameAndSaveAndReload
  IniWrite, %targetUsername%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, targetUsername
  IniWrite, %renameXML%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, renameXML
  IniWrite, %renameXMLwithFC%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, renameXMLwithFC

  IniWrite, %ChangeLNMode%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ChangeLNMode
  IniWrite, %targetLN%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, targetLN

  ; Save Claim Bonus Settings
  IniWrite, %redeemTokens%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, redeemTokens
  IniWrite, %ClaimBonusWeek%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ClaimBonusWeek
  IniWrite, %BonusWeekPos%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, BonusWeekPos
  IniWrite, %claimAnnivCountdown%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, claimAnnivCountdown
  IniWrite, %AnnivPos%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, AnnivPos
  IniWrite, %claimFutureBonusPrep%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, claimFutureBonusPrep
  IniWrite, %FutureBonusPos%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, FutureBonusPos
  IniWrite, %ClaimMail%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, ClaimMail
  IniWrite, %captureWebhookURL%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, captureWebhookURL
  IniWrite, %insMonitorCD%, %A_ScriptDir%\..\..\Settings.ini, UserSettings, insMonitorCD
  
  

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

; ========== Friend ID Section ==========
;sectionColor := "cWhite"
;Gui, Add, GroupBox, x5 y0 w240 h50 %sectionColor%, Friend ID
;if(FriendID = "ERROR" || FriendID = "")
  ;FriendID =
;Gui, Add, Edit, vFriendID w180 x35 y20 h20 -E0x200 Background2A2A2A cWhite, %FriendID%

; ========== Instance Settings Section ==========
sectionColor := "cWhite"
Gui, Add, GroupBox, x5 y0 w240 h180 %sectionColor%, Instance Settings
Gui, Add, Text, x20 y25 %sectionColor%, % currentDictionary.Txt_Instances
Gui, Add, Edit, vInstances w50 x125 y23 h20 -E0x200 Background2A2A2A cWhite Center, %Instances%
Gui, Add, Text, x20 y50 %sectionColor%, % currentDictionary.Txt_Columns
Gui, Add, Edit, vColumns w50 x125 y48 h20 -E0x200 Background2A2A2A cWhite Center, %Columns%
Gui, Add, Text, x20 y75 %sectionColor%, % currentDictionary.Txt_InstanceStartDelay
Gui, Add, Edit, vinstanceStartDelay w50 x125 y73 h20 -E0x200 Background2A2A2A cWhite Center, %instanceStartDelay%

Gui, Add, Checkbox, % (runMain ? "Checked" : "") " vrunMain gmainSettings x20 y100 " . sectionColor, % currentDictionary.Txt_runMain
Gui, Add, Edit, % "vMains w50 x125 y98 h20 -E0x200 Background2A2A2A " . sectionColor . " Center" . (runMain ? "" : " Hidden"), %Mains%

Gui, Add, Checkbox, % (autoUseGPTest ? "Checked" : "") " vautoUseGPTest gautoUseGPTestSettings x20 y125 " . sectionColor, % currentDictionary.Txt_autoUseGPTest
Gui, Add, Edit, % "vTestTime w50 x185 y123 h20 -E0x200 Background2A2A2A " . sectionColor . " Center" . (autoUseGPTest ? "" : " Hidden"), %TestTime%

Gui, Add, Text, x20 y150 %sectionColor%, % currentDictionary.Txt_AccountName
Gui, Add, Edit, vAccountName w110 x125 y148 h20 -E0x200 Background2A2A2A cWhite Center, %AccountName%
; ========== Time Settings Section ==========
sectionColor := "c9370DB" ; Purple
Gui, Add, GroupBox, x5 y180 w240 h165 %sectionColor%, Time Settings
Gui, Add, Text, x20 y205 %sectionColor%, % currentDictionary.Txt_Delay
Gui, Add, Edit, vDelay w60 x145 y203 h20 -E0x200 Background2A2A2A cWhite Center, %Delay%
Gui, Add, Text, x20 y230 %sectionColor%, % currentDictionary.Txt_SwipeSpeed
Gui, Add, Edit, vswipeSpeed w60 x145 y228 h20 -E0x200 Background2A2A2A cWhite Center, %swipeSpeed%
Gui, Add, Text, x20 y255 %sectionColor%, % currentDictionary.Txt_WaitTime
Gui, Add, Edit, vwaitTime w60 x145 y253 h20 -E0x200 Background2A2A2A cWhite Center, %waitTime%
Gui, Add, Checkbox, % (slowMotion ? "Checked" : "") " vslowMotion gCheckMutex x20 y280 " . sectionColor, Base Game (2x No Menu)
Gui, Add, Checkbox, % (NineMod ? "Checked" : "") " vNineMod gCheckMutex x20 y300 " . sectionColor, NineMod Menu 3x

if(!NineMod && !slowMotion)
  Bankai := 1 

Gui, Add, Checkbox, % (Bankai ? "Checked" : "") " vBankai gCheckMutex x20 y320 " . sectionColor, Bankai Mod Menu 3x


; ========== System Settings Section ==========
sectionColor := "c4169E1" ; Royal Blue
Gui, Add, GroupBox, x5 y345 w240 h245 %sectionColor%, System Settings
Gui, Add, Text, x20 y365 %sectionColor%, % currentDictionary.Txt_Monitor
SysGet, MonitorCount, MonitorCount
MonitorOptions := ""
Loop, %MonitorCount% {
  SysGet, MonitorName, MonitorName, %A_Index%
  SysGet, Monitor, Monitor, %A_Index%
  MonitorOptions .= (A_Index > 1 ? "|" : "") "" A_Index ": (" MonitorRight - MonitorLeft "x" MonitorBottom - MonitorTop ")"
}
SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
Gui, Add, DropDownList, x20 y385 w125 vSelectedMonitorIndex Choose%SelectedMonitorIndex% Background2A2A2A cWhite, %MonitorOptions%
Gui, Add, Text, x155 y365 %sectionColor%, % currentDictionary.Txt_Scale

defaultLanguageList := "Scale125|Scale100"
if (defaultLanguage = "Scale125") {
  defaultLang := 1
  scaleParam := 277
} else if (defaultLanguage = "Scale100") {
  defaultLang := 2
  scaleParam := 287
}
Gui, Add, DropDownList, x155 y385 w75 vdefaultLanguage choose%defaultLang% Background2A2A2A cWhite, %defaultLanguageList%
Gui, Add, Text, x20 y415 %sectionColor%, % currentDictionary.Txt_RowGap
Gui, Add, Edit, vRowGap w50 x125 y415 h20 -E0x200 Background2A2A2A cWhite Center, %RowGap%
Gui, Add, Text, x20 y440 %sectionColor%, % currentDictionary.Txt_FolderPath
Gui, Add, Edit, vfolderPath w210 x20 y460 h20 -E0x200 Background2A2A2A cWhite, %folderPath%

Gui, Add, Text, x20 y490 %sectionColor%, OCR:

; ========== Language Pack list ==========
ocrLanguageList := "en|zh|es|de|fr|ja|ru|pt|ko|it|tr|pl|nl|sv|ar|uk|id|vi|th|he|cs|no|da|fi|hu|el|zh-TW"

if (ocrLanguage != "")
{
  index := 0
  Loop, Parse, ocrLanguageList, |
  {
    index++
    if (A_LoopField = ocrLanguage)
    {
      defaultOcrLang := index
      break
    }
  }
}

Gui, Add, DropDownList, vocrLanguage choose%defaultOcrLang% x60 y485 w50 Background2A2A2A cWhite, %ocrLanguageList%

Gui, Add, Text, x125 y490 %sectionColor%, Client:

; ========== Client Language Pack list ==========
clientLanguageList := "en|es|fr|de|it|pt|jp|ko|cn"

if (clientLanguage != "")
{
  index := 0
  Loop, Parse, clientLanguageList, |
  {
    index++
    if (A_LoopField = clientLanguage)
    {
      defaultClientLang := index
      break
    }
  }
}

Gui, Add, DropDownList, vclientLanguage choose%defaultClientLang% x170 y485 w50 Background2A2A2A cWhite, %clientLanguageList%
Gui, Add, Checkbox, % (tesseractOption ? "Checked" : "") " vtesseractOption x20 y515 " . sectionColor, % currentDictionary.Txt_tesseractOption
Gui, Add, Text, x20 y540 %sectionColor%, % currentDictionary.Txt_InstanceLaunchDelay
Gui, Add, Edit, vinstanceLaunchDelay w50 x170 y538 h20 -E0x200 Background2A2A2A cWhite Center, %instanceLaunchDelay%
Gui, Add, Checkbox, % (autoLaunchMonitor ? "Checked" : "") " vautoLaunchMonitor x20 y565 " . sectionColor, % currentDictionary.Txt_autoLaunchMonitor
Gui, Add, Edit, vinsMonitorCD w30 x170 y563 h20 -E0x200 Background2A2A2A cWhite Center, %insMonitorCD%
Gui, Add, Text, x205 y565 %sectionColor%, Mins

; ========== God Pack Settings Section ==========
sectionColor := "c39FF14" ; Neon green
Gui, Add, GroupBox, x255 y0 w240 h200 %sectionColor%, God Pack Settings
Gui, Add, Text, x270 y25 %sectionColor%, % currentDictionary.Txt_MinStars
Gui, Add, Edit, vminStars w25 x410 y23 h20 -E0x200 Background2A2A2A cWhite Center, %minStars%
Gui, Add, Text, x270 y50 %sectionColor%, % currentDictionary.Txt_ShinyMinStars
Gui, Add, Edit, vminStarsShiny w25 x410 y48 h20 -E0x200 Background2A2A2A cWhite Center, %minStarsShiny%

Gui, Add, Text, x270 y75 %sectionColor%, % currentDictionary.Txt_DeleteMethod
if (deleteMethod = "13 Pack")
  defaultDelete := 1
else if (deleteMethod = "Inject")
  defaultDelete := 2
else if (deleteMethod = "Inject Missions")
  defaultDelete := 3
else if (deleteMethod = "Inject for Reroll")
  defaultDelete := 4
;	SquallTCGP 2025.03.12 - 	Adding the delete method 5 Pack (Fast) to the delete method dropdown list.
Gui, Add, DropDownList, vdeleteMethod gdeleteSettings choose%defaultDelete% x350 y73 w130 Background2A2A2A cWhite, 13 Pack|Inject|Inject Missions|Inject for Reroll
Gui, Add, Checkbox, % (packMethod ? "Checked" : "") " vpackMethod x270 y100 " . sectionColor . ((deleteMethod = "Inject for Reroll") ? "" : " Hidden"), % currentDictionary.Txt_packMethod
;Gui, Add, Checkbox, % (nukeAccount ? "Checked" : "") " vnukeAccount x270 y120 " . sectionColor . ((deleteMethod = "13 Pack")? "": " Hidden"), % currentDictionary.Txt_nukeAccount
Gui, Add, Checkbox, % (openExtraPack ? "Checked" : "") " vopenExtraPack gopenExtraPackSettings x270 y120 " . sectionColor . ((deleteMethod = "Inject for Reroll") ? "" : " Hidden"), % currentDictionary.Txt_openExtraPack
Gui, Add, Checkbox, % (spendHourGlass ? "Checked" : "") " vspendHourGlass gspendHourGlassSettings x270 y140 " . sectionColor . ((deleteMethod = "13 Pack")? " Hidden":""), % currentDictionary.Txt_spendHourGlass

Gui, Add, Text, x270 y165 %sectionColor%, % currentDictionary.SortByText
; Determine which option to pre-select
sortOption := 1 ; Default (ModifiedAsc)
if (injectSortMethod = "ModifiedDesc")
  sortOption := 2
else if (injectSortMethod = "PacksAsc")
  sortOption := 3
else if (injectSortMethod = "PacksDesc")
  sortOption := 4
Gui, Add, DropDownList, vSortByDropdow gSortByDropdownHandler choose%sortOption% x350 y163 w130 Background2A2A2A cWhite, Oldest First|Newest First|Fewest Packs First|Most Packs First

; ========== Card Detection Section ==========
sectionColor := "cFF4500" ; Orange Red
Gui, Add, GroupBox, x255 y205 w240 h230 %sectionColor%, Card Detection ; Orange Red
Gui, Add, Checkbox, % (FullArtCheck ? "Checked" : "") " vFullArtCheck x270 y230 " . sectionColor, % currentDictionary.Txt_FullArtCheck
Gui, Add, Checkbox, % (TrainerCheck ? "Checked" : "") " vTrainerCheck x270 y250 " . sectionColor, % currentDictionary.Txt_TrainerCheck
Gui, Add, Checkbox, % (RainbowCheck ? "Checked" : "") " vRainbowCheck x270 y270 " . sectionColor, % currentDictionary.Txt_RainbowCheck
Gui, Add, Checkbox, % (PseudoGodPack ? "Checked" : "") " vPseudoGodPack x270 y290 " . sectionColor, % currentDictionary.Txt_PseudoGodPack
Gui, Add, Checkbox, % (CheckShinyPackOnly ? "Checked" : "") " vCheckShinyPackOnly x270 y310 " . sectionColor, % currentDictionary.Txt_CheckShinyPackOnly
Gui, Add, Checkbox, % (InvalidCheck ? "Checked" : "") " vInvalidCheck x270 y330 " . sectionColor, % currentDictionary.Txt_InvalidCheck

Gui, Add, Text, x270 y355 w210 h2 +0x10 ; Creates a horizontal line
Gui, Add, Checkbox, % (CrownCheck ? "Checked" : "") " vCrownCheck x270 y365 " . sectionColor, % currentDictionary.Txt_CrownCheck
Gui, Add, Checkbox, % (ShinyCheck ? "Checked" : "") " vShinyCheck x270 y385 " . sectionColor, % currentDictionary.Txt_ShinyCheck
Gui, Add, Checkbox, % (ImmersiveCheck ? "Checked" : "") " vImmersiveCheck x270 y405 " . sectionColor, % currentDictionary.Txt_ImmersiveCheck


; ========== Claim Bonus Section ==========
sectionColor := "cFFA64D"
Gui, Add, GroupBox, x255 y440 w240 h150 %sectionColor%, Claim Bonus Settings
Gui, Add, Checkbox, % (redeemTokens ? "Checked" : "") " vredeemTokens x270 y465 " . sectionColor, Redeem Tokens
Gui, Add, Checkbox, % (ClaimBonusWeek ? "Checked" : "") " vClaimBonusWeek x270 y490 " . sectionColor, Claim BonusWeek
Gui, Add, Checkbox, % (claimAnnivCountdown ? "Checked" : "") " vclaimAnnivCountdown x270 y515 " . sectionColor , Claim 1st Anniv Bonus
Gui, Add, Checkbox, % (ClaimMail ? "Checked" : "") " vClaimMail x270 y540 " . sectionColor , Claim Mailbox
Gui, Add, Checkbox, % (claimFutureBonusPrep ? "Checked" : "") " vclaimFutureBonusPrep x270 y565 " . sectionColor , Future Bonus (Prep)

claimBonusPos := "-1|-2|-3|-4"

if (claimBonusPos != "")
{
  index := 0
  Loop, Parse, claimBonusPos, |
  {
    index++
    if (A_LoopField = BonusWeekPos)
        defaultBonusWeekPos := index
    if (A_LoopField = AnnivPos)
        defaultAnnivPos := index
    if (A_LoopField = FutureBonusPos)
        defaultFutureBonusPos := index
  }
}

Gui, Add, DropDownList, vBonusWeekPos choose%defaultBonusWeekPos% x450 y488 w35 Background2A2A2A cWhite, %claimBonusPos%
Gui, Add, DropDownList, vAnnivPos choose%defaultAnnivPos% x450 y513 w35 Background2A2A2A cWhite, %claimBonusPos%
Gui, Add, DropDownList, vFutureBonusPos choose%defaultFutureBonusPos% x450 y563 w35 Background2A2A2A cWhite, %claimBonusPos%

; ========== Column 3 ==========
; ==============================
sectionColor := "cFFD700" ; Gold

; B1 Series Group Box (3 items)
Gui, Add, GroupBox, x505 y0 w240 h130 %sectionColor%, B1 series
Gui, Add, Checkbox, % (MegaCharizardY ? "Checked" : "") " vMegaCharizardY x520 y25 " . sectionColor, % currentDictionary.Txt_MegaCharizardY
Gui, Add, Checkbox, % (MegaBlaziken ? "Checked" : "") " vMegaBlaziken x520 y50 " . sectionColor, % currentDictionary.Txt_MegaBlaziken
Gui, Add, Checkbox, % (MegaGyarados ? "Checked" : "") " vMegaGyarados x520 y75 " . sectionColor, % currentDictionary.Txt_MegaGyarados
Gui, Add, Checkbox, % (MegaAltaria ? "Checked" : "") " vMegaAltaria x520 y100 " . sectionColor, % currentDictionary.Txt_MegaAltaria
/*

; A4 Series Group Box 
Gui, Add, GroupBox, x505 y110 w240 h90 %sectionColor%, A4 series
Gui, Add, Checkbox, % (Deluxe ? "Checked" : "") " vDeluxe x515 y140 " . sectionColor, % currentDictionary.Txt_Deluxe
Gui, Add, Checkbox, % (Suicune ? "Checked" : "") " vSuicune x635 y140 " . sectionColor, % currentDictionary.Txt_Suicune
Gui, Add, Checkbox, % (HoOh ? "Checked" : "") " vHooH x515 y165 " . sectionColor, % currentDictionary.Txt_HoOh
Gui, Add, Checkbox, % (Lugia ? "Checked" : "") " vLugia x635 y165 " . sectionColor, % currentDictionary.Txt_Lugia


; A3 Series Group Box 
Gui, Add, GroupBox, x505 y205 w240 h90 %sectionColor%, A3 series
Gui, Add, Checkbox, % (Eevee ? "Checked" : "") " vEevee x515 y235 " . sectionColor, % currentDictionary.Txt_Eevee
Gui, Add, Checkbox, % (Buzzwole ? "Checked" : "") " vBuzzwole x635 y235 " . sectionColor, % currentDictionary.Txt_Buzzwole
Gui, Add, Checkbox, % (Solgaleo ? "Checked" : "") " vSolgaleo x515 y260 " . sectionColor, % currentDictionary.Txt_Solgaleo
Gui, Add, Checkbox, % (Lunala ? "Checked" : "") " vLunala x635 y260 " . sectionColor, % currentDictionary.Txt_Lunala

; A2 Series Group Box 
Gui, Add, GroupBox, x505 y300 w240 h90 %sectionColor%, A2 series
Gui, Add, Checkbox, % (Shining ? "Checked" : "") " vShining x515 y330 " . sectionColor, % currentDictionary.Txt_Shining
Gui, Add, Checkbox, % (Arceus ? "Checked" : "") " vArceus x635 y330 " . sectionColor, % currentDictionary.Txt_Arceus
Gui, Add, Checkbox, % (Dialga ? "Checked" : "") " vDialga x515 y355 " . sectionColor, % currentDictionary.Txt_Dialga
Gui, Add, Checkbox, % (Palkia ? "Checked" : "") " vPalkia x635 y355 " . sectionColor, % currentDictionary.Txt_Palkia

; A1 Series Group Box 
Gui, Add, GroupBox, x505 y395 w240 h90 %sectionColor%, A1 series
Gui, Add, Checkbox, % (Mew ? "Checked" : "") " vMew x515 y425 " . sectionColor, % currentDictionary.Txt_Mew
Gui, Add, Checkbox, % (Charizard ? "Checked" : "") " vCharizard x635 y425 " . sectionColor, % currentDictionary.Txt_Charizard
Gui, Add, Checkbox, % (Mewtwo ? "Checked" : "") " vMewtwo x515 y450 " . sectionColor, % currentDictionary.Txt_Mewtwo
Gui, Add, Checkbox, % (Pikachu ? "Checked" : "") " vPikachu x635 y450 " . sectionColor, % currentDictionary.Txt_Pikachu
*/

sectionColor := "cE5CAFF" 
Gui, Add, Tab3, x505 y135 w240 h135 vLegacyPacks Theme0 cE5CAFF, A4s|A3s|A2s|A1s 

Gui, Tab, 1 
Gui, Add, Checkbox, % (Deluxe ? "Checked" : "") " vDeluxe x520 y170 " . sectionColor, % currentDictionary.Txt_Deluxe
Gui, Add, Checkbox, % (Suicune ? "Checked" : "") " vSuicune x520 y195 " . sectionColor, % currentDictionary.Txt_Suicune
Gui, Add, Checkbox, % (HoOh ? "Checked" : "") " vHooH x520 y220 " . sectionColor, % currentDictionary.Txt_HoOh
Gui, Add, Checkbox, % (Lugia ? "Checked" : "") " vLugia x520 y245 " . sectionColor, % currentDictionary.Txt_Lugia

Gui, Tab, 2
Gui, Add, Checkbox, % (Eevee ? "Checked" : "") " vEevee x520 y170 " . sectionColor, % currentDictionary.Txt_Eevee
Gui, Add, Checkbox, % (Buzzwole ? "Checked" : "") " vBuzzwole x520 y195 " . sectionColor, % currentDictionary.Txt_Buzzwole
Gui, Add, Checkbox, % (Solgaleo ? "Checked" : "") " vSolgaleo x520 y220 " . sectionColor, % currentDictionary.Txt_Solgaleo
Gui, Add, Checkbox, % (Lunala ? "Checked" : "") " vLunala x520 y245 " . sectionColor, % currentDictionary.Txt_Lunala

Gui, Tab, 3
Gui, Add, Checkbox, % (Shining ? "Checked" : "") " vShining x520 y170 " . sectionColor, % currentDictionary.Txt_Shining
Gui, Add, Checkbox, % (Arceus ? "Checked" : "") " vArceus x520 y195 " . sectionColor, % currentDictionary.Txt_Arceus
Gui, Add, Checkbox, % (Dialga ? "Checked" : "") " vDialga x520 y220 " . sectionColor, % currentDictionary.Txt_Dialga
Gui, Add, Checkbox, % (Palkia ? "Checked" : "") " vPalkia x520 y245 " . sectionColor, % currentDictionary.Txt_Palkia

Gui, Tab, 4
Gui, Add, Checkbox, % (Mew ? "Checked" : "") " vMew x520 y170 " . sectionColor, % currentDictionary.Txt_Mew
Gui, Add, Checkbox, % (Charizard ? "Checked" : "") " vCharizard x520 y195 " . sectionColor, % currentDictionary.Txt_Charizard
Gui, Add, Checkbox, % (Mewtwo ? "Checked" : "") " vMewtwo x520 y220 " . sectionColor, % currentDictionary.Txt_Mewtwo
Gui, Add, Checkbox, % (Pikachu ? "Checked" : "") " vPikachu x520 y245 " . sectionColor, % currentDictionary.Txt_Pikachu
Gui, Tab

; ========== Rename Setting ==========
sectionColor := "cFFDDAA" ; 
Gui, Add, Tab3, x505 y275 w240 h215 vextrafunctions Theme0 cFFDDAA, Rename Mode|Change LNG 

Gui, Tab, 1 
Gui, Add, Checkbox, % (RenameMode ? "Checked" : "") " vRenameMode x520 y310 gRenameSettings " . sectionColor, RenameMode


if(StrLen(targetUsername) < 3)
  targetUsername =

if (RenameMode) {
  Gui, Add, Text, vtargetUsernameEntry x520 y335 %sectionColor%, Target Name:
  Gui, Add, Edit, vtargetUsername w210 x520 y355 h20 -E0x200 Background2A2A2A cWhite, %targetUsername%
  Gui, Add, Text, x520 y385 w210 h2 vrenameLine +0x10 ; Creates a horizontal line
  Gui, Add, Checkbox, % (renameXML ? "Checked" : "") " vrenameXML x520 y400 " . sectionColor, Rename XML
  Gui, Add, Checkbox, % (renameXMLwithFC ? "Checked" : "") " vrenameXMLwithFC x520 y425 " . sectionColor, Rename XML with FC
  Gui, Add, Checkbox, % (renameAndSaveAndReload ? "Checked" : "") " vrenameAndSaveAndReload x520 y450 " . sectionColor, Rename And Reload Mode
} else {
  Gui, Add, Text, vtargetUsernameEntry x520 y335 Hidden %sectionColor%, targetUsernameEntry:
  Gui, Add, Edit, vtargetUsername w210 x520 y355 h20 Hidden -E0x200 Background2A2A2A cWhite, %targetUsername%
  Gui, Add, Text, x520 y385 w210 h2 Hidden vrenameLine +0x10 ; Creates a horizontal line
  Gui, Add, Checkbox, % (renameXML ? "Checked" : "") " vrenameXML x520 y400 Hidden " . sectionColor, Rename XML
  Gui, Add, Checkbox, % (renameXMLwithFC ? "Checked" : "") " vrenameXMLwithFC x520 y425 Hidden " . sectionColor, Rename XML with FC
  Gui, Add, Checkbox, % (renameAndSaveAndReload ? "Checked" : "") " vrenameAndSaveAndReload x520 y450 Hidden " . sectionColor, Rename And Reload Mode
}


; ========== Change LNG Setting ==========
Gui, Tab, 2
Gui, Add, Checkbox, % (ChangeLNMode ? "Checked" : "") " vChangeLNMode x520 y310 gChangeLNSettings " . sectionColor, Change LNG Mode

targetLanguageList := "en|es|fr|de|it|pt|jp|ko|cn"

if (targetLanguageList != "")
{
  index := 0
  Loop, Parse, targetLanguageList, |
  {
    index++
    if (A_LoopField = targetLN)
    {
      defaultTargetLN := index
      break
    }
  }
}



if(ChangeLNMode){
    Gui, Add, Text, vtxt_targetLN x520 y340 %sectionColor%, Target LNG:
    Gui, Add, DropDownList, vtargetLN choose%defaultTargetLN% x610 y338 w50 Background2A2A2A cWhite, %targetLanguageList%

} else {
    Gui, Add, Text, vtxt_targetLN x520 y340 Hidden %sectionColor%, Target LNG:
    Gui, Add, DropDownList, vtargetLN choose%defaultTargetLN% x610 y338 w50 Hidden Background2A2A2A cWhite, %targetLanguageList%
}

Gui, Tab





; ========== Column 4 ==========
; ==============================
; S4T Settings Section
sectionColor := "cFF4500"
Gui, Add, GroupBox, x755 y0 w240 h405 %sectionColor%, S4T Selection
Gui, Add, Checkbox, % (s4tEnabled ? "Checked" : "") " vs4tEnabled gs4tSettings x770 y25 cWhite", % currentDictionary.Txt_s4tEnabled
if(s4tEnabled) {
  Gui, Add, Checkbox, % (s4tSilent ? "Checked" : "") " vs4tSilent x770 y45 " . sectionColor, % currentDictionary.Txt_s4tSilent
  Gui, Add, Checkbox, % (s4t3Dmnd ? "Checked" : "") " vs4t3Dmnd x770 y65 " . sectionColor, 3 ◆◆◆
  Gui, Add, Checkbox, % (s4t4Dmnd ? "Checked" : "") " vs4t4Dmnd x770 y85 " . sectionColor, 4 ◆◆◆◆
  Gui, Add, Checkbox, % (s4tFoil ? "Checked" : "") " vs4tFoil x770 y105 " . sectionColor, 4 ◆◆◆◆ Foil
  Gui, Add, Checkbox, % (s4t1Star ? "Checked" : "") " vs4t1Star x770 y125 " . sectionColor, 1 ★
  Gui, Add, Text, x770 y150 w210 h2 vs4tLine_3 +0x10 ; Creates a horizontal line

  Gui, Add, Checkbox, % (s4tRainbow ? "Checked" : "") " vs4tRainbow x770 y160 " . sectionColor, 2 ★★ Rainbow
  Gui, Add, Checkbox, % (s4tFullart ? "Checked" : "") " vs4tFullart x770 y180 " . sectionColor, 2 ★★ Full Art
  Gui, Add, Checkbox, % (s4tTrainer ? "Checked" : "") " vs4tTrainer x770 y200 " . sectionColor, 2 ★★ Trainer
  Gui, Add, Checkbox, % (s4tShiny ? "Checked" : "") " vs4tShiny x770 y220 " . sectionColor, 1★ 2 ★★ Shiny

  Gui, Add, Text, x770 y250 w210 h2 vs4tLine_1 +0x10 ; Creates a horizontal line
  ;Gui, Add, Checkbox, % (s4tWP ? "Checked" : "") " vs4tWP gs4tWPSettings x770 y260 cWhite", % currentDictionary.Txt_s4tWP
  ;Gui, Add, Text, % "x770 y285 vTxt_s4tWPMinCards " . sectionColor . (s4tWP ? "" : " Hidden"), % currentDictionary.Txt_s4tWPMinCards
  ;Gui, Add, Edit, % "cFDFDFD w50 x865 y285 h20 vs4tWPMinCards -E0x200 Background2A2A2A Center cWhite gs4tWPMinCardsCheck" . (s4tWP ? "" : " Hidden"), %s4tWPMinCards%
  ;Gui, Add, Text, x770 y315 w210 h2 vs4tLine_2 +0x10 ; Creates a horizontal line
  Gui, Add, Text, x770 y260 vS4TDiscordSettingsSubHeading %sectionColor%, % currentDictionary.S4TDiscordSettingsSubHeading
  
  if(StrLen(s4tDiscordUserId) < 3)
    s4tDiscordUserId := ""
  if(StrLen(s4tDiscordWebhookURL) < 3)
    s4tDiscordWebhookURL := ""
    
  Gui, Add, Text, x770 y285 vTxt_s4tDiscordUserId %sectionColor%, Discord ID:
  Gui, Add, Edit, vs4tDiscordUserId w210 x770 y305 h20 -E0x200 Background2A2A2A cWhite, %s4tDiscordUserId%
  
  Gui, Add, Text, x770 y330 vTxt_s4tDiscordWebhookURL %sectionColor%, Webhook URL:
  Gui, Add, Edit, vs4tDiscordWebhookURL w210 x770 y350 h20 -E0x200 Background2A2A2A cWhite, %s4tDiscordWebhookURL%
  
  Gui, Add, Checkbox, % (s4tSendAccountXml ? "Checked" : "") " vs4tSendAccountXml x770 y375 " . sectionColor, % currentDictionary.Txt_s4tSendAccountXml

} else {
  Gui, Add, Checkbox, % (s4tSilent ? "Checked" : "") " vs4tSilent x770 y45 Hidden " . sectionColor, % currentDictionary.Txt_s4tSilent
  Gui, Add, Checkbox, % (s4t3Dmnd ? "Checked" : "") " vs4t3Dmnd x770 y65 Hidden " . sectionColor, 3 ◆◆◆
  Gui, Add, Checkbox, % (s4t4Dmnd ? "Checked" : "") " vs4t4Dmnd x770 y85 Hidden " . sectionColor, 4 ◆◆◆◆
  
  Gui, Add, Checkbox, % (s4tFoil ? "Checked" : "") " vs4tFoil x7750 y105 Hidden " . sectionColor, 4 ◆◆◆◆ Foil
  
  Gui, Add, Checkbox, % (s4t1Star ? "Checked" : "") " vs4t1Star x770 y125 Hidden " . sectionColor, 1 ★
  Gui, Add, Text, Hidden x770 y150 w210 h2 vs4tLine_3 +0x10 ; Creates a horizontal line
  Gui, Add, Checkbox, % (s4tRainbow ? "Checked" : "") " vs4tRainbow x770 y160 Hidden " . sectionColor, 2 ★★ Rainbow
  Gui, Add, Checkbox, % (s4tFullart ? "Checked" : "") " vs4tFullart x770 y180 Hidden " . sectionColor, 2 ★★ Full Art
  Gui, Add, Checkbox, % (s4tTrainer ? "Checked" : "") " vs4tTrainer x770 y200 Hidden " . sectionColor, 2 ★★ Trainer
  
  Gui, Add, Checkbox, % (s4tShiny ? "Checked" : "") " vs4tShiny x770 y220 Hidden " . sectionColor, Shiny
  Gui, Add, Text, x775 y260 vS4TDiscordSettingsSubHeading Hidden %sectionColor%, % currentDictionary.S4TDiscordSettingsSubHeading
  
  if(StrLen(s4tDiscordUserId) < 3)
    s4tDiscordUserId := ""
  if(StrLen(s4tDiscordWebhookURL) < 3)
    s4tDiscordWebhookURL := ""
    
  Gui, Add, Text, Hidden x775 y285 vTxt_s4tDiscordUserId %sectionColor%, Discord ID:
  Gui, Add, Edit, vs4tDiscordUserId w210 x775 y305 h20 -E0x200 Background2A2A2A cWhite Hidden, %s4tDiscordUserId%
  Gui, Add, Text, Hidden x775 y330 vTxt_s4tDiscordWebhookURL %sectionColor%, Webhook URL:
  Gui, Add, Edit, vs4tDiscordWebhookURL w210 x775 y350 h20 -E0x200 Background2A2A2A cWhite Hidden, %s4tDiscordWebhookURL%
  Gui, Add, Checkbox, % (s4tSendAccountXml ? "Checked" : "") " vs4tSendAccountXml x770 y375 Hidden " . sectionColor, % currentDictionary.Txt_s4tSendAccountXml
}

sectionColor := "cGray"
Gui, Add, GroupBox, x755 y410 w240 h80 %sectionColor%, Capture Settings
Gui, Add, Text, x770 y435 vTxt_captureWebhookURL %sectionColor%,Capture Webhook URL:
Gui, Add, Edit, vcaptureWebhookURL w210 x770 y455 h20 -E0x200 Background2A2A2A cWhite, %captureWebhookURL%



; ========== Column 5 ==========
; ==============================
; ========== Discord Settings Section ==========
sectionColor := "cFF69B4" ; Hot pink
Gui, Add, GroupBox, x1005 y0 w240 h130 %sectionColor%, Discord Settings
if(StrLen(discordUserID) < 3)
  discordUserID =
if(StrLen(discordWebhookURL) < 3)
  discordWebhookURL =
Gui, Add, Text, x1020 y20 %sectionColor%, Discord ID:
Gui, Add, Edit, vdiscordUserId w210 x1020 y40 h20 -E0x200 Background2A2A2A cWhite, %discordUserId%
Gui, Add, Text, x1020 y60 %sectionColor%, Webhook URL:
Gui, Add, Edit, vdiscordWebhookURL w210 x1020 y80 h20 -E0x200 Background2A2A2A cWhite, %discordWebhookURL%
Gui, Add, Checkbox, % (sendAccountXml ? "Checked" : "") " vsendAccountXml x1020 y105 " . sectionColor, Send Account XML

; ========== Heartbeat Settings Section ==========
sectionColor := "c00FFFF" ; Cyan
Gui, Add, GroupBox, x1005 y135 w240 h160 %sectionColor%, Heartbeat Settings
Gui, Add, Checkbox, % (heartBeat ? "Checked" : "") " vheartBeat x1020 y160 gdiscordSettings " . sectionColor, % currentDictionary.Txt_heartBeat

if(StrLen(heartBeatName) < 3)
  heartBeatName =
if(StrLen(heartBeatWebhookURL) < 3)
  heartBeatWebhookURL =

if (heartBeat) {
  Gui, Add, Text, vhbName x1020 y180 %sectionColor%, % currentDictionary.hbName
  Gui, Add, Edit, vheartBeatName w210 x1020 y200 h20 -E0x200 Background2A2A2A cWhite, %heartBeatName%
  Gui, Add, Text, vhbURL x1020 y220 %sectionColor%, Webhook URL:
  Gui, Add, Edit, vheartBeatWebhookURL w210 x1020 y240 h20 -E0x200 Background2A2A2A cWhite, %heartBeatWebhookURL%
  Gui, Add, Text, vhbDelay x1020 y265 %sectionColor%, % currentDictionary.hbDelay
  Gui, Add, Edit, vheartBeatDelay w50 x1160 y265 h20 -E0x200 Background2A2A2A cWhite Center, %heartBeatDelay%
} else {
  Gui, Add, Text, vhbName x1020 y175 Hidden %sectionColor%, % currentDictionary.hbName
  Gui, Add, Edit, vheartBeatName w210 x1020 y195 h20 Hidden -E0x200 Background2A2A2A cWhite, %heartBeatName%
  Gui, Add, Text, vhbURL x1020 y215 Hidden %sectionColor%, Webhook URL:
  Gui, Add, Edit, vheartBeatWebhookURL w210 x1020 y235 h20 Hidden -E0x200 Background2A2A2A cWhite, %heartBeatWebhookURL%
  Gui, Add, Text, vhbDelay x1020 y260 Hidden %sectionColor%, % currentDictionary.hbDelay
  Gui, Add, Edit, vheartBeatDelay w50 x1160 y260 h20 Hidden -E0x200 Background2A2A2A cWhite Center, %heartBeatDelay%
}


; ========== Download Settings Section (Bottom right) ==========
sectionColor := "cWhite"
;Gui, Add, GroupBox, x1005 y295 w240 h145 %sectionColor%, Download Settings ;
Gui, Add, GroupBox, x505 y490 w490 h100 %sectionColor%, Download Settings

if(StrLen(mainIdsURL) < 3)
  mainIdsURL =
if(StrLen(vipIdsURL) < 3)
  vipIdsURL =

Gui, Add, Text, x515 y515 %sectionColor%, ids.txt API:
Gui, Add, Edit, vmainIdsURL w300 x625 y515 h20 -E0x200 Background2A2A2A cWhite, %mainIdsURL%
Gui, Add, Text, x515 y540 %sectionColor%, vip_ids.txt API:
Gui, Add, Edit, vvipIdsURL w300 x625 y540 h20 -E0x200 Background2A2A2A cWhite, %vipIdsURL%
Gui, Add, Checkbox, % (showcaseEnabled ? "Checked" : "") " vshowcaseEnabled x515 y565 " . sectionColor, % currentDictionary.Txt_showcaseEnabled

sectionColor := "cRed"
Gui, Add, GroupBox, x1005 y300 w240 h55 %sectionColor%, Classic Mode ;
Gui, Add, Checkbox, % (classicModeOnly ? "Checked" : "") " vclassicModeOnly x1020 y325 " . sectionColor, Only use Classic Mode GUI 

; ========== Action Buttons ==========
Gui, Add, Button, gLaunchAllMumu  x1005 y365 w240 h35, Launch All Mumu
Gui, Add, Button, gArrangeWindows  x1005 y405 w240 h35 , Arrange Windows
Gui, Add, Button, gOpenExtraMode x1005 y445 w240 h35, Extra Settings
Gui, Add, Button, gSave x1005 y485 w240 h35, Save Settings
Gui, Add, Button, gStartBot x1005 y525 w240 h65, Start Bot



Gui, Show, w%GUI_WIDTH% h%GUI_HEIGHT%, Classic Mode
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

discordSettings:
  Gui, Submit, NoHide
  
  if (heartBeat) {
    GuiControl, Show, heartBeatName
    GuiControl, Show, heartBeatWebhookURL
    GuiControl, Show, heartBeatDelay
    GuiControl, Show, hbName
    GuiControl, Show, hbURL
    GuiControl, Show, hbDelay
  }
  else {
    GuiControl, Hide, heartBeatName
    GuiControl, Hide, heartBeatWebhookURL
    GuiControl, Hide, heartBeatDelay
    GuiControl, Hide, hbName
    GuiControl, Hide, hbURL
    GuiControl, Hide, hbDelay
  }
return


RenameSettings:
  Gui, Submit, NoHide
  
  if (RenameMode) {
    GuiControl, Show, renameAndSaveAndReload
    GuiControl, Show, targetUsername
    GuiControl, Show, targetUsernameEntry
    GuiControl, Show, renameLine
    GuiControl, Show, renameXML
    GuiControl, Show, renameXMLwithFC
  }
  else {
    GuiControl, Hide, renameAndSaveAndReload
    GuiControl, Hide, targetUsername
    GuiControl, Hide, targetUsernameEntry
    GuiControl, Hide, renameLine
    GuiControl, Hide, renameXML
    GuiControl, Hide, renameXMLwithFC
  }
return

ChangeLNSettings:
    Gui, Submit, NoHide

    if (ChangeLNMode) {
    GuiControl, Show, txt_targetLN
    GuiControl, Show, targetLN
    }
    else {
    GuiControl, Hide, txt_targetLN
    GuiControl, Hide, targetLN
    }
return



CheckMutex:
    Gui, Submit, NoHide 

    if (A_GuiControl = "slowMotion" && slowMotion = 1) {
        GuiControl,, NineMod, 0  
        GuiControl,, Bankai, 0  
    } else if (A_GuiControl = "NineMod" && NineMod = 1) {
        GuiControl,, slowMotion, 0 
        GuiControl,, Bankai, 0   
    } else if (A_GuiControl = "Bankai" && Bankai = 1){
        GuiControl,, slowMotion, 0
        GuiControl,, NineMod, 0   

    }

return

deleteSettings:
  Gui, Submit, NoHide
  if (deleteMethod = "13 Pack") {
    GuiControl, Hide, spendHourGlass
    GuiControl, Hide, packMethod
    GuiControl, Hide, openExtraPack
    GuiControl, Show, nukeAccount
  } else if (deleteMethod = "Inject for Reroll") {
    GuiControl, Show, spendHourGlass
    GuiControl, Show, packMethod
    GuiControl, Show, openExtraPack
    GuiControl, Hide, nukeAccount
    nukeAccount := false
  } else {
    GuiControl, Show, spendHourGlass
    GuiControl, Hide, packMethod
    GuiControl, Hide, openExtraPack
    GuiControl, Hide, nukeAccount
    nukeAccount := false
  }
return

openExtraPackSettings:
  Gui, Submit, NoHide
  if (openExtraPack) {
    GuiControl,, spendHourGlass, 0
  }
Return

spendHourGlassSettings:
  Gui, Submit, NoHide
  if (SpendHourGlass) {
    GuiControl,, openExtraPack, 0
  }
Return

s4tSettings:
  Gui, Submit, NoHide
  if(s4tEnabled) {
    GuiControl, Show, s4tSilent
    GuiControl, Show, s4t3Dmnd
    GuiControl, Show, s4t4Dmnd
    GuiControl, Show, s4t1Star
    GuiControl, Show, s4tRainbow
    GuiControl, Show, s4tFullart
    GuiControl, Show, s4tTrainer
    GuiControl, Show, s4tFoil
    GuiControl, Show, s4tLine_1
    GuiControl, Show, s4tLine_3
    GuiControl, Show, s4tWP
    GuiControl, Show, s4tShiny
    if (s4tWP) {
      GuiControl, Show, Txt_s4tWPMinCards
      GuiControl, Show, s4tWPMinCards
    }
    GuiControl, Show, s4tLine_2
    GuiControl, Show, S4TDiscordSettingsSubHeading
    GuiControl, Show, Txt_s4tDiscordUserId
    GuiControl, Show, s4tDiscordUserId
    GuiControl, Show, Txt_s4tDiscordWebhookURL
    GuiControl, Show, s4tDiscordWebhookURL
    GuiControl, Show, s4tSendAccountXml
  } else {
    GuiControl, Hide, s4tSilent
    GuiControl, Hide, s4t3Dmnd
    GuiControl, Hide, s4t4Dmnd
    GuiControl, Hide, s4t1Star
    GuiControl, Hide, s4tRainbow
    GuiControl, Hide, s4tFullart
    GuiControl, Hide, s4tTrainer
    GuiControl, Hide, s4tFoil
    GuiControl, Hide, s4tShiny
    GuiControl, Hide, s4tLine_1
    GuiControl, Hide, s4tLine_3
    GuiControl, Hide, s4tWP
    GuiControl, Hide, Txt_s4tWPMinCards
    GuiControl, Hide, s4tWPMinCards
    GuiControl, Hide, s4tLine_2
    GuiControl, Hide, S4TDiscordSettingsSubHeading
    GuiControl, Hide, Txt_s4tDiscordUserId
    GuiControl, Hide, s4tDiscordUserId
    GuiControl, Hide, Txt_s4tDiscordWebhookURL
    GuiControl, Hide, s4tDiscordWebhookURL
    GuiControl, Hide, s4tSendAccountXml
  }
return

s4tWPSettings:
  Gui, Submit, NoHide
  if (s4tWP) {
    GuiControl, Show, Txt_s4tWPMinCards
    GuiControl, Show, s4tWPMinCards
  } else {
    GuiControl, Hide, Txt_s4tWPMinCards
    GuiControl, Hide, s4tWPMinCards
  }
return

s4tWPMinCardsCheck:
    Gui, Submit, NoHide
    GuiControlGet, s4tWPMinCards
    if (s4tWPMinCards < 1)
        s4tWPMinCards := 1
    if (s4tWPMinCards > 2)
        s4tWPMinCards := 2
    GuiControl,, s4tWPMinCards, %s4tWPMinCards%
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

    if(!classicModeOnly)
      Run, %A_ScriptDir%\..\..\PTCGPB.ahk
ExitApp
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

OpenExtraMode:
    Gui, Submit, NoHide
    SaveAllSettings()
    Run, %A_ScriptDir%\Extra.ahk
    ExitApp
return

ArrangeWindows:
    Gui, Submit, NoHide
    GuiControlGet, Mains,, Mains
    GuiControlGet, Instances,, Instances
    GuiControlGet, Columns,, Columns
    GuiControlGet, SelectedMonitorIndex,, SelectedMonitorIndex
    GuiControlGet, defaultLanguage,, defaultLanguage
    GuiControlGet, rowGap,, rowGap
    
    if (defaultLanguage = "Scale125")
        scaleParam := 277
    else
        scaleParam := 287
        
    mumuFolder := folderPath . "\MuMuPlayerGlobal-12.0"
    if !FileExist(mumuFolder)
        mumuFolder := folderPath . "\MuMu Player 12"
        

    if FileExist(mumuFolder . "\nx_main") {
        titleHeight := (defaultLanguage = "Scale125") ? 50 : 40
    } else {
        titleHeight := (defaultLanguage = "Scale125") ? 45 : 36
    }

    borderWidth := 3
    rowHeight := titleHeight + 489 + 4
    
    ActualMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
    SysGet, Monitor, Monitor, %ActualMonitorIndex%

    windowsPositioned := 0
    
    if (runMain && Mains > 0) {
        Loop %Mains% {
            mainInstanceName := "Main" . (A_Index > 1 ? A_Index : "")
            SetTitleMatchMode, 3
            if (WinExist(mainInstanceName)) {
                WinActivate, %mainInstanceName%
                instanceIndex := A_Index
                currentRow := Floor((instanceIndex - 1) / Columns)
                y := MonitorTop + (currentRow * rowHeight) + (currentRow * rowGap)
                x := MonitorLeft + Mod((instanceIndex - 1), Columns) * (scaleParam - borderWidth * 2) - borderWidth
                WinMove, %mainInstanceName%,, %x%, %y%, %scaleParam%, %rowHeight%
                windowsPositioned++
            }
        }
    }

    if (Instances > 0) {
        Loop %Instances% {
            windowTitle := A_Index
            SetTitleMatchMode, 3
            if (WinExist(windowTitle)) {
                WinActivate, %windowTitle%
                if (runMain)
                    instanceIndex := (Mains - 1) + A_Index + 1
                else
                    instanceIndex := A_Index
                
                currentRow := Floor((instanceIndex - 1) / Columns)
                y := MonitorTop + (currentRow * rowHeight) + (currentRow * rowGap)
                x := MonitorLeft + Mod((instanceIndex - 1), Columns) * (scaleParam - borderWidth * 2) - borderWidth
                WinMove, %windowTitle%,, %x%, %y%, %scaleParam%, %rowHeight%
                windowsPositioned++
            }
        }
    }
    MsgBox, 64, Arrange, Arranged %windowsPositioned% windows.
return

BalanceXMLs:
    Gui, Submit, NoHide
    SaveAllSettings() ; 先儲存設定
    
    if (Instances <= 0)
        return

    ; 路徑修正：ClassicMode 在 Scripts\Include，所以 Accounts 在 ..\..\Accounts
    rootDir := A_ScriptDir . "\..\.."
    saveDir := rootDir . "\Accounts\Saved"
    tmpDir := saveDir . "\tmp"

    if !FileExist(saveDir)
        FileCreateDir, %saveDir%
    if !FileExist(tmpDir)
        FileCreateDir, %tmpDir%

    MsgBox, 64, Balance XMLs, Starting to balance XMLs... This may take a moment.
    
    Loop, Files, %saveDir%\*, D
    {
        if (A_LoopFilePath == tmpDir)
            continue
        FileMoveDir, %A_LoopFilePath%, %tmpDir%\%A_LoopFileName%, 1
    }
    Loop, Files, %saveDir%\*, F
        FileMove, %A_LoopFilePath%, %tmpDir%\%A_LoopFileName%, 1


    Loop, %Instances%
    {
        instanceDir := saveDir . "\" . A_Index
        if !FileExist(instanceDir)
            FileCreateDir, %instanceDir%
        if FileExist(instanceDir . "\list.txt")
            FileDelete, %instanceDir% . "\list.txt"
    }


    fileList := ""
    Loop, Files, %tmpDir%\*.xml, R
    {
        fileList .= A_LoopFileTimeCreated . "`t" . A_LoopFileFullPath . "`n"
    }
    Sort, fileList, R 

    instance := 1
    Loop, Parse, fileList, `n
    {
        if (A_LoopField = "")
            continue
        StringSplit, parts, A_LoopField, %A_Tab%
        FileMove, %parts2%, %saveDir%\%instance%, 1
        
        instance++
        if (instance > Instances)
            instance := 1
    }
    
    FileRemoveDir, %tmpDir%, 1
    
    MsgBox, 64, Balance XMLs, Done balancing XMLs between %Instances% instances!
return

StartBot:
    Gui, Submit, NoHide
    
    ; Quick path validation (no file I/O)
    if(StrLen(A_ScriptDir) > 200 || InStr(A_ScriptDir, " ")) {
        MsgBox, % SetUpDictionary.Error_BotPathTooLong
        return
    }
    InitializeJsonFile()    
    ; Build confirmation message with current GUI values
    confirmMsg := SetUpDictionary.Confirm_SelectedMethod . deleteMethod . "`n"
    
    confirmMsg .= "`n" . SetUpDictionary.Confirm_SelectedPacks . "`n"
    if (MegaCharizardY)
        confirmMsg .= "• " . currentDictionary.Txt_MegaCharizardY . "`n"
    if (MegaBlaziken)
        confirmMsg .= "• " . currentDictionary.Txt_MegaBlaziken . "`n"
    if (MegaGyarados)
        confirmMsg .= "• " . currentDictionary.Txt_MegaGyarados . "`n"
    if (MegaAltaria)
        confirmMsg .= "• " . currentDictionary.Txt_MegaAltaria . "`n"
    if (Deluxe)
        confirmMsg .= "• " . currentDictionary.Txt_Deluxe . "`n"
    if (Suicune)
        confirmMsg .= "• " . currentDictionary.Txt_Suicune . "`n"
    if (HoOh)
        confirmMsg .= "• " . currentDictionary.Txt_HoOh . "`n"
    if (Lugia)
        confirmMsg .= "• " . currentDictionary.Txt_Lugia . "`n"
    if (Eevee)
        confirmMsg .= "• " . currentDictionary.Txt_Eevee . "`n"
    if (Buzzwole)
        confirmMsg .= "• " . currentDictionary.Txt_Buzzwole . "`n"
    if (Solgaleo)
        confirmMsg .= "• " . currentDictionary.Txt_Solgaleo . "`n"
    if (Lunala)
        confirmMsg .= "• " . currentDictionary.Txt_Lunala . "`n"
    if (Shining)
        confirmMsg .= "• " . currentDictionary.Txt_Shining . "`n"
    if (Arceus)
        confirmMsg .= "• " . currentDictionary.Txt_Arceus . "`n"
    if (Palkia)
        confirmMsg .= "• " . currentDictionary.Txt_Palkia . "`n"
    if (Dialga)
        confirmMsg .= "• " . currentDictionary.Txt_Dialga . "`n"
    if (Pikachu)
        confirmMsg .= "• " . currentDictionary.Txt_Pikachu . "`n"
    if (Charizard)
        confirmMsg .= "• " . currentDictionary.Txt_Charizard . "`n"
    if (Mewtwo)
        confirmMsg .= "• " . currentDictionary.Txt_Mewtwo . "`n"
    if (Mew)
        confirmMsg .= "• " . currentDictionary.Txt_Mew . "`n"
    
    confirmMsg .= "`n" . SetUpDictionary.Confirm_AdditionalSettings
    additionalSettingsFound := false
    
    if (packMethod) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_1PackMethod
        additionalSettingsFound := true
    }
    if (nukeAccount && !InStr(deleteMethod, "Inject")) {
        confirmMsg .= "`n•" . SetUpDictionary.Confirm_MenuDelete
        additionalSettingsFound := true
    }
    if (spendHourGlass) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_SpendHourGlass
        additionalSettingsFound := true
    }
    if (openExtraPack) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_OpenExtraPack
        additionalSettingsFound := true
    }
    if (claimSpecialMissions && InStr(deleteMethod, "Inject")) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_ClaimMissions
        additionalSettingsFound := true
    }
    if (InStr(deleteMethod, "Inject") && sortByCreated) {
        GuiControlGet, selectedSortOption,, SortByDropdown
        confirmMsg .= "`n" . SetUpDictionary.Confirm_SortBy . selectedSortOption
        additionalSettingsFound := true
    }
    if (!additionalSettingsFound)
        confirmMsg .= "`n" . SetUpDictionary.Confirm_None
    
    confirmMsg .= "`n`n" . SetUpDictionary.Confirm_CardDetection
    cardDetectionFound := false
    
    if (FullArtCheck) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_SingleFullArt
        cardDetectionFound := true
    }
    if (TrainerCheck) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_SingleTrainer
        cardDetectionFound := true
    }
    if (RainbowCheck) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_SingleRainbow
        cardDetectionFound := true
    }
    if (PseudoGodPack) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_Double2Star
        cardDetectionFound := true
    }
    if (CrownCheck) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_SaveCrowns
        cardDetectionFound := true
    }
    if (ShinyCheck) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_SaveShiny
        cardDetectionFound := true
    }
    if (ImmersiveCheck) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_SaveImmersives
        cardDetectionFound := true
    }
    if (CheckShinyPackOnly) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_OnlyShinyPacks
        cardDetectionFound := true
    }
    if (InvalidCheck) {
        confirmMsg .= "`n" . SetUpDictionary.Confirm_IgnoreInvalid
        cardDetectionFound := true
    }
    
    if (!cardDetectionFound)
        confirmMsg .= "`n" . SetUpDictionary.Confirm_None

    confirmMsg .= "`n`n" . SetUpDictionary.Confirm_SaveForTrade
    
    if (!s4tEnabled) {
        confirmMsg .= ": " . SetUpDictionary.Confirm_Disabled
    } else {
        confirmMsg .= ": " . SetUpDictionary.Confirm_Enabled . "`n"
        confirmMsg .= "• " . SetUpDictionary.Confirm_SilentPings . ": " . (s4tSilent ? SetUpDictionary.Confirm_Enabled : SetUpDictionary.Confirm_Disabled) . "`n"
        
        ; Add enabled filters
        if (s4t3Dmnd)
            confirmMsg .= "• 3 ◆◆◆`n"
        if (s4t4Dmnd)
            confirmMsg .= "• 4 ◆◆◆◆`n"
        if (s4t1Star)
            confirmMsg .= "• 1 ★`n"
        if (s4tGholdengo && Shining)
            confirmMsg .= "• " . SetUpDictionary.Confirm_Gholdengo . "`n"
        
        ; Add Wonder Pick status
        if (s4tWP)
            confirmMsg .= "• " . SetUpDictionary.Confirm_WonderPick . ": " . s4tWPMinCards . " " . SetUpDictionary.Confirm_MinCards . "`n"
        else
            confirmMsg .= "• " . SetUpDictionary.Confirm_WonderPick . ": " . SetUpDictionary.Confirm_Disabled . "`n"
    }

    if (sendAccountXml || s4tEnabled && s4tSendAccountXml) {
        confirmMsg .= "`n`n" . SetUpDictionary.Confirm_XMLWarning . "`n"
    }

    confirmMsg .= "`n`n" . SetUpDictionary.Confirm_StartBot

    GuiControlGet, defaultLanguage,, defaultLanguage
    if (defaultLanguage = "Scale125")
        scaleParam := 277
    else
        scaleParam := 287



    ; === SHOW CONFIRMATION DIALOG IMMEDIATELY ===
    MsgBox, 4, Confirm Bot Settings, %confirmMsg%
    IfMsgBox, No
    {
        return ; Return to GUI for user to modify settings
    }
    
    
    ResetAccountLists()
    
    ; Update dropdown settings if needed
    if (InStr(deleteMethod, "Inject") && sortByCreated) {
        GuiControlGet, selectedSortOption,, SortByDropdown
        if (selectedSortOption = "Oldest First")
            injectSortMethod := "ModifiedAsc"
        else if (selectedSortOption = "Newest First")
            injectSortMethod := "ModifiedDesc"
        else if (selectedSortOption = "Fewest Packs First")
            injectSortMethod := "PacksAsc"
        else if (selectedSortOption = "Most Packs First")
            injectSortMethod := "PacksDesc"
    }
    
    ; Save all settings
    SaveAllSettings()
    
    IniRead, altWebhookSettings, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altWebhookSettings, 0
    if(altWebhookSettings){
        IniRead, altDiscordWebhookURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altDiscordWebhookURL, ""
        IniRead, altDiscordUserId, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altDiscordUserId, %DiscordUserId%
        IniRead, altheartBeat, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altheartBeat, 0
        IniRead, altheartBeatName, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altheartBeatName, %heartBeatName%
        IniRead, altheartBeatWebhookURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altheartBeatWebhookURL, ""
        IniRead, altmainIdsURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altmainIdsURL, ""
        IniRead, altvipIdsURL, %A_ScriptDir%\..\..\Settings.ini, UserSettings, altvipIdsURL, ""
        DiscordWebhookURL := altDiscordWebhookURL
        DiscordUserId := altDiscordUserId 
        heartBeat := altheartBeat
        heartBeatName := altheartBeatName
        heartBeatWebhookURL := altheartBeatWebhookURL
        mainIdsURL := altmainIdsURL
        vipIdsURL := altvipIdsURL
    }

    ; Re-validate scaleParam based on current language
    
    ; Handle deprecated FriendID field
    if (inStr(FriendID, "http")) {
        MsgBox, To provide a URL for friend IDs, please use the ids.txt API field and leave the Friend ID field empty.
        
        if (mainIdsURL = "") {
            IniWrite, "", %A_ScriptDir%\..\..\Settings.ini, UserSettings, FriendID
            IniWrite, %A_ScriptDir%\..\..\Settings.ini, UserSettings, mainIdsURL
        }
        
        Reload
    }
    
    ; Download a new Main ID file prior to running the rest of the below
    if (mainIdsURL != "") {
        DownloadFile(mainIdsURL, "ids.txt")
    }
    
    ; Download showcase codes if enabled
    if (showcaseEnabled && showcaseURL != "") {
        DownloadFile(showcaseURL, "showcase_codes.txt")
    }
    
    ; Check for showcase_ids.txt if enabled
    if (showcaseEnabled) {
        if (!FileExist("showcase_ids.txt")) {
            MsgBox, 48, Showcase Warning, Showcase is enabled but showcase_ids.txt does not exist.`nPlease create this file in the same directory as the script.
        }
    }
    
    ; Create the second page dynamically based on the number of instances
    Gui, Destroy ; Close the first page
    
    ; Run main before instances to account for instance start delay
    if (runMain) {
        Loop, %Mains%
        {
            if (A_Index != 1) {
                SourceFile := "Scripts\Main.ahk" ; Path to the source .ahk file
                TargetFolder := "Scripts\" ; Path to the target folder
                TargetFile := TargetFolder . "Main" . A_Index . ".ahk" ; Generate target file path
                FileDelete, %TargetFile%
                FileCopy, %SourceFile%, %TargetFile%, 1 ; Copy source file to target
                if (ErrorLevel)
                    MsgBox, Failed to create %TargetFile%. Ensure permissions and paths are correct.
            }
            
            mainInstanceName := "Main" . (A_Index > 1 ? A_Index : "")
            FileName := "Scripts\" . mainInstanceName . ".ahk"
            Command := FileName
            
            if (A_Index > 1 && instanceStartDelay > 0) {
                instanceStartDelayMS := instanceStartDelay * 1000
                Sleep, instanceStartDelayMS
            }
            
            Run, %Command%
        }
    }
    
    ; Loop to process each instance
    Loop, %Instances%
    {
        if (A_Index != 1) {
            SourceFile := "Scripts\1.ahk" ; Path to the source .ahk file
            TargetFolder := "Scripts\" ; Path to the target folder
            TargetFile := TargetFolder . A_Index . ".ahk" ; Generate target file path
            if(Instances > 1) {
                FileDelete, %TargetFile%
                FileCopy, %SourceFile%, %TargetFile%, 1 ; Copy source file to target
            }
            if (ErrorLevel)
                MsgBox, Failed to create %TargetFile%. Ensure permissions and paths are correct.
        }
        
        FileName := "Scripts\" . A_Index . ".ahk"
        Command := FileName
        
        if ((Mains > 1 || A_Index > 1) && instanceStartDelay > 0) {
            instanceStartDelayMS := instanceStartDelay * 1000
            Sleep, instanceStartDelayMS
        }
        
        ; Clear out the last run time so that our monitor script doesn't try to kill and refresh this instance right away
        metricFile := A_ScriptDir . "\..\" . A_Index . ".ini"
        if (FileExist(metricFile)) {
            IniWrite, 0, %metricFile%, Metrics, LastEndEpoch
            ; IniWrite, 0, %metricFile%, UserSettings, DeadCheck
            IniWrite, 0, %metricFile%, Metrics, rerolls
            now := A_TickCount
            IniWrite, %now%, %metricFile%, Metrics, rerollStartTime
        }
        
        Run, %Command%
    }
    
    if(autoLaunchMonitor) {
        monitorFile := A_ScriptDir . "\" . "Monitor.ahk"
        if(FileExist(monitorFile)) {
            Run, %monitorFile%
        }
    }
    
    ; Update ScaleParam for use in displaying the status
    GuiControlGet, defaultLanguage,, defaultLanguage
    if (defaultLanguage = "Scale125")
        scaleParam := 277
    else
        scaleParam := 287
        
    SelectedMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
    SysGet, Monitor, Monitor, %SelectedMonitorIndex%
    rerollTime := A_TickCount

    typeMsg := "\nType: " . deleteMethod
    injectMethod := false
    if(InStr(deleteMethod, "Inject"))
        injectMethod := true
    if(packMethod)
        typeMsg .= " (1P Method)"
    if(nukeAccount && !injectMethod)
        typeMsg .= " (Menu Delete)"
    
    Selected := []
    selectMsg := "\nOpening: "
    if(Shining)
        Selected.Push("Shining")
    if(Arceus)
        Selected.Push("Arceus")
    if(Palkia)
        Selected.Push("Palkia")
    if(Dialga)
        Selected.Push("Dialga")
    if(Mew)
        Selected.Push("Mew")
    if(Pikachu)
        Selected.Push("Pikachu")
    if(Charizard)
        Selected.Push("Charizard")
    if(Mewtwo)
        Selected.Push("Mewtwo")
    if(Solgaleo)
        Selected.Push("Solgaleo")
    if(Lunala)
        Selected.Push("Lunala")
    if(Buzzwole)
        Selected.Push("Buzzwole")
    if(Eevee)
        Selected.Push("Eevee")
    if(HoOh)
        Selected.Push("HoOh")
    if(Lugia)
        Selected.Push("Lugia")
    if(Suicune)
        Selected.Push("Suicune")
    if(Deluxe)
        Selected.Push("Deluxe")
    if(MegaBlaziken)
        Selected.Push("MegaBlaziken")
    if(MegaGyarados)
        Selected.Push("MegaGyarados")
    if(MegaAltaria)
        Selected.Push("MegaAltaria")
    if(MegaCharizardY)
        Selected.Push("MegaCharizardY")
    
    for index, value in Selected {
        if(index = Selected.MaxIndex())
            commaSeparate := ","
        else
            commaSeparate := ", "
        if(value)
            selectMsg .= value . commaSeparate
        else
            selectMsg .= value . commaSeparate
    }
    detectionMsg := "\nDetection: minStars=" minStars ", minStarsShiny=" minStarsShiny
    if (openExtraPack) 
        detectionMsg .= ", openExtraPack"
    if (FullArtCheck) 
        detectionMsg .= ", FullArtCheck"
    if (TrainerCheck) 
        detectionMsg .= ", TrainerCheck"
    if (RainbowCheck) 
        detectionMsg .= ", RainbowCheck"
    if (PseudoGodPack) 
        detectionMsg .= ", PseudoGodPack"
    if (CheckShinyPackOnly) 
        detectionMsg .= ", CheckShinyPackOnly"
    if (ShinyCheck) 
        detectionMsg .= ", ShinyCheck"
    if (ImmersiveCheck) 
        detectionMsg .= ", ImmersiveCheck"
    if (CrownCheck) 
        detectionMsg .= ", CrownCheck"
    if (InvalidCheck) 
        detectionMsg .= ", InvalidCheck"


    settingsToRead := ["CheckFolder", "claimAnnivCountdown", "claimMail", "renameMode", "claimBonusWeek", "ChangeLNMode"]
    settingsValue := {} 

    Loop, % settingsToRead.Length()
    {
        settingName := settingsToRead[A_Index]
        IniRead, value, %A_ScriptDir%\..\..\Settings.ini, UserSettings, %settingName%, 0
        settingsValue[settingName] := value
        
    }


    othersMsg := "\nOthers: "
    firstItem := true

    for settingName, value in settingsValue
    {
        if (value != 0 && value != "")
        {
            if (!firstItem)
                othersMsg .= ", "
            othersMsg .= settingName
            firstItem := false
        }
    }

    if (firstItem) 
        othersMsg .= "None"

    
    ; === MAIN HEARTBEAT LOOP ===
    Loop {
        Sleep, 30000
        
        ; Check if Main toggled GP Test Mode and send notification if needed
        IniRead, mainTestMode, %A_ScriptDir%\..\..\HeartBeat.ini, TestMode, Main, -1
        if (mainTestMode != -1) {
            ; Main has toggled test mode, get status and send notification
            IniRead, mainStatus, %A_ScriptDir%\..\..\HeartBeat.ini, HeartBeat, Main, 0
            
            onlineAHK := ""
            offlineAHK := ""
            Online := []

            Loop %Instances% {
                IniRead, value, %A_ScriptDir%\..\..\HeartBeat.ini, HeartBeat, Instance%A_Index%
                if(value)
                    Online.Push(1)
                else
                    Online.Push(0)
                IniWrite, 0, %A_ScriptDir%\..\..\HeartBeat.ini, HeartBeat, Instance%A_Index%
            }
            
            for index, value in Online {
                if(index = Online.MaxIndex())
                    commaSeparate := ""
                else
                    commaSeparate := ", "
                if(value)
                    onlineAHK .= A_Index . commaSeparate
                else
                    offlineAHK .= A_Index . commaSeparate
            }
            
            if (runMain) {
                if(mainStatus) {
                    if (onlineAHK)
                        onlineAHK := "Main, " . onlineAHK
                    else
                        onlineAHK := "Main"
                }
                else {
                    if (offlineAHK)
                        offlineAHK := "Main, " . offlineAHK
                    else
                        offlineAHK := "Main"
                }
            }

            
            
            if(offlineAHK = "")
                offlineAHK := "Offline: none"
            else{
                offlineAHK := "Offline: " . RTrim(offlineAHK, ", ")
                IniRead, offlineReminder, %A_ScriptDir%\..\..\Settings.ini, UserSettings, offlineReminder, 1
                if(offlineReminder)
                    offlineAHK .= " <@" . discordUserId . ">"
            }
            if(onlineAHK = "")
                onlineAHK := "Online: none"
            else
                onlineAHK := "Online: " . RTrim(onlineAHK, ", ")
            
            ; Create status message with all regular heartbeat info
            discMessage := heartBeatName ? "\n" . heartBeatName : ""
            discMessage .= "\n" . onlineAHK . "\n" . offlineAHK
            
            total := SumVariablesInJsonFile()
            totalSeconds := Round((A_TickCount - rerollTime) / 1000)
            mminutes := Floor(totalSeconds / 60)
            packStatus := "Time: " . mminutes . "m | Packs: " . total
            packStatus .= " | Avg: " . Round(total / mminutes, 2) . " packs/min"
            
            discMessage .= "\n" . packStatus . "\nVersion: " . RegExReplace(githubUser, "-.*$") . "-" . localVersion
            discMessage .= typeMsg
            discMessage .= selectMsg
            discMessage .= othersMsg
            
            ; Add special note about Main's test mode status
            if (mainTestMode == "1")
                discMessage .= "\n\nMain entered GP Test Mode ✕"
            else
                discMessage .= "\n\nMain exited GP Test Mode ✓"
            
            ; Send the message
            LogToDiscord(discMessage,, false,,, heartBeatWebhookURL)
            
            ; Clear the flag
            IniDelete, %A_ScriptDir%\..\..\HeartBeat.ini, TestMode, Main
        }
        
        ; Every 5 minutes, pull down the main ID list and showcase list
        if(Mod(A_Index, 10) = 0) {
            if(mainIdsURL != "") {
                DownloadFile(mainIdsURL, "ids.txt")
            }
        }
        
        ; Sum all variable values and write to total.json
        total := SumVariablesInJsonFile()
        totalSeconds := Round((A_TickCount - rerollTime) / 1000) ; Total time in seconds
        mminutes := Floor(totalSeconds / 60)
        
        packStatus := "Time: " . mminutes . "m Packs: " . total
        packStatus .= " | Avg: " . Round(total / mminutes, 2) . " packs/min"
        
        ; Display pack status at the bottom of the first reroll instance
        DisplayPackStatus(packStatus, ((runMain ? Mains * (scaleParam-6) : 0) + 3), 625)
        
        ; FIXED HEARTBEAT CODE
        if(heartBeat) {
            ; Each loop iteration is 30 seconds (0.5 minutes)
            ; So for X minutes, we need X * 2 iterations
            heartbeatIterations := heartBeatDelay * 2
            
            ; Send heartbeat at start (A_Index = 1) or every heartbeatDelay minutes
            if (A_Index = 1 || Mod(A_Index, heartbeatIterations) = 0) {
                
                onlineAHK := ""
                offlineAHK := ""
                Online := []
                sumPPHFS := 0
                firstHB := (A_Index = 1)
                Loop %Instances% {
                    IniRead, value, %A_ScriptDir%\..\..\HeartBeat.ini, HeartBeat, Instance%A_Index%
                    if(value || firstHB)
                        Online.Push(1)
                    else
                        Online.Push(0)
                    IniWrite, 0, %A_ScriptDir%\..\..\HeartBeat.ini, HeartBeat, Instance%A_Index%
                    IniRead, pphfs, %A_ScriptDir%\..\..\HeartBeat.ini, PPHFS, Instance%A_Index%, 0
                    sumPPHFS += pphfs
                    IniWrite, 0, %A_ScriptDir%\..\..\HeartBeat.ini, PPHFS, Instance%A_Index%
                }
                avgPPHFS := (A_Index = 1) ? 0 : sumPPHFS / Instances
                pphfsMsg := "\nPPHFS: " . avgPPHFS
                
                for index, value in Online {
                    if(index = Online.MaxIndex())
                        commaSeparate := ""
                    else
                        commaSeparate := ", "
                    if(value)
                        onlineAHK .= A_Index . commaSeparate
                    else
                        offlineAHK .= A_Index . commaSeparate
                }
                
                if(runMain) {
                    IniRead, value, %A_ScriptDir%\..\..\HeartBeat.ini, HeartBeat, Main
                    if(value) {
                        if (onlineAHK)
                            onlineAHK := "Main, " . onlineAHK
                        else
                            onlineAHK := "Main"
                    }
                    else {
                        if (offlineAHK)
                            offlineAHK := "Main, " . offlineAHK
                        else
                            offlineAHK := "Main"
                    }
                    IniWrite, 0, %A_ScriptDir%\..\..\HeartBeat.ini, HeartBeat, Main
                }
                
                if(offlineAHK = "")
                    offlineAHK := "Offline: none"
                else{
                    offlineAHK := "Offline: " . RTrim(offlineAHK, ", ") 
                    IniRead, offlineReminder, %A_ScriptDir%\..\..\Settings.ini, UserSettings, offlineReminder, 1
                    if(offlineReminder)
                        offlineAHK .= " <@" . discordUserId . ">"
                }
                if(onlineAHK = "")
                    onlineAHK := "Online: none"
                else
                    onlineAHK := "Online: " . RTrim(onlineAHK, ", ")              
                  
                discMessage := heartBeatName ? "\n" . heartBeatName : ""
                
                discMessage .= "\n" . onlineAHK . "\n" . offlineAHK . "\n" . packStatus . "\nVersion: " . RegExReplace(githubUser, "-.*$") . "-" . localVersion
                discMessage .= typeMsg
                discMessage .= selectMsg
                discMessage .= pphfsMsg
                discMessage .= detectionMsg
                discMessage .= othersMsg
                
                LogToDiscord(discMessage,, false,,, heartBeatWebhookURL)
                
                ; Optional debug log
                if (debugMode) {
                    FileAppend, % A_Now . " - Heartbeat sent at iteration " . A_Index . "`n", %A_ScriptDir%\heartbeat_log.txt
                }
            }
        }
    }

Return

InitializeJsonFile() {
    global jsonFileName
    fileName := A_ScriptDir . "\..\..\json\Packs.json"
    FileCreateDir, %A_ScriptDir%\..\..\json
    
    if !FileExist(fileName) {
        FileAppend, [], %fileName%
        jsonFileName := fileName
    } else {
        jsonFileName := fileName
    }
}

SumVariablesInJsonFile() {
    global jsonFileName
    if (jsonFileName = "")
        return 0
    
    FileRead, jsonContent, %jsonFileName%
    if (jsonContent = "")
        return 0
    
    sum := 0
    jsonContent := StrReplace(jsonContent, "[", "")
    jsonContent := StrReplace(jsonContent, "]", "")
    Loop, Parse, jsonContent, {, }
    {
        if (RegExMatch(A_LoopField, """variable"":\s*(-?\d+)", match)) {
            sum += match1
        }
    }
    if(sum > 0) {
        rootDir := A_ScriptDir . "\..\.."
        totalFile := rootDir . "\json\total.json"
        totalContent := "{""total_sum"": " sum "}"
        FileDelete, %totalFile%
        FileAppend, %totalContent%, %totalFile%
    }
    return sum
}

DisplayPackStatus(Message, X := 0, Y := 625) {
    global SelectedMonitorIndex,  PacksText
    static GuiName := "PackStatusGUI"
    
    bgColor := "F0F5F9"
    textColor := "2E3440"
    
    try {
        ActualMonitorIndex := RegExReplace(SelectedMonitorIndex, ":.*$")
        SysGet, Monitor, Monitor, %ActualMonitorIndex%
        X := MonitorLeft + X
        Y := MonitorTop + 503 

        if (scaleParam = "" || scaleParam = 0) {
            GuiControlGet, defaultLanguage,, defaultLanguage
            if (defaultLanguage = "Scale125")
                scaleParam := 277
            else
                scaleParam := 287
        }

        Gui %GuiName%:+LastFoundExist
        if WinExist() {
            GuiControl, %GuiName%:, PacksText, %Message%
        }
        else {
            
            Gui, %GuiName%:New, +ToolWindow -Caption +LastFound -DPIScale 
            
            Gui, %GuiName%:Color, %bgColor%
            Gui, %GuiName%:Margin, 2, 2
            Gui, %GuiName%:Font, s8 c%textColor%
            Gui, %GuiName%:Add, Text, vPacksText c%textColor%, %Message%
            Gui, %GuiName%:Show, NoActivate x%X% y%Y%, %GuiName%
        }
    } catch e {

    }
}

DownloadFile(url, filename) {
    localPath = %A_ScriptDir%\..\..\%filename%
    URLDownloadToFile, %url%, %localPath%
}

ReadFile(filename, numbers := false) {
    FileRead, content, %A_ScriptDir%\..\..\%filename%.txt
    
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

ResetAccountLists() {
    ; Check if ResetLists.ahk exists before trying to run it
    resetListsPath := A_ScriptDir . "ResetLists.ahk"
    
    if (FileExist(resetListsPath)) {
        ; Run the ResetLists.ahk script without waiting
        Run, %resetListsPath%,, Hide UseErrorLevel
        
        ; Very short delay to ensure process starts
        Sleep, 50
        
        ; Log that we've delegated to the script
        LogToFile("Account lists reset via ResetLists.ahk. New lists will be generated on next injection.")
        
        ; Create a status message
        CreateStatusMessage("Account lists reset. New lists will use current method settings.",,,, false)
    } else {
        ; Log error if file doesn't exist
        LogToFile("ERROR: ResetLists.ahk not found at: " . resetListsPath)
        
        if (debugMode) {
            MsgBox, ResetLists.ahk not found at:`n%resetListsPath%
        }
    }
}

moveScreen:
    TargetWindowTitle := "Classic Mode"
    
    WinGetPos, x, y, w, h, % TargetWindowTitle
    
    Loop, 10 {
        t := 250 - A_Index * 25
        WinSet, Transparent, %t%, % TargetWindowTitle
        Sleep, 5
    }
    
    WinMove, % TargetWindowTitle, , x , 200
    
    Loop, 50 {
        t := 5 + A_Index * 5
        WinSet, Transparent, %t%, % TargetWindowTitle
        Sleep, 4
    }
return


LaunchAllMumu:
    SetTimer, moveScreen, -1
    GuiControlGet, Instances,, Instances
    GuiControlGet, folderPath,, folderPath
    GuiControlGet, Mains,, Mains
    GuiControlGet, instanceLaunchDelay,, instanceLaunchDelay
    IniRead, runMain, %A_ScriptDir%\..\..\Settings.ini, UserSettings, runMain
    
    ; Save settings before launching
    SaveAllSettings()
    
    if(StrLen(A_ScriptDir) > 200 || InStr(A_ScriptDir, " ")) {
        MsgBox, ERROR: The bot folder path is too long or contains spaces. Move it directly into your C:\ or D:\ drive folder.
        return
    }
    
    launchAllFile := A_ScriptDir . "\LaunchAllMumu.ahk"
    if(FileExist(launchAllFile)) {
        Run, %launchAllFile%
    }
return


#IfWinActive Classic Mode
F2::Gosub, ArrangeWindows
F3::Gosub, StartBot
#IfWinActive