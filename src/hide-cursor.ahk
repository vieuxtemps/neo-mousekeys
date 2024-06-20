SystemCursor("Init")

CheckMouseActivity:
  now := A_TickCount
  delta := now - lastCursorActivity

  if (IDLE_TIMEOUT and enabled and delta > IDLE_TIMEOUT) {
    Disable()
  }

  if (CURSOR_TIMEOUT) {
    if (not enabled) {
      MouseGetPos, mX, mY
      mMonX := mX, mMonY := mY
    }

    if (mMonX != prev_mX or mMonY != prev_mY) {
      if (not cursor)
        SystemCursor(1)

      cursor := true
      lastCursorActivity := now
    }

    if (cursor and delta > CURSOR_TIMEOUT) {
      if (not enabled or Options["CursorHideCursorIfEnabled"]) {
        cursor := false
        SystemCursor(0)
      }
    }
  }

  prev_mX := mMonX, prev_mY := mMonY
return

; Third-party script. Source: https://www.autohotkey.com/docs/v1/lib/DllCall.htm#HideCursor
; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
SystemCursor(status := 1) {
  static AndMask, XorMask, $, h_cursor
    ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
    , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13 ; blank cursors
    , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13 ; handles of default cursors

  ; init when requested or at first call
  if (status = "Init" or status = "I" or $ = "") {
    $ = h ; active default cursors
    VarSetCapacity( h_cursor,4444, 1 )
    VarSetCapacity( AndMask, 32*4, 0xFF )
    VarSetCapacity( XorMask, 32*4, 0 )
    system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
    StringSplit c, system_cursors, `,
    Loop %c0%
    {
      h_cursor := DllCall( "LoadCursor", "uint",0, "uint",c%A_Index% )
      h%A_Index% := DllCall( "CopyImage", "uint",h_cursor, "uint",2, "int",0, "int",0, "uint",0 )
      b%A_Index% := DllCall("CreateCursor","uint",0, "int",0, "int",0
        , "int",32, "int",32, "uint",&AndMask, "uint",&XorMask )
    }
  }

  if (status = 0 or status = "Off" or $ = "h" and (status < 0 or status = "Toggle" or status = "T"))
    $ = b ; use blank cursors
  else
    $ = h ; use the saved cursors

  Loop %c0%
  {
    h_cursor := DllCall( "CopyImage", "uint",%$%%A_Index%, "uint",2, "int",0, "int",0, "uint",0 )
    DllCall( "SetSystemCursor", "uint",h_cursor, "uint",c%A_Index% )
  }
}
