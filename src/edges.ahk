CheckEdges:
  if (enabled) {
    if (Options["EdgeEnabled"] and GetKeyState(Options["EdgeModifier"], "P")) {
      for direction, _ in axisMap {
        if (GetKeyState(Options["Movement" direction], "P")) {
          offsetX := Options["EdgeOffsetX"]
          offsetY := Options["EdgeOffsetY"]

          MouseGetPos, emX, emY

          eX := direction == "Right" ? A_ScreenWidth - offsetX : 0
          eX := direction == "Left" ? offsetX : eX
          eX := eX == 0 ? emX : eX

          eY := direction == "Up" ? offsetY : 0
          eY := direction == "Down" ? A_ScreenHeight - offsetY : eY
          eY := eY == 0 ? emY : eY

          if (eX or eY)
            MouseMove, % eX, % eY, % Options["EdgeDelay"]
        }
      }
    }
  }
return
