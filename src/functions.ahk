DoClick(btn, state) {
  Click, % btn " " state
}

LabelDisable:
  enabled := false
  Gui, Show, Hide
return

LabelClickThenDisable:
  Click
  enabled := false
  Gui, Show, Hide
return

LabelEnable:
  enabled := true
return

LabelEnableDouble:
  if (A_PriorKey == Options["ActivationEnableDouble"]
    and A_TimeSincePriorHotkey > 0
    and A_TimeSincePriorHotkey < 400) {
    enabled := true
  }
return

LabelIgnore:
return
