#Persistent
#SingleInstance Force
#MaxHotkeysPerInterval 300
#UseHook

#Include src/options.ahk

CoordMode, Mouse, Screen
SetKeyDelay, -1
SetBatchLines, % Options["SystemCPUCycles"]
Thread, Interrupt, 0

global axisMap := { "Left": [-1, 0], "Down": [0, 1], "Up": [0, -1], "Right": [1, 0] }
global mouseMap := { "Left": "LButton", "Middle": "MButton", "Right": "RButton" }

#Include src/init-indicator.ahk
#Include src/hotkeys.ahk

SetTimer, DrawIndicator, 10
SetTimer, CheckWheels, 50
SetTimer, CheckEdges, 50

global v := Options["MouseSpeedInitial"]
global enabled := false

Loop {
  if (not enabled) {
    Sleep, 10
    continue
  }


  dx := 0
  dy := 0

  factor := 1
  if (GetKeyState(Options["ModeFast"], "P"))
    factor := Options["ModeSpeedFast"]
  else if (GetKeyState(Options["ModeSlow"], "P"))
    factor := Options["ModeSpeedSlow"]
  else if (GetKeyState(Options["ModeJump"], "P"))
    factor := Options["ModeSpeedJump"]

  for direction, axis in axisMap {
    mod := GetKeyState("Ctrl", "P")
      or (Options["SystemIgnoreWinKey"] and (GetKeyState("LWin", "P") or GetKeyState("RWin", "P")))

    if (not mod and GetKeyState(Options["Movement" direction], "P")) {
      dx += axis[1]
      dy += axis[2]
    }
  }

  if (dx == 0 and dy == 0) {
    v := Options["MouseSpeedInitial"]
  } else {
    a := Options["MouseSpeedAcceleration"]
    max := Options["MouseSpeedMax"]
    MouseMove, % dx * v * factor, % dy * v * factor, 1, R
    if (v < max)
      v := Min(max, v * a)
  }
}

#Include src/draw-indicator.ahk
#Include src/wheels.ahk
#Include src/edges.ahk
#Include src/functions.ahk
