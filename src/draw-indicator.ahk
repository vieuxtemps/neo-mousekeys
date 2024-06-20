DrawIndicator:
  if (enabled) {
    MouseGetPos, mX, mY
    tX := mX + Options["IndicatorOffsetX"]
    tY := mY + Options["IndicatorOffsetY"]
    tX := Min(tX, A_ScreenWidth - 30)
    tY := Min(tY, A_ScreenHeight - 30)
    Gui, Show, % "X" tX " Y" tY " NA"
  }
return