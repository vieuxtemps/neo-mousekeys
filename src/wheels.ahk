CheckWheels:
  if (enabled) {
    for direction, _ in axisMap {
      if (GetKeyState(Options["Wheel" direction], "P")) {
        wheelFactor := 1
        if (GetKeyState(Options["ModeWheelFast"], "P"))
          wheelFactor := Options["ModeSpeedWheelFast"]
        Send, % "{Wheel" direction " " wheelFactor "}"
      }
    }
  }
return