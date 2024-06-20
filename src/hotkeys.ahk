; [Activation]
; Default enable hotkey
Register(Options["ActivationEnable"], Func("Enable"))

; Register symmetric hotkey if Enable is a combination
if (InStr(Options["ActivationEnable"], " & ")) {
  split := StrSplit(Options["ActivationEnable"], " & ")
  Register(split[2] " & " split[1], Func("Enable"))
}

; Enable when double pressing a sequence
Register(Options["ActivationEnableDouble"], Func("EnableDouble"), "~")

; Enable while holding a key
Register(Options["ActivationEnableHold"], Func("EnableHold").Bind("down"))
Register(Options["ActivationEnableHold"], Func("EnableHold").Bind("up"), "", " up")

; Enabled section
#If enabled
  HotKey, If, enabled

  ; [Deactivation]
  Register(Options["DeactivationDisable"], Func("Disable"))

  ; When enabled, don't send keys in:
  ; [Movement]
  ; [Mode]
  ; [Wheel]
  for _, section in ["Movement", "Mode", "Wheel"] {
    IniRead, sectionData, options.ini, % section
    Loop, Parse, sectionData, `n, `r
    {
      cmd := StrSplit(A_LoopField, "=", A_Space, 2)[1]
      Register(Options[section cmd], "LabelIgnore")
      if (Options["SystemAllowShiftHotkeys"])
        Register(Options[section cmd], "LabelIgnore", "+")
    }
  }

  ; [Mode]
  Register(Options["ModeToggleSlow"], Func("ToggleSlowMode"), "~")

  ; [Click]
  for btn, _ in mouseMap {
    ; Registers click functionality (Standard, Ctrl and Shift-clicks)
    for _, modifier in ["", "^", "+"] {
      if (modifier != "+" or Options["SystemAllowShiftHotkeys"]) {
        Register(Options["Click" btn], Func("DoClick").Bind(btn, "down"), modifier)
        Register(Options["Click" btn], Func("DoClick").Bind(btn, "up"), modifier, " up")
      }
    }

    ; Registers hold/toggle click functionality
    Register(Options["ClickHold" btn], Func("ToggleClick").Bind(btn))
    if (Options["SystemAllowShiftHotkeys"])
      Register(Options["ClickHold" btn], Func("ToggleClick").Bind(btn), "+")

    ; Registers click-and-disable
    Register(Options["ClickLeftClickThenDisable"], Func("LeftClickThenDisable"))

    ; [Edge]
    ; Click while holding edge button (edge case)
    if (Options["EdgeEnabled"]) {
      ; Nested edge case: Options["Click" btn] might be a key list
      for _, key in StrSplit(Options["Click" btn], A_Space, A_Space) {
        Register(Options["EdgeModifier"] " & " key, Func("DoClick").Bind(btn, "down"))
        Register(Options["EdgeModifier"] " & " key, Func("DoClick").Bind(btn, "up"), "", " up")
      }
    }
  }

  ; Prevents sending movement keys while holding the edge modifier
  if (Options["EdgeEnabled"]) {
    for direction, _ in axisMap {
      Register(Options["EdgeModifier"] " & " Options["Movement" direction], "LabelIgnore")
    }
  }

  ; [Zone]
  Register(Options["ZonesMoveToMiddle"], Func("MoveToMiddle"))

  HotKey, If
#If
