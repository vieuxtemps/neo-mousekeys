global v := Options["MouseSpeedInitial"]
global slowToggle := false
global fastToggle := false
global lastEdge := A_TickCount
VarSetCapacity(point, 8)

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

    if (GetKeyState(Options["ModeJump"], "P")) {
      factor := Options["ModeSpeedJump"]
      slowToggle := false, fastToggle := false
    } else if (GetKeyState(Options["ModeFast"], "P")) {
      factor := Options["ModeSpeedFast"]
      slowToggle := false
    } else if (GetKeyState(Options["ModeSlow"], "P")) {
      factor := Options["ModeSpeedSlow"]
      fastToggle := false
    }

    if (slowToggle)
      factor := Options["ModeSpeedSlow"]
    else if (fastToggle)
      factor := Options["ModeSpeedFast"]

    if (Options["SystemLegacyMouseMoveMode"]) {
      MouseMove, % dx * v * factor, % dy * v * factor, 1, R
    } else {
      DllCall("GetCursorPos", "ptr", &point)
      curX := NumGet(point, 0, "int")
      curY := NumGet(point, 4, "int")
      newX := curX + dx * v * factor
      newY := curY + dy * v * factor
      DllCall("SetCursorPos", "int", newX, "int", newY)
      Sleep, 10
    }

    a := Options["MouseSpeedAcceleration"]
    max := Options["MouseSpeedMax"]
    if (v < max)
      v := Min(max, v * a)
  }
}