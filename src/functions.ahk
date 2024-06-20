DoClick(btn, state) {
  Click, % btn " " state
}

LabelDisable:
  enabled := false
  Gui, Show, Hide
return

LabelEnable:
  enabled := true
return

LabelIgnore:
return
