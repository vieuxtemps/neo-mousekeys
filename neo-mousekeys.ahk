#Persistent
#SingleInstance Force
#MaxHotkeysPerInterval 300
#UseHook

;@Ahk2Exe-SetMainIcon icons\disabled.ico
;@Ahk2Exe-AddResource icons\enabled.ico, 206
;@Ahk2Exe-Obey U_Version, FileRead U_Version`, version
;@Ahk2Exe-SetFileVersion %U_Version%
;@Ahk2Exe-SetProductVersion Build v%U_Version% AutoHotkey v%A_AhkVersion%

Menu, Tray, Tip, Neo Mousekeys

#Include src/options.ahk
#Include src/init-wheels.ahk

OnExit, LabelExit

if (Options["SystemHideTrayIcon"])
  Menu, Tray, NoIcon
else if (not A_IsCompiled)
  Menu, Tray, Icon, icons\disabled.ico, , 1

CoordMode, Mouse, Screen
SetKeyDelay, -1
SetBatchLines, % Options["SystemCPUCycles"]
Thread, Interrupt, 0

global axisMap := { "Left": [-1, 0], "Down": [0, 1], "Up": [0, -1], "Right": [1, 0] }
global mouseMap := { "Left": "LButton", "Middle": "MButton", "Right": "RButton" }

#Include src/init-indicator.ahk
#Include src/hotkeys.ahk

SetTimer, DrawIndicator, 10
SetTimer, CheckEdges, 10
SetTimer, CheckWheels, 50

global v := Options["MouseSpeedInitial"]
global enabled := false

Loop {
  if (not enabled) {
    Sleep, 10
    continue
  }

  dx := 0
  dy := 0

  moveDisabled := GetKeyState("LCtrl", "P")
    or (Options["SystemIgnoreWinKey"] and (GetKeyState("LWin", "P") or GetKeyState("RWin", "P")))
    or (Options["EdgeEnabled"] and GetKeyState(Options["EdgeModifier"], "P"))

  if (not moveDisabled) {
    for direction, axis in axisMap {
      if (GetKeyState(Options["Movement" direction], "P")) {
        dx += axis[1]
        dy += axis[2]
      }
    }
  }

  if (dx == 0 and dy == 0) {
    v := Options["MouseSpeedInitial"]
  } else {
    factor := 1
    if (GetKeyState(Options["ModeFast"], "P"))
      factor := Options["ModeSpeedFast"]
    else if (GetKeyState(Options["ModeSlow"], "P"))
      factor := Options["ModeSpeedSlow"]
    else if (GetKeyState(Options["ModeJump"], "P"))
      factor := Options["ModeSpeedJump"]

    MouseMove, % dx * v * factor, % dy * v * factor, 1, R

    a := Options["MouseSpeedAcceleration"]
    max := Options["MouseSpeedMax"]
    if (v < max)
      v := Min(max, v * a)
  }
}

#Include src/draw-indicator.ahk
#Include src/wheels.ahk
#Include src/edges.ahk
#Include src/functions.ahk

LabelExit:
  ; Safety check: restores wheel speed (application
  ; could be closed while holding the modifier).
  SetWheelSpeed(originalScrollLines)
ExitApp
return