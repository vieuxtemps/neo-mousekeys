HotKey, % Options["ActivationEnable"], LabelEnable

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

  for _, btn in ["Left", "Middle", "Right"] {
    for _, modifier in ["", "^", "+"] {
      if (modifier != "+" or Options["SystemAllowShiftHotkeys"]) {
        fnDown := Func("DoClick").Bind(btn, "down")
        fnUp := Func("DoClick").Bind(btn, "up")
        HotKey, % modifier Options["Click" btn], % fnDown
        HotKey, % modifier Options["Click" btn] " up", % fnUp
      }
    }
  }

  HotKey, If
#If
