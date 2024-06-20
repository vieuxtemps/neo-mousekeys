DrawIndicator:
  if (enabled) {
    UpdateMonitors()
    tX := mMonX + Options["IndicatorOffsetX"]
    tY := mMonY + Options["IndicatorOffsetY"]
    indicatorSizeOffset := Options["IndicatorSize"] * 2.5
    tX := Min(tX, Monitor_Right - indicatorSizeOffset)
    tY := Min(tY, Monitor_Bottom - indicatorSizeOffset)
    Gui, Show, % "X" tX " Y" tY " NA"
  }
return