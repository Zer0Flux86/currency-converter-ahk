#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global DefMode := "UAH-RUB"
global GuiVis := True
global AutoClip := True


grivna := "uah"     ; Ukrainian Hryvnia
euro := "eur"       ; Euro
rub := "rub"        ; Russian Ruble
dollar := "usd"     ; US Dollar
belrub := "byr"     ; Belarusian Ruble
chinauan := "cny"   ; Chinese Yuan
pound := "gbp"      ; British Pound
yen := "jpy"        ; Japanese Yen
franc := "chf"      ; Swiss Franc
zloty := "pln"      ; Polish Złoty
crown := "czk"      ; Czech Crown
lira := "try"       ; Turkish Lira
won := "krw"        ; South Korean Won
rupee := "inr"      ; Indian Rupee

; GUI Creation
Gui, Font, s12, Segoe UI
Gui, Add, Text, x8 y8 w100 h20, Dormant1337
Gui, Add, Text, x300 y8 w100 h20 gGitHub, Github link
Gui, Font, s9, Segoe UI
Gui, Add, Hotkey, x8 y40 w120 h21 vHotkey
Gui, Color, 0x7a7a7a
Gui, Add, Button, x136 y40 w82 h23 gSet, Set Bind
Gui, Add, GroupBox, x16 y72 w120 h80, Translate Settings
Gui, Add, CheckBox, x18 y88 w80 h23 vAutoClip Checked, Auto Clip
Gui, Add, ComboBox, x48 y184 w120 vFrom, uah||eur||rub||usd||byr||cny||gbp||jpy||chf||pln||czk||try||krw||inr
Gui, Add, Text, x8 y184 w33 h23 +0x200, From:
Gui, Add, ComboBox, x208 y184 w120 vTo, uah||eur||rub||usd||byr||cny||gbp||jpy||chf||pln||czk||try||krw||inr
Gui, Add, Text, x184 y184 w21 h23 +0x200, To:
Gui, Add, Button, x152 y216 w80 h23 gApply, Apply

Gui, Show, w350 h250, Currency Converter
Return

Set:
Gui, Submit, NoHide
if (Hotkey) {  
    Hotkey, %Hotkey%, Main
    MsgBox, Hotkey set to %Hotkey%
}
return

Apply:
Gui, Submit, NoHide
global DefMode := From . "-" . To
MsgBox, Mode set to %DefMode%
return

GitHub:
Run, https://github.com/yourusername/yourrepo  
return

!Insert::  
if (GuiVis) {
    Gui, Hide 
    GuiVis := False
} else {
    Gui, Show 
    GuiVis := True
}
return

GetRate() {
    url := "https://www.google.com/finance/quote/" . DefMode
    try {
        whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open("GET", url, true)
        whr.Send()
        whr.WaitForResponse()
        html := whr.ResponseText
        
        RegExMatch(html, "data-last-price=""([\d\.]+)""", match)
        if (match1) {
            return Round(match1, 2)
        }
        MsgBox, Failed to get exchange rate. Please check your internet connection.
        return 0
    } catch e {
        MsgBox, Error accessing exchange rate: %e%
        return 0
    }
}

Main() {
    oldClipboard := ClipboardAll  
    Clipboard := "" 
    Send, ^c 
    ClipWait, 1  
    if ErrorLevel {
        ToolTip, Failed to copy text
        SetTimer, RemoveToolTip, -1500
        return
    }
    
    if Clipboard is number
    {
        course := GetRate()
        if (course > 0) {
            result := Round(course * Clipboard, 2)
            if (AutoClip) {
                Clipboard := result
            } else {
                MsgBox, %result%
            }
        }
    } else {
        ToolTip, Not a number
        SetTimer, RemoveToolTip, -1500
    }
    
    if (!AutoClip) {
        Clipboard := oldClipboard 
    }
}

RemoveToolTip:
ToolTip
return

