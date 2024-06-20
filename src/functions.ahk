Register(keys, target, prefix := "", suffix := "") {
  if (keys) {
    keys := InStr(keys, " & ") ? [keys] : StrSplit(keys, A_Space, A_Space)
    for _, key in keys
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
  if (curState != newState and ReleaseMouseButtons() == 0) {
    Click, % btn " " newState
    lastCursorActivity := A_TickCount
  }
}

ToggleClick(btn) {
  busy := IsBusy()
  if (busy != 0 and busy != btn) ; Prevents triggering a secondary mouse button hold
    return

  next := GetKeyState(mouseMap[btn]) ? "up" : "down"
  Click, % btn " " next
  lastCursorActivity := A_TickCount
  UpdateIndicatorColors(next)
}

Enable() {
  if (WinActive("ahk_group IgnoreGroup")) {
    return
  }

  ; Ignore when in fullscreen
  if (Options["SystemIgnoreWhenFullscreen"] and not WinActive("ahk_group IgnoreFullscreenGroup")) {
    WinGetPos, X, Y, W, H, A
    if (X == Monitor_Left and Y == Monitor_Top
      and W == (Monitor_Right - Monitor_Left)
      and H == (Monitor_Bottom - Monitor_Top)) {
      return
    }
  }

  if (Options["CursorHideCursorAfterSeconds"]) {
    cursor := true
    lastCursorActivity := A_TickCount
    SystemCursor(1)
  }

  enabled := true

  if (A_IsCompiled)
    Menu, Tray, Icon, % A_ScriptFullPath, -206, 1
  else
    Menu, Tray, Icon, icons\enabled.ico, , 1
}

EnableDelayed(key) {
  if (A_PriorHotkey = key)
    Enable()
}

Disable(release := true) {
  if (release)
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

MoveToMiddle(mainMonitor := false) {
  UpdateMonitors()
  I := Options["ZonesMainMonitorIndex"]
  Middle_X := (mainMonitor ? Monitors[I "Left"] + Monitors[I "Right"] : Monitor_Left + Monitor_Right) // 2
  Middle_Y := (mainMonitor ? Monitors[I "Top"] + Monitors[I "Bottom"] : Monitor_Top + Monitor_Bottom) // 2
  MouseMove, % Middle_X, % Middle_Y, % Options["EdgeDelay"]
}

ToggleSlowMode() {
  slowToggle := not slowToggle
}

ToggleFastMode() {
  fastToggle := not fastToggle
}

RestartNeomousekeys() {
  Reload
}

LabelIgnore:
return
