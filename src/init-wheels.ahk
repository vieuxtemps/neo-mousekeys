global SCROLLING := false
global WHEELTIME := 20

global wheelFastSplit := StrSplit(Options["ModeWheelFast"], A_Space, A_Space)
global wheelSlowSplit := StrSplit(Options["ModeWheelSlow"], A_Space, A_Space)

global wFAST := Options["ModeSpeedWheelFast"] * WHEELTIME / 10
global wSLOW := Options["ModeSpeedWheelSlow"] * WHEELTIME / 10
global wNORMAL := Options["ModeSpeedWheelNormal"] * WHEELTIME / 10
global wheelStatus := { "Left": 0, "Down": 0, "Up": 0, "Right": 0 }

global releaseShift := InStr(Options["ModeWheelSlow"], "Shift", 0) ? true : false

global wheelActivationKeys := { "Left": [], "Down": [], "Up": [], "Right": [] }
for direction, _ in axisMap {
  wheelActivationKeys[direction] := StrSplit(Options["Wheel" direction], A_Space, A_Space)
}

; https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mouse_event
global MOUSEEVENTF_WHEEL := 0x0800
global MOUSEEVENTF_HWHEEL := 0x01000

WheelScroll(velocity, direction) {
  velocity := (direction == "Left" or direction == "Down") ? -velocity : velocity
  op := (direction == "Up" or direction == "Down") ? MOUSEEVENTF_WHEEL : MOUSEEVENTF_HWHEEL
  if (releaseShift)
    Send, {Blind}{LShift up}{RShift up}

  DllCall("mouse_event", "UInt", op, "UInt", 0, "UInt", 0, "UInt", velocity, "UInt", 0)
  lastCursorActivity := A_TickCount
}
