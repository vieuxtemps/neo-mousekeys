global Options := {}

sections := ["Activation", "Deactivation", "Movement", "Mode", "Click", "Wheel", "Speed", "Indicator", "System"]

for _, section in sections {
  IniRead, sectionData, options.ini, % section
  Loop, Parse, sectionData, `n, `r
  {
    split := StrSplit(A_LoopField, "=", A_Space, 2)
    Options[section split[1]] := split[2]
  }
}
