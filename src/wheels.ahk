CheckWheels:
  if (SCROLLING or not enabled)
    return

  for direction, _ in axisMap {
    wheelStatus[direction] := 0

    for _, key in wheelActivationKeys[direction] {
      wheelStatus[direction] := wheelStatus[direction] or GetKeyState(key, "P")
    }
  }

  if ((wheelStatus["Up"] and wheelStatus["Down"]) or (wheelStatus["Left"] and wheelStatus["Right"]))
    return

  SCROLLING := true
  modifiersPressed := GetKeyState("Ctrl", "P") or GetKeyState("LWin", "P") or GetKeyState("RWin", "P") or GetKeyState("Alt", "P")

  if (not modifiersPressed) {
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
