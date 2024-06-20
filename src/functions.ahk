UpdateIndicatorColors(state) {
  color := state == "down" ? Options["IndicatorColorDragging"] : Options["IndicatorColor"]
  Gui, Font, c%color%
  GuiControl, Font, Mode
}

IsBusy(release := false) {
  for btn, _ in mouseMap {
    if (GetKeyState(mouseMap[btn])) {
      if (release) {
        Click, % btn " up"
        UpdateIndicatorColors("up")
      }
      return btn
    }
  }
  return 0
}

ReleaseMouseButtons() {
  return IsBusy(true)
}

DoClick(btn, newState) {
  curState := GetKeyState(mouseMap[btn]) ? "down" : "up"
  if (curState != newState and ReleaseMouseButtons() == 0)
    Click, % btn " " newState
}

ToggleClick(btn) {
  busy := IsBusy()
  if (busy != 0 and busy != btn) ; Prevents triggering a secondary mouse button hold
    return

  next := GetKeyState(mouseMap[btn]) ? "up" : "down"
  Click, % btn " " next
  UpdateIndicatorColors(next)
}

Disable() {
  ReleaseMouseButtons()
  enabled := false
  Gui, Show, Hide
}

LabelDisable:
  Disable()
return

LabelClickThenDisable:
  Disable()
  Click
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
