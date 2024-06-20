CheckEdges:
  if (enabled) {
    if (Options["EdgeEnabled"] and GetKeyState(Options["EdgeModifier"], "P")) {
      UpdateMonitors()

      for direction, _ in axisMap {
        if (GetKeyState(Options["Movement" direction], "P")) {
          offsetX := Monitor_Right * Options["EdgeOffsetX"]
          offsetY := Monitor_Bottom * Options["EdgeOffsetY"]

          eX := direction == "Right" ? Monitor_Right - offsetX : 0
          eX := direction == "Left" ? offsetX + Monitor_Left: eX
          eX := eX == 0 ? mMonX : eX

          eY := direction == "Up" ? offsetY + Monitor_Top : 0
          eY := direction == "Down" ? Monitor_Bottom - offsetY : eY
          eY := eY == 0 ? mMonY : eY

          if (eX or eY) {
            MouseMove, % eX, % eY, % Options["EdgeDelay"]
            if (Options["EdgeSensitivity"] <= 1)
              return
          }
        }
      }
    }
  }
return
