#Persistent
#SingleInstance Force
#MaxHotkeysPerInterval 300
#UseHook
SetKeyDelay, -1
SetBatchLines, 500
Thread, Interrupt, 0
SetTimer, DrawIndicator, 10
SetTimer, CheckWheels, 50

global wheelFactor := 1

opacity := 255
CoordMode, Mouse, Screen
MouseGetPos, mX, mY
Gui, +ToolWindow +LastFound +AlwaysOnTop -Caption
Gui, Color, 000000
Gui, Font, s12 c00cf6e w700 q5, Verdana
Gui, Add, Text, Center w12, ⬤
WinSet, ExStyle, +0x20
WinSet, TransColor, 000000 %opacity%

global mConfig := { "a": [-1, 0], "s": [0, 1], "w": [0, -1], "d": [1, 0] }
global wheelMap := { "m": "Down", ",": "Up", "i": "Left", "o": "Right" }

global v0 := 5
global a := 1.11
global max := 22

global v := v0
global enabled := false

Loop {
  if (not enabled)
    continue

  dx := 0
  dy := 0
  factor := GetKeyState("j", "P") ? 4 : 1
  factor := GetKeyState("h", "P") ? 0.2 : factor
  wheelFactor := GetKeyState("b", "P") ? 5 : 1

  for key, data in mConfig {
    mod := GetKeyState("Ctrl", "P") or GetKeyState("Shift", "P")
    if (GetKeyState(key, "P") and not mod) {
      dx += data[1]
      dy += data[2]
    }
  }

  if (dx == 0 and dy == 0) {
    v := v0
  } else {
    MouseMove, % dx * v * factor, % dy * v * factor, 1, R
    if (v < max)
      v := Min(max, v * a)
  }
}

DrawIndicator:
  if (enabled) {
    MouseGetPos, mX, mY
    Gui, Show, % "X" (mX + 5) " Y" (mY + 10) " NA"
  }
return

CheckWheels:
  if (enabled) {
    for key, value in wheelMap {
      if (GetKeyState(key, "P"))
        Send, % "{Wheel" value " " wheelFactor "}"
    }
  }
return

^e::
  enabled := true
return

#If enabled
  Capslock::
    enabled := false
    Gui, Show, Hide
  return

  w::
  a::
  s::
  d::

  j::
  h::

  m::
  ,::
  i::
  o::

  b::
  return

  k::Click, down Left
  l::Click, down Right
  `;::Click, down Middle

  k up::Click, up Left
  l up::Click, up Right
  `; up::Click, up Middle
#If
