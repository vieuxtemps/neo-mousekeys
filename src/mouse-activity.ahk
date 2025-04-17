CheckMouseActivity:
  now := A_TickCount
  delta := now - lastCursorActivity

  ; Disable neo-mousekeys on idle
  if (IDLE_TIMEOUT and enabled and delta > IDLE_TIMEOUT) {
    Disable()
  }

  ; Hide cursor on idle
  if (CURSOR_TIMEOUT) {
    if (not enabled) {
      MouseGetPos, mX, mY
      mMonX := mX, mMonY := mY
    }

    if (mMonX != prev_mX or mMonY != prev_mY) {
      ; Movement
      if (not cursor) {
        if (enabled)
          SystemCursor("C", "main.cur")
        else
          SystemCursor(1)

        cursor := true
      }

      lastCursorActivity := now
    } else if (cursor and delta > CURSOR_TIMEOUT) {
      ; No movement, and cursor is visible, cursor should be hidden
      if (enabled and Options["CursorHideCursorIfEnabled"])
        SystemCursor("C", "idle.cur")
      else if (not enabled)
        SystemCursor(0)

      cursor := false
    }
  }

  prev_mX := mMonX, prev_mY := mMonY
return
