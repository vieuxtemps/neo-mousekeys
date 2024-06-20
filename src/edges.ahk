CheckEdges:
  if (enabled) {
    if (Options["EdgeEnabled"] and GetKeyState(Options["EdgeModifier"], "P")) {
      if ((Options["EdgeSensitivity"] == 0) and (A_TickCount - lastEdge < 500))
        return

      for direction, _ in axisMap {
        if (GetKeyState(Options["Movement" direction], "P")) {
          UpdateMonitors()

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
            lastEdge := A_TickCount
            if (Options["EdgeSensitivity"] <= 1)
              return
          }
        }
      }
    }
  }
return
