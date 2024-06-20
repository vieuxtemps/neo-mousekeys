symbol := Options["IndicatorSymbol"]
color := Options["IndicatorColor"]
opacity := Options["IndicatorOpacity"]

MouseGetPos, mX, mY
Gui, +ToolWindow +LastFound +AlwaysOnTop -Caption
Gui, Color, 000000
Gui, Font, s12 c%color% w700 q5, Verdana
Gui, Add, Text, Center w12, %symbol%
WinSet, ExStyle, +0x20
WinSet, TransColor, 000000 %opacity%
