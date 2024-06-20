CheckWheels:
  if (not enabled)
    return

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
        break
      }
    }
  }

  for direction, _ in axisMap {
    if (GetKeyState(Options["Wheel" direction], "P"))
      WheelScroll(velocity, direction)
  }
return