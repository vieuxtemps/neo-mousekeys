CheckWheels:
  if (enabled) {
    wheelFactor := 1

    for _, key in wheelSplit {
      if (GetKeyState(key, "P")) {
        wheelFactor := Options["ModeSpeedWheelFast"]
        break
      }
    }

    for direction, _ in axisMap {
      if (GetKeyState(Options["Wheel" direction], "P"))
        Send, % "{Wheel" direction " " wheelFactor "}"
    }
  }
return