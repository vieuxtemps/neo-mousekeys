SysGet, MonitorCount, 80
global MonitorCount
global Monitors := {}

global Monitor_Left, Monitor_Right, Monitor_Top, Monitor_Bottom
global mMonX, mMonY

Loop, %MonitorCount%
{
  SysGet, Monitor%A_Index%, Monitor, %A_Index%
  Monitors[A_Index "Left"] := Monitor%A_Index%Left
  Monitors[A_Index "Right"] := Monitor%A_Index%Right
  Monitors[A_Index "Top"] := Monitor%A_Index%Top
  Monitors[A_Index "Bottom"] := Monitor%A_Index%Bottom
}

CurrentMonitor() {
  Loop, %MonitorCount%
  {
    if ((mMonX >= Monitors[A_Index "Left"]) && (mMonX < Monitors[A_Index "Right"])
      && (mMonY >= Monitors[A_Index "Top"]) && (mMonY < Monitors[A_Index "Bottom"])) {
      return A_Index
    }
  }
  return 0
}

UpdateMonitors() {
  MouseGetPos, mX, mY
  mMonX := mX, mMonY := mY
  M := CurrentMonitor()
  Monitor_Left := Monitors[M "Left"], Monitor_Right := Monitors[M "Right"]
  Monitor_Top := Monitors[M "Top"], Monitor_Bottom := Monitors[M "Bottom"]
}
