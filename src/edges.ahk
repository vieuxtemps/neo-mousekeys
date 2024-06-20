CheckEdges:
  if (enabled) {
    if (Options["EdgeEnabled"] and GetKeyState(Options["EdgeModifier"], "P")) {
      if ((Options["EdgeSensitivity"] == 0) and (A_TickCount - lastEdge < 200))
        return
      if ((Options["EdgeSensitivity"] > 0) and (A_TickCount - lastEdge < 40))
        return

      eX := mMonX, eY := mMonY
      splitX := Options["EdgeSplitX"], splitY := Options["EdgeSplitY"]

      for direction, _ in axisMap {
        if (GetKeyState(Options["Movement" direction], "P")) {
          UpdateMonitors()

          L := Monitor_Left, R := Monitor_Right, T := Monitor_Top, B := Monitor_Bottom

          hMID := (L + R) // 2
          vMID := (T + B) // 2

          oX := R * Options["EdgeOffsetX"]
          oY := B * Options["EdgeOffsetY"]

          if (direction == "Right")
            eX := (splitX and mMonX < hMID) ? hMID : R - oX
          else if (direction == "Left")
            eX := (splitX and mMonX > hMID) ? hMID : L + oX
          else if (direction == "Down")
            eY := (splitY and mMonY < vMID) ? vMID : B - oY
          else if (direction == "Up")
            eY := (splitY and mMonY > vMID) ? vMID : T + oY
        }
      }

      if (eX or eY) {
        MouseMove, % eX, % eY, % Options["EdgeDelay"]
        lastEdge := A_TickCount
        if (Options["EdgeSensitivity"] <= 1)
          return
      }
    }
  }
return
