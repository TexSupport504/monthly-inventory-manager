; Test script to verify middle mouse button detection
; This will show a tooltip when middle button is pressed

#NoEnv
#SingleInstance Force
#Persistent

; Set title matching mode
SetTitleMatchMode, 2

; Test middle mouse button detection
~MButton::
    WinGetActiveTitle, ActiveWindow
    ToolTip, Middle button pressed! Active window: %ActiveWindow%, 100, 100
    SetTimer, RemoveToolTip, 2000
    
    ; If VS Code is active, also send the hotkey
    if (InStr(ActiveWindow, "Visual Studio Code")) {
        Send, ^i
        ToolTip, VS Code detected - sending Ctrl+I, 100, 150
        SetTimer, RemoveToolTip2, 3000
    }
return

RemoveToolTip:
    ToolTip
    SetTimer, RemoveToolTip, Off
return

RemoveToolTip2:
    ToolTip, , , 150
    SetTimer, RemoveToolTip2, Off
return

; Ctrl+Alt+Q to exit
^!q::ExitApp
