Gui, Font , cRed s40 bold, Arial Narrow
Gui, Add, Text, x15 y10 gClicked1, ███ ; in case you don't see anything here, 3x ascii 219 e.g. type Alt+219 to get the char. ASCII code 219 = █ ( Block, graphic character ) 
Gui, Font , cWh
ite s12 bold, Arial Narrow
Gui, Add, Text,   x40 y35 vText1, Button1
GuiControl +BackgroundTrans, Text1
Gui, Show
Return

Clicked1:
MsgBox You Clicked
Return

i:: exitapp
esc:: exitapp

exit:
exitapp