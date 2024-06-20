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
          if (eX == 0)
            eX := emX

          eY := direction == "Up" ? offsetY : 0
          eY := direction == "Down" ? A_ScreenHeight - offsetY : eY
          if (eY == 0)
            eY := emY

          if (eX or eY) {
            MouseMove, % eX, % eY, 2
            return
          }
        }
      }
    }
  }
return
