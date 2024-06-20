CheckWheels:
  if (enabled) {
    scrolled := false
    wheelFactor := 1

    ; WheelFast
    for _, key in wheelFastSplit {
      if (GetKeyState(key, "P")) {
        wheelFactor := Options["ModeSpeedWheelFast"]
        break
      }
    }

    ; Scroll
    for direction, _ in axisMap {
      if (GetKeyState(Options["Wheel" direction], "P")) {
        Send, % "{Wheel" direction " " wheelFactor "}"
        scrolled := true
      }
    }

    ; WheelSlow
    if (scrolled) {
      timeSinceLastScroll := lastScroll - A_TickCount
      lastScroll := A_TickCount

      wheelSlowPressed := GetKeyState(Options["ModeWheelSlow"], "P")

      ; Logic to avoid running DllCall constantly. Cursor will freeze
      ; or slow down otherwise. Only makes a call if any wheel was
      ; recently pressed, in a toggle fashion.
      if (wheelSlowPressed) {
        if (wheelSlow == 0) {
          wheelSlow := 1
          if (timeSinceLastScroll < 150)
            SetWheelSpeed(slowScrollLines)
        }
      } else {
        if (wheelSlow == 1) {
          wheelSlow := 0
          if (timeSinceLastScroll < 150)
            SetWheelSpeed(originalScrollLines)
        }
      }
    }
  }
return