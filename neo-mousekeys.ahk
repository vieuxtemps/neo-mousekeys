#Persistent
#SingleInstance Force
#MaxHotkeysPerInterval 300
#MaxThreads 255
#MaxThreadsPerHotkey 5
#MaxThreadsBuffer On
#UseHook

;@Ahk2Exe-SetMainIcon icons\disabled.ico
;@Ahk2Exe-AddResource icons\enabled.ico, 206
;@Ahk2Exe-Obey U_Version, FileRead U_Version`, version
;@Ahk2Exe-SetFileVersion %U_Version%
;@Ahk2Exe-SetProductVersion Build v%U_Version% AutoHotkey v%A_AhkVersion%

Menu, Tray, Tip, Neo Mousekeys
OnExit, ExitSub

#Include src/monitors.ahk
#Include src/options.ahk
global SCROLLING := false
global WHEELTIME := 20
#Include src/init-wheels.ahk

global CURSOR_TIMEOUT := Options["CursorHideCursorAfterSeconds"] * 1000
global IDLE_TIMEOUT := Options["CursorIdleTimeout"] * 1000
global lastCursorActivity := A_TickCount
global cursor := true

if (Options["SystemHideTrayIcon"])
  Menu, Tray, NoIcon
else if (not A_IsCompiled)
  Menu, Tray, Icon, icons\disabled.ico, , 1

CoordMode, Mouse, Screen
SetKeyDelay, -1
SetBatchLines, % Options["SystemCPUCycles"]
Process, Priority,, % Options["SystemProcessPriority"]

global axisMap := { "Left": [-1, 0], "Down": [0, 1], "Up": [0, -1], "Right": [1, 0] }
global mouseMap := { "Left": "LButton", "Middle": "MButton", "Right": "RButton" }
global enabled := false

#Include src/init-indicator.ahk
#Include src/hotkeys.ahk

SetTimer, DrawIndicator, 10
SetTimer, CheckEdges, 10
SetTimer, CheckWheels, % WHEELTIME

if (Options["CursorHideCursorAfterSeconds"] or Options["CursorIdleTimeout"])
  SetTimer, CheckMouseActivity, 50

#Include src/main.ahk
#Include src/draw-indicator.ahk
#Include src/wheels.ahk
#Include src/edges.ahk
#Include src/functions.ahk
#Include src/hide-cursor.ahk

; Use for your own personal keybindings. Ignored if it doesn't exist, ignored by .gitignore
#Include *i src/custom.ahk

ExitSub:
  if (Options["CursorHideCursorAfterSeconds"])
    SystemCursor(1)
ExitApp
return