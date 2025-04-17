#Persistent
#SingleInstance Force
#MaxHotkeysPerInterval 1000
#MaxThreads 255
#MaxThreadsPerHotkey 50
#MaxThreadsBuffer On
#UseHook

;@Ahk2Exe-SetMainIcon icons\disabled.ico
;@Ahk2Exe-AddResource icons\enabled.ico, 206
;@Ahk2Exe-Obey U_Version, FileRead U_Version`, version
;@Ahk2Exe-SetFileVersion %U_Version%
;@Ahk2Exe-SetProductVersion Build v%U_Version% AutoHotkey v%A_AhkVersion%

#Include src/options.ahk

SetBatchLines, % Options["SystemCPUCycles"]
Process, Priority,, % Options["SystemProcessPriority"]
CoordMode, Mouse, Screen

Menu, Tray, Tip, Neo Mousekeys
OnExit, ExitSub

if (Options["SystemHideTrayIcon"])
  Menu, Tray, NoIcon
else if (not A_IsCompiled)
  Menu, Tray, Icon, icons\disabled.ico, , 1

#Include src/monitors.ahk

global enabled := false
global cursor := true
global CURSOR_TIMEOUT := Options["CursorHideCursorAfterSeconds"] * 1000
global IDLE_TIMEOUT := Options["CursorIdleTimeout"] * 1000
global lastCursorActivity := A_TickCount
global axisMap := { "Left": [-1, 0], "Down": [0, 1], "Up": [0, -1], "Right": [1, 0] }
global mouseMap := { "Left": "LButton", "Middle": "MButton", "Right": "RButton" }

#Include src/init-wheels.ahk
#Include src/hotkeys.ahk

SetTimer, CheckEdges, 50
SetTimer, CheckWheels, % WHEELTIME

if (Options["CursorHideCursorAfterSeconds"] or Options["CursorIdleTimeout"])
  SetTimer, CheckMouseActivity, 50

#Include src/main.ahk
#Include src/wheels.ahk
#Include src/edges.ahk
#Include src/functions.ahk
#Include src/mouse-activity.ahk
#Include src/mouse-cursor.ahk

; Use for your own personal keybindings. Ignored if it doesn't exist, ignored by .gitignore
#Include *i src/custom.ahk

ExitSub:
  ; Reset default cursor scheme
  DllCall("SystemParametersInfo", "uint", 0x57, "uint", 0, "uint", 0, "uint", 0)
ExitApp
return