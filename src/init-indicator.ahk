symbol := Options["IndicatorSymbol"]
color := Options["IndicatorColor"]
opacity := Options["IndicatorOpacity"]
size := Options["IndicatorSize"]

MouseGetPos, mX, mY
Gui, +ToolWindow +LastFound +AlwaysOnTop -Caption
Gui, Color, 000000
Gui, Font, s%size% c%color% q3, Verdana
Gui, Add, Text, vMode Center w%size%, %symbol%
WinSet, ExStyle, +0x20
WinSet, TransColor, 000000 %opacity%
