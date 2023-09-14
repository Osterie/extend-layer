#persistent
Menu, tray, add,,,
Menu, tray, add, Invert On, InvertOn
Menu, tray, add, Invert Off, InvertOff

InvertOn:
Ifwinexist, Magnifier
   return
Run, Magnify.exe -invert
WinWait, Magnifier
WinHide
return

InvertOff:
WinKill, Magnifier
return

i:: exitapp
esc:: exitapp

exiter:
exitapp