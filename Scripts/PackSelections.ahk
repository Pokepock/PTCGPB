#NoEnv ; Recommended for new scripts
#SingleInstance Force
SetBatchLines, -1

; =================================================================
; 1. Settings and Variable Definitions
; =================================================================

; Card Pack List (Format: Option1|Option2|...)
PackList := "Random|Mewtwo|Charizard|Pikachu|Mew|Dialga|Palkia|Arceus|Shining|Solgaleo|Lunala|Buzzwole|Eevee|HoOh|Lugia|Suicune|Deluxe|MegaBlaziken|MegaGyarados|MegaAltaria|MegaCharizardY"

; INI File Path: Assumes settings.ini is two directories up from the script directory
IniPath := A_ScriptDir . "\..\Settings.ini"

global Instances := 1 ; Default value for the number of instances
global indivPackMode := 0 ; NEW: Individual Pack Mode switch (0=Off, 1=On)

; =================================================================
; 2. Load Settings
; =================================================================

LoadSettings()

; =================================================================
; 3. GUI Interface Generation
; =================================================================

Gui, New, , Pack Selector Interface
Gui, Font, S10, Segoe UI

; Top: Display the current number of instances read from INI
Gui, Add, Text, x10 y10, Currently loaded instances: %Instances%

; Add Checkbox (vIndivPackMode) as the main toggle switch
; gTogglePackControls: Label to execute control enable/disable logic
; Checked%indivPackMode%: Sets the initial state based on the loaded status
Gui, Add, Checkbox, vIndivPackMode x10 y40 gTogglePackControls Checked%indivPackMode%, Enable Individual Pack Selection

yPos := 70 ; Starting Y coordinate for the first dropdown (moved down to accommodate the Checkbox)

; Check if controls should be initially disabled based on the loaded state
initialDisable := indivPackMode ? "" : " Disabled"

Loop, %Instances%
{
    ControlVariable := "packSelectIns" . A_Index
    
    ; Retrieve the value of the global dynamic variable set in LoadSettings
    currentSelection := %ControlVariable% 
    
    if (currentSelection = "" || currentSelection = "ERROR")
        currentSelection := "Random"

    defaultChoice := 1 
    
    ; Instance Label
    Gui, Add, Text, x10 y%yPos% w100, Instance %A_Index%:
    
    ; Add Dropdown List (vpackSelectInsX, includes Disabled condition)
    Gui, Add, DropDownList, % "vpackSelectIns" . A_Index . " x120 y" . (yPos) . " w180 Choose" . defaultChoice . initialDisable, %PackList%
    
    ; Set the dropdown's current value based on the loaded selection
    GuiControl, , % "packSelectIns" . A_Index, %currentSelection%

    yPos += 30 ; Move down for the next control
}

; Add padding before buttons
yPos += 15

; Add Save and Clear Buttons (includes Disabled condition)
Gui, Add, Button, x10 y%yPos% w100 h30 gClearPackSelections%initialDisable% vClearButton, Clear
Gui, Add, Button, x200 y%yPos% w100 h30 gSavePackSelections%initialDisable% vSaveButton, Save


; Calculate and show the final GUI window
NewHeight := yPos + 50 ; Calculate the final height
Gui, Show, w320 h%NewHeight%, Pack Selector
return

; =================================================================
; 4. Functions and Labels
; =================================================================

LoadSettings() {
    global Instances, IniPath, indivPackMode ; Ensure all global variables are declared
    
    ; 1. Load Instances count
    IniRead, Instances, %IniPath%, UserSettings, Instances, 1
    
    if not (Instances is integer) || (Instances < 1)
        Instances := 1
        
    ; NEW: Load indivPackMode state, default to 0 (Off)
    IniRead, indivPackMode, %IniPath%, UserSettings, indivPackMode, 0

    ; 2. Load the existing pack selection for each instance
    Loop, %Instances%
    {
        ControlVariable := "packSelectIns" . A_Index
        PackValue := "" 

        IniRead, PackValue, %IniPath%, UserSettings, %ControlVariable%, "Random" 
        
        ; Write the value to the global dynamic variable (e.g., packSelectIns1)
        %ControlVariable% := PackValue 
    }
}

TogglePackControls:
    ; Read the current state of the checkbox into the IndivPackMode variable
    GuiControlGet, IndivPackMode, , IndivPackMode
    
    ; Determine action: Enable if checked (1), Disable if unchecked (0)
    Action := IndivPackMode ? "Enable" : "Disable"
    
    ; Enable/Disable Dropdown Lists
    Loop, %Instances%
    {
        ControlVariable := "packSelectIns" . A_Index
        GuiControl, %Action%, %ControlVariable%
    }
    
    ; Enable/Disable Buttons
    GuiControl, %Action%, SaveButton
    GuiControl, %Action%, ClearButton
    return

SavePackSelections:
    global Instances, IniPath, indivPackMode
    
    ; Store the current values of all controls (including IndivPackMode) into their corresponding variables
    Gui, Submit, NoHide 

    ; NEW: Save the state of the individual pack mode
    IniWrite, %indivPackMode%, %IniPath%, UserSettings, indivPackMode

    ; Only save individual selections if the mode is enabled
    if (indivPackMode)
    {
        Loop, %Instances%
        {
            ControlVariable := "packSelectIns" . A_Index
            ; Write the variable's content (e.g., Random, Charizard) to the INI file
            IniWrite, % %ControlVariable%, %IniPath%, UserSettings, %ControlVariable%
        }
    }
    
    MsgBox, 64, Save Successful, Pack selections have been successfully saved to Settings.ini!
    return

ClearPackSelections:
    global Instances, IniPath
    
    ; Check if the mode is enabled before clearing
    GuiControlGet, IndivPackMode, , IndivPackMode
    if (!IndivPackMode) {
        MsgBox, 48, Warning, Please check 'Enable Individual Pack Selection' before clearing.
        return
    }

    Loop, %Instances%
    {
        ControlVariable := "packSelectIns" . A_Index
        
        ; 1. Reset the GUI control selection to "Random"
        GuiControl, , %ControlVariable%, Random
        
        ; 2. Write "Random" to the INI file
        IniWrite, Random, %IniPath%, UserSettings, %ControlVariable%
    }
    
    MsgBox, 64, Clear Successful, Pack selections have been cleared and saved as 'Random'!
    return

GuiClose:
    ExitApp
return