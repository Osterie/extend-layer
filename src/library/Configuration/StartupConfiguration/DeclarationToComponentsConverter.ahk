#Requires AutoHotkey v2.0

; This purpose of this class is to take in a String on the form of:
; win+0 = OnScreenWriter.ToggleShowKeysPressed()
; +3=WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_40058_1/cl/outline" , ["..\..\..\assets\imageSearchImages\BBLogin.png"], 3000)
; ^+t = WebSearcher.ShowTranslatedText("auto", "no")
; and so on...
; And then convert this into a "KeyRebindObject". 
; The KeyRebindObject stores information about a keybind(with modifiers) and what function to call when the keybind is pressed. This includes what parameters the 

