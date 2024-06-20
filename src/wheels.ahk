CheckWheels:
  if (enabled) {
    wheelFactor := 1
    if (GetKeyState(Options["ModeWheelFast"], "P"))
      wheelFactor := Options["ModeSpeedWheelFast"]

    for direction, _ in axisMap {
      if (GetKeyState(Options["Wheel" direction], "P"))
        Send, % "{Wheel" direction " " wheelFactor "}"
    }
  }
return