HotKey, % Options["ActivationEnable"], LabelEnable

; Enable while holding a key
holdKey := Options["ActivationEnableHold"]
if (holdKey) {
  fnDown := Func("EnableHold").Bind( "down")
  fnUp := Func("EnableHold").Bind("up")
  HotKey, % holdKey, % fnDown
  HotKey, % holdKey " up", % fnUp
}

; Enable when double pressing a sequence
if (Options["ActivationEnableDouble"])
  HotKey, % "~" Options["ActivationEnableDouble"], LabelEnableDouble

#If enabled
  HotKey, If, enabled

  HotKey, % Options["DeactivationDisable"], LabelDisable

  if (Options["DeactivationClickThenDisable"])
    HotKey, % Options["DeactivationClickThenDisable"], LabelClickThenDisable

  for _, section in ["Movement", "Mode", "Wheel"] {
    IniRead, sectionData, options.ini, % section
    Loop, Parse, sectionData, `n, `r
    {
      cmd := StrSplit(A_LoopField, "=", A_Space, 2)[1]
      HotKey, % Options[section cmd], LabelIgnore

      if (Options["SystemAllowShiftHotkeys"])
        HotKey, % "+" Options[section cmd], LabelIgnore
    }
  }

  for btn, _ in mouseMap {
    for _, modifier in ["", "^", "+"] {
      if (modifier != "+" or Options["SystemAllowShiftHotkeys"]) {
        fnDown := Func("DoClick").Bind(btn, "down")
        fnUp := Func("DoClick").Bind(btn, "up")
        HotKey, % modifier Options["Click" btn], % fnDown
        HotKey, % modifier Options["Click" btn] " up", % fnUp
      }
    }

    hold := Options["ClickHold" btn]
    if (hold) {
      fnHold := Func("ToggleClick").Bind(btn)
      HotKey, % hold, % fnHold

      if (Options["SystemAllowShiftHotkeys"])
        HotKey, % "+" hold, % fnHold
    }

    if (Options["EdgeEnabled"]) {
      fnEdgeClickDown := Func("DoClick").Bind(btn, "down")
      fnEdgeClickUp := Func("DoClick").Bind(btn, "up")
      HotKey, % Options["EdgeModifier"] " & " Options["Click" btn], % fnEdgeClickDown
      HotKey, % Options["EdgeModifier"] " & " Options["Click" btn] " up", % fnEdgeClickUp
    }
  }

  for direction, _ in axisMap {
    if (Options["EdgeEnabled"])
      HotKey, % Options["EdgeModifier"] " & " Options["Movement" direction], LabelIgnore
  }

  HotKey, If
#If
