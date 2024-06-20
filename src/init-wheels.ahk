; Fast mode setup
global wheelFastSplit := StrSplit(Options["ModeWheelFast"], A_Space, A_Space)

; Slow mode setup (syscalls are required)
; SPI_GETWHEELSCROLLLINES = 0x68
; SPI_SETWHEELSCROLLLINES = 0x69
DllCall("SystemParametersInfo", "UInt", 0x68, "UInt", 0, "UIntP", OrigScrollLines, "UInt", 0)
global originalScrollLines := OrigScrollLines
global slowScrollLines := Options["ModeSpeedWheelSlow"]
global lastScroll := A_TickCount
global wheelSlow := 0

SetWheelSpeed(speed) {
  DllCall("SystemParametersInfo", "UInt", 0x69, "UInt", speed, "UInt", 0, "UInt", 1|2)
}
