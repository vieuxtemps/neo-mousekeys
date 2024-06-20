#Persistent
#SingleInstance Force
#MaxHotkeysPerInterval 300
#UseHook

SetKeyDelay, -1
SetBatchLines, 500
Thread, Interrupt, 0
CoordMode, Mouse, Screen

#Include src/options.ahk
#Include src/init-indicator.ahk
#Include src/hotkeys.ahk

SetTimer, DrawIndicator, 10
SetTimer, CheckWheels, 50

global axisMap := { "Left": [-1, 0], "Down": [0, 1], "Up": [0, -1], "Right": [1, 0] }
global v := Options["SpeedInitialSpeed"]
global enabled := false

Loop {
  if (not enabled)
    continue

  dx := 0
  dy := 0

  factor := 1
  if (GetKeyState(Options["ModeFast"], "P"))
    factor := 1.5
  else if (GetKeyState(Options["ModeSlow"], "P"))
    factor := 0.2
  else if (GetKeyState(Options["ModeJump"], "P"))
    factor := 4

  for direction, axis in axisMap {
    mod := GetKeyState("Ctrl", "P") or GetKeyState("Shift", "P")
    if (not mod and GetKeyState(Options["Movement" direction], "P")) {
      dx += axis[1]
      dy += axis[2]
    }
  }

  if (dx == 0 and dy == 0) {
    v := Options["SpeedInitialSpeed"]
  } else {
    a := Options["SpeedAcceleration"]
    max := Options["SpeedMaxSpeed"]
    MouseMove, % dx * v * factor, % dy * v * factor, 1, R
    if (v < max)
      v := Min(max, v * a)
  }
}

#Include src/draw-indicator.ahk
#Include src/wheels.ahk
#Include src/labels.ahk
