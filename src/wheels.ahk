CheckWheels:
  if (enabled) {
    for direction, _ in axisMap {
      if (GetKeyState(Options["Wheel" direction], "P")) {
        wheelFactor := 1
        if (GetKeyState(Options["WheelFast"], "P"))
          wheelFactor := Options["SpeedFastWheel"]
        Send, % "{Wheel" direction " " wheelFactor "}"
      }
    }
  }
return