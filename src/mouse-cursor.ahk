; Docs: https://learn.microsoft.com/en-us/windows/win32/menurc/about-cursors
; TODO: remove custom/replace and keep only 1 variable
GetCustomCursor(custom, replace) {
  if (replace != -1 and custom = "main.cur")
    path := A_WorkingDir "\cursors\" replace
  else
    path := A_WorkingDir "\cursors\" custom

  ; LoadImage with IMAGE_CURSOR (2) and LR_LOADFROMFILE (0x10)
  h_custom := DllCall("LoadImage", "uint", 0, "str", path, "uint", 2, "int", 32, "int", 32, "uint", 0x10)

  if (!h_custom) {
    MsgBox, Error loading custom cursor from '%path%'.
    ExitApp
  }

  return h_custom
}

; WIP. Third-party script adapted from source: https://www.autohotkey.com/docs/v1/lib/DllCall.htm#HideCursor
SystemCursor(status := 1, custom := "main.cur") {
  static AndMask, XorMask, cTarget, h_cursor
    , cList0,cList1,cList2,cList3,cList4,cList5,cList6,cList7,cList8,cList9,cList10,cList11,cList12,cList13
    , cBlank1,cBlank2,cBlank3,cBlank4,cBlank5,cBlank6,cBlank7,cBlank8,cBlank9,cBlank10,cBlank11,cBlank12,cBlank13
    , cDefault1,cDefault2,cDefault3,cDefault4,cDefault5,cDefault6,cDefault7,cDefault8,cDefault9,cDefault10,cDefault11,cDefault12,cDefault13

  ; TODO: remove cTarget completely

  if (not cTarget) {
    cTarget = cDefault

    VarSetCapacity(h_cursor, 4096, 1) ; Might be unnecessary
    VarSetCapacity(AndMask, 32 * 4, 0xFF), VarSetCapacity(XorMask, 32 * 4, 0)

    system_cursors := "32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650"
    StringSplit cList, system_cursors, `,

    Loop, %cList0% {
      cBlank%A_Index% := DllCall("CreateCursor", "uint", 0, "int", 0, "int", 0, "int", 32, "int", 32, "uint", &AndMask, "uint", &XorMask)

      h_cursor := DllCall("LoadCursor", "uint", 0, "uint", cList%A_Index%)
      ; Old bug: copying this way kills animation for default cursors.
      ; Is kind of irrelevant now that I'm setting it with 0x57,
      ; but copying default cursors in the "C" block below will still lose animations if replace icons are not present.
      ; (Loading .anim directly is working fine though)
      cDefault%A_Index% := DllCall("CopyImage", "uint", h_cursor, "uint", 2, "int", 0, "int", 0, "uint", 0)
      DllCall("DestroyCursor", "uint", h_cursor)
    }
  }

  if (status = "C") {
    CUSTOM_CURSORS := { 32512: -1, 32513: "text.cur", 32514: "busy.ani", 32515: "cross.cur", 32642: "resize_tl.cur", 32643: "resize_tr.cur", 32644: "resize_h.cur", 32645: "resize_v.cur", 32646: "move.cur", 32649: "hand.cur", 32650: "working.ani" }

    Loop, %cList0% {
      current := cList%A_Index%
      replace := CUSTOM_CURSORS[current]

      if (replace)
        h_cursor := GetCustomCursor(custom, replace)
      else
        h_cursor := DllCall("CopyImage", "uint", %cTarget%%A_Index%, "uint", 2, "int", 0, "int", 0, "uint", 0)

      DllCall("SetSystemCursor", "uint", h_cursor, "uint", cList%A_Index%)
      DllCall("DestroyCursor", "uint", h_cursor)
    }
  } else {
    if (status = 0) {
      cTarget = cBlank
      Loop, %cList0% {
        h_cursor := DllCall("CopyImage", "uint", %cTarget%%A_Index%, "uint", 2, "int", 0, "int", 0, "uint", 0)
        DllCall("SetSystemCursor", "uint", h_cursor, "uint", cList%A_Index%)
        DllCall("DestroyCursor", "uint", h_cursor)
      }
    } else if (status = 1) {
      ; Original code would lose animation by setting each cursor manually after using CopyImage.
      ; Custom loading works fine because it's set manually after using LoadImage from a path.
      DllCall("SystemParametersInfo", "uint", 0x57, "uint", 0, "uint", 0, "uint", 0)
    }
  }
}
