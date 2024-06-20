CheckWheels:
  if (SCROLLING or not enabled)
    return

  for direction, _ in axisMap
    wheelStatus[direction] := GetKeyState(Options["Wheel" direction], "P")

  if ((wheelStatus["Up"] and wheelStatus["Down"]) or (wheelStatus["Left"] and wheelStatus["Right"]))
    return

  SCROLLING := true
  winPressed := GetKeyState("LWin", "P") or GetKeyState("RWin", "P")

  if (not (Options["SystemIgnoreWinKey"] and winPressed)) {
    for direction, _ in axisMap {
      if (wheelStatus[direction]) {
        velocity := wNORMAL

        for _, key in wheelSlowSplit {
          if (GetKeyState(key, "P")) {
            velocity := wSLOW
            break
          }
        }

        if (velocity == wNORMAL) {
          for _, key in wheelFastSplit {
            if (GetKeyState(key, "P")) {
              velocity := wFAST
              slowToggle := false
              break
            }
          }
        }

        if (slowToggle)
          velocity := wSLOW

        Send, % "{Blind}{" Options["Wheel" direction] " up}"
        WheelScroll(velocity, direction)
        break
      }
    }
  }

  SCROLLING := false
return
