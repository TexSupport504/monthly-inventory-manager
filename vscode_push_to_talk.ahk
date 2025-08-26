; VS Code Push-to-Talk with Middle Mouse Button
; Hold middle mouse button to activate voice chat in VS Code

#NoEnv
#SingleInstance Force
#Persistent

; Only activate when VS Code is the active window
SetTitleMatchMode, 2

; Press middle mouse button to start voice input
~MButton::
WinGetActiveTitle, ActiveWindow
if (InStr(ActiveWindow, "Visual Studio Code")) {
    ; Send Ctrl+I to start voice input
    Send, ^i
}
return

; Release middle mouse button to stop voice input
~MButton Up::
WinGetActiveTitle, ActiveWindow
if (InStr(ActiveWindow, "Visual Studio Code")) {
    ; Send Ctrl+I to stop voice input
    Send, ^i
}
return

; Ctrl+Alt+Q to exit this script
^!q::ExitApp
