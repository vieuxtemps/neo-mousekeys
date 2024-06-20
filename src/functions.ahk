Register(keys, target, prefix := "", suffix := "") {
  if (keys) {
    for _, key in StrSplit(keys, A_Space, A_Space)
      HotKey, % prefix key suffix, % target
  }
}

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

Enable() {
  enabled := true

  if (A_IsCompiled)
    Menu, Tray, Icon, % A_ScriptFullPath, -206, 1
  else
    Menu, Tray, Icon, icons\enabled.ico, , 1
}

Disable() {
  ReleaseMouseButtons()
  enabled := false
  Gui, Show, Hide

  if (A_IsCompiled)
    Menu, Tray, Icon, % A_ScriptFullPath, -159, 1
  else
    Menu, Tray, Icon, icons\disabled.ico, , 1
}

LeftClickThenDisable() {
  Disable()
  Click
}

EnableDouble() {
  if (A_PriorKey == Options["ActivationEnableDouble"]
    and A_TimeSincePriorHotkey > 0
    and A_TimeSincePriorHotkey < 400) {
    Enable()
  }
}

EnableHold(state) {
  if (state == "down")
    Enable()
  else
    Disable()
}

MoveToMiddle() {
  MouseMove, A_ScreenWidth // 2, A_ScreenHeight // 2, 1
}

LabelIgnore:
return
