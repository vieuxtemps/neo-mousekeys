global v := Options["MouseSpeedInitial"]
global slowToggle := false

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
      slowToggle := false
    } else if (GetKeyState(Options["ModeFast"], "P")) {
      factor := Options["ModeSpeedFast"]
      slowToggle := false
    } else if (GetKeyState(Options["ModeSlow"], "P")) {
      factor := Options["ModeSpeedSlow"]
    }

    if (slowToggle)
      factor := Options["ModeSpeedSlow"]

    MouseMove, % dx * v * factor, % dy * v * factor, 1, R

    a := Options["MouseSpeedAcceleration"]
    max := Options["MouseSpeedMax"]
    if (v < max)
      v := Min(max, v * a)
  }
}