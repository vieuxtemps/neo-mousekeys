global wheelFastSplit := StrSplit(Options["ModeWheelFast"], A_Space, A_Space)
global wheelSlowSplit := StrSplit(Options["ModeWheelSlow"], A_Space, A_Space)

; https://learn.microsoft.com/en-us/windows/win32/inputdev/wm-mousewheel
global WM_MOUSEWHEEL := 0x20A
global WM_MOUSEHWHEEL := 0x20E

global wFAST := Options["ModeSpeedWheelFast"]
global wSLOW := Options["ModeSpeedWheelSlow"]
global wNORMAL := Options["ModeSpeedWheelNormal"]

global releaseShift := Options["ModeWheelSlow"] = "LShift" ? Options["ModeWheelSlow"] : ""

global ignoreControlList := "Intermediate D3D Window1" ; Comma-separated

WheelScroll(velocity, direction) {
  velocity := (direction == "Left" or direction == "Down") ? -velocity : velocity
  op := (direction == "Up" or direction == "Down") ? WM_MOUSEWHEEL : WM_MOUSEHWHEEL

  MouseGetPos, mX, mY, varId, varControl

  ; TODO: make it work without this. (Fallback for Chromium/Electron). Possibly related:
  ; https://bugs.chromium.org/p/chromium/issues/detail?id=587535
  ; https://github.com/electron/electron/issues/10547#issuecomment-344746570
  if varControl in %ignoreControlList%
    varControl := ""

  ; TODO: Make LShift work as a 'WheelSlow' key without doing this (doesn't work
  ; if hovering a window that is not focused). Additionally checking for physical
  ; state has a chance of breaking it. This issue appears in programs that
  ; interpret LShift + VerticalWheel as HorizontalWheel.
  if (releaseShift)
    Send, {LShift up}

  SendMessage, op, velocity << 16, mY << 16 | mX, %varControl%, ahk_id %varId%
}
