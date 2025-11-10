#NoEnv  ; 推薦在新腳本中使用
#SingleInstance Force
SetBatchLines, -1

; =================================================================
; 1. 設定與變數定義
; =================================================================

; 卡包清單 (格式: Option1|Option2|...)
PackList := "Random|Mewtwo|Charizard|Pikachu|Mew|Dialga|Palkia|Arceus|Shining|Solgaleo|Lunala|Buzzwole|Eevee|HoOh|Lugia|Suicune|Deluxe|MegaBlaziken|MegaGyarados|MegaAltaria"

; INI 檔案路徑：假設 settings.ini 在腳本目錄往上兩層
IniPath := A_ScriptDir . "\..\Settings.ini"

global Instances := 1 ; 實例數量的預設值
global indivPackMode := 0 ; 新增：獨立卡包模式開關 (0=關閉, 1=開啟)

; =================================================================
; 2. 載入設定
; =================================================================

LoadSettings()

; =================================================================
; 3. GUI 介面生成
; =================================================================

Gui, New, , 卡包選擇介面 (Pack Selector)
Gui, Font, S10, Segoe UI

; 頂部實例數量顯示
Gui, Add, Text, x10 y10, 當前讀取的實例數量: %Instances%

; 新增核取方塊 (vIndivPackMode) 作為總開關
; gTogglePackControls: 按下後執行控制禁用/啟用邏輯
; Checked%indivPackMode%: 根據讀取到的狀態設定初始值
Gui, Add, Checkbox, vIndivPackMode x10 y40 gTogglePackControls Checked%indivPackMode%, 啟用個別實例卡包選擇

yPos := 70 ; 第一個下拉式選單的起始 Y 座標 (往下移動以容納 Checkbox)

; 檢查初始狀態是否應禁用控制項
initialDisable := indivPackMode ? "" : " Disabled"

Loop, %Instances%
{
    ControlVariable := "packSelectIns" . A_Index
    
    ; 透過雙層引用取得 LoadSettings 函式中設定的全域變數值
    currentSelection := %ControlVariable% 
    
    if (currentSelection = "" || currentSelection = "ERROR")
        currentSelection := "Random"

    defaultChoice := 1 
    
    Gui, Add, Text, x10 y%yPos% w100, Instance %A_Index%:
    
    ; 新增下拉式選單 (加入 Disabled 條件)
    Gui, Add, DropDownList, % "vpackSelectIns" . A_Index . " x120 y" . (yPos) . " w180 Choose" . defaultChoice . initialDisable, %PackList%
    
    GuiControl, , % "packSelectIns" . A_Index, %currentSelection%

    yPos += 30
}

; 按鈕
yPos += 15

; 新增 Save 和 Clear 按鈕 (加入 Disabled 條件)
Gui, Add, Button, x10 y%yPos% w100 h30 gClearPackSelections%initialDisable% vClearButton, Clear (清除)
Gui, Add, Button, x200 y%yPos% w100 h30 gSavePackSelections%initialDisable% vSaveButton, Save (儲存)


; 修正 GUI 高度計算錯誤
NewHeight := yPos + 50 ; 先計算出最終高度
Gui, Show, w320 h%NewHeight%, Pack Selector ; 使用計算好的變數
return

; =================================================================
; 4. 函式與標籤定義
; =================================================================

LoadSettings() {
    global Instances, IniPath, indivPackMode ; 確保所有全域變數都已宣告
    
    ; 1. 載入 Instances 數量
    IniRead, Instances, %IniPath%, UserSettings, Instances, 1
    
    if not (Instances is integer) || (Instances < 1)
        Instances := 1
        
    ; NEW: 載入 indivPackMode 狀態，預設為 0 (關閉)
    IniRead, indivPackMode, %IniPath%, UserSettings, indivPackMode, 0

    ; 2. 載入每個實例現有的卡包選擇
    Loop, %Instances%
    {
        ControlVariable := "packSelectIns" . A_Index
        PackValue := "" 

        IniRead, PackValue, %IniPath%, UserSettings, %ControlVariable%, "Random" 
        
        ; 寫入全域動態變數
        %ControlVariable% := PackValue 
    }
}

TogglePackControls:
    ; 讀取核取方塊的當前狀態到 IndivPackMode 變數
    GuiControlGet, IndivPackMode, , IndivPackMode
    
    ; 根據狀態啟用或禁用所有相關控制項
    Action := IndivPackMode ? "Enable" : "Disable"
    
    ; 啟用/禁用下拉選單
    Loop, %Instances%
    {
        ControlVariable := "packSelectIns" . A_Index
        GuiControl, %Action%, %ControlVariable%
    }
    
    ; 啟用/禁用按鈕
    GuiControl, %Action%, SaveButton
    GuiControl, %Action%, ClearButton
    return

SavePackSelections:
    global Instances, IniPath, indivPackMode
    
    ; 將 GUI 上所有控制項的當前值寫入其對應的變數 (包括 IndivPackMode)
    Gui, Submit, NoHide 

    ; NEW: 儲存獨立卡包模式的狀態
    IniWrite, %indivPackMode%, %IniPath%, UserSettings, indivPackMode

    ; 只有當模式開啟時，才儲存每個實例的選擇
    if (indivPackMode)
    {
        Loop, %Instances%
        {
            ControlVariable := "packSelectIns" . A_Index
            IniWrite, % %ControlVariable%, %IniPath%, UserSettings, %ControlVariable%
        }
    }
    
    MsgBox, 64, 儲存成功, 卡包選擇已成功儲存到 Settings.ini!
    return

ClearPackSelections:
    global Instances, IniPath
    
    ; 只有當模式開啟時，才允許清除 (但 INI 寫入是為了確保一致性，所以可以保留)
    GuiControlGet, IndivPackMode, , IndivPackMode
    if (!IndivPackMode) {
        MsgBox, 48, 警告, 請先勾選「啟用個別實例卡包選擇」才能清除。
        return
    }

    Loop, %Instances%
    {
        ControlVariable := "packSelectIns" . A_Index
        
        ; 1. 重設 GUI 控制項的選項為 "Random"
        GuiControl, , %ControlVariable%, Random
        
        ; 2. 將 "Random" 寫入 INI 檔案
        IniWrite, Random, %IniPath%, UserSettings, %ControlVariable%
    }
    
    MsgBox, 64, 清除成功, 卡包選擇已清除並儲存為 'Random'!
    return

GuiClose:
    ExitApp
return