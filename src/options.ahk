global IniFile := "options.ini"
global Options := {}

if (!FileExist(IniFile)) {
  MsgBox, % "Error: options.ini not found. Exiting."
  ExitApp
}

sections := ["Activation", "Deactivation"
  , "Click" , "Movement", "Wheel", "Mode"
  , "ModeSpeed", "MouseSpeed"
  ,"Edge", "Zones", "Indicator", "System", "Cursor"]

for _, section in sections {
  IniRead, sectionData, % IniFile, % section
  Loop, Parse, sectionData, `n, `r
  {
    split := StrSplit(A_LoopField, "=", A_Space, 2)
    Options[section split[1]] := split[2]
  }
}
