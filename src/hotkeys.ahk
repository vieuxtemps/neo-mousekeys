HotKey, % Options["ActivationEnable"], LabelActivate

#If enabled
  HotKey, If, enabled

  HotKey, % Options["DeactivationDisable"], LabelDisable

  for _, section in ["Movement", "Mode", "Wheel"] {
    IniRead, sectionData, options.ini, % section
    Loop, Parse, sectionData, `n, `r
    {
      split := StrSplit(A_LoopField, "=", A_Space, 2)[1]
      HotKey, % Options[section split], LabelIgnore
    }
  }

  HotKey, % Options["ClickLeft"], LabelLeft
  HotKey, % Options["ClickLeft"] " up", LabelLeftUp

  HotKey, % Options["ClickMiddle"], LabelMiddle
  HotKey, % Options["ClickMiddle"] " up", LabelMiddleUp

  HotKey, % Options["ClickRight"], LabelRight
  HotKey, % Options["ClickRight"] " up", LabelRightUp

  HotKey, If
#If