#Requires AutoHotkey v2.0

#Include "..\MetaInfoStorage\KeyboardLayouts\KeyboardLayersInfoRegistry.ahk"
#Include "..\..\JsonParsing\JXON\JXON.ahk"
class KeyboadLayersInfoClassObjectReader{

    PATH_TO_KEYBOARD_INFO := ""
    keyboardInfo := ""

    KeyboardLayersInfoRegister := ""

    jsonObject := Map()

    ; json2 := Map()
    ; json2["object"] := Map()
    ; json2["object"]["name"] := "Mouse"
    ; json2["object"]["methods"] := Map()
    ; json2["object"]["methods"]["Click"] := Map()
    ; json2["object"]["methods"]["Click"]["description"] := "Clicks the mouse"
    ; json2["object"]["methods"]["Click"]["parameters"] := Map()
    ; json2["object"]["methods"]["Click"]["parameters"]["x"] := Map()
    ; json2["object"]["methods"]["Click"]["parameters"]["x"]["type"] := "int"
    ; json2["object"]["methods"]["Click"]["parameters"]["x"]["description"] := "The x position to click"
    ; json2["object"]["methods"]["Click"]["parameters"]["y"] := Map()
    ; json2["object"]["methods"]["Click"]["parameters"]["y"]["type"] := "int"
    ; json2["object"]["methods"]["Click"]["parameters"]["y"]["description"] := "The y position to click"
    ; json2["object"]["methods"]["Move"] := Map()
    ; json2["object"]["methods"]["Move"]["description"] := "Moves the mouse"
    ; json2["object"]["methods"]["Move"]["parameters"] := Map()
    ; json2["object"]["methods"]["Move"]["parameters"]["x"] := Map()
    ; json2["object"]["methods"]["Move"]["parameters"]["x"]["type"] := "int"
    ; json2["object"]["methods"]["Move"]["parameters"]["x"]["description"] := "The x position to move to"
    ; json2["object"]["methods"]["Move"]["parameters"]["y"] := Map()
    ; json2["object"]["methods"]["Move"]["parameters"]["y"]["type"] := "int"
    ; json2["object"]["methods"]["Move"]["parameters"]["y"]["description"] := "The y position to move to"
    ; json2["object"]["methods"]["GetPos"] := Map()


    __New(KeyboardLayersInfoRegister){
        this.KeyboardLayersInfoRegister := KeyboardLayersInfoRegister
    }

    ReadObjectToJson(){
        if (Type(this.KeyboardLayersInfoRegister) = "KeyboardLayersInfoRegistry"){
            visualOverlayMap := this.KeyboardLayersInfoRegister.GetKeyboardOverlaysRegistry()
            hotkeysMap := this.KeyboardLayersInfoRegister.GetHotkeysRegistry()
            this.ReadVisualOverlay(visualOverlayMap)
            this.ReadHotkeys(hotkeysMap)
            this.read()
            ; TODO loop visualOverlayMap
            ; TODO loop hotkeysMap
        }
        ; TODO handle an else...
    }

    ReadVisualOverlay(visualOverlayMap){

        For overlayIdentifier, visualOverlayInfo in visualOverlayMap{
            this.jsonObject[overlayIdentifier] := Map()
            this.jsonObject[overlayIdentifier]["ShowKeyboardOverlayKey"] := visualOverlayInfo.getShowKeyboardOverlayKey()
            keyboardOverlayElements := (visualOverlayInfo.getOverlayElements().getKeyboardOverlayElements())
            this.jsonObject[overlayIdentifier]["overlayElements"] := Map()
            For elementName, elementInfo in keyboardOverlayElements{
                this.jsonObject[overlayIdentifier]["overlayElements"][elementName] := Map()
                this.jsonObject[overlayIdentifier]["overlayElements"][elementName]["key"] := elementInfo.getKey()
                this.jsonObject[overlayIdentifier]["overlayElements"][elementName]["description"] := elementInfo.getDescription()

            }
        }
    }
    
    ReadHotkeys(hotkeysMap){
        For hotkeyIdentifier, hotkeyInfo in hotkeysMap{
            this.jsonObject[hotkeyIdentifier] := Map()
            
            For hotkeyName, hotkeyInformation in hotkeyInfo.GetHotkeys(){
                this.jsonObject[hotkeyIdentifier][hotkeyName] := Map()
                
                if (hotkeyInformation.hotkeyIsObject()){
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["isObject"] := true

                    objectName := hotkeyInformation.getObjectName()
                    methodName := hotkeyInformation.getMethodName()
                    parameters := hotkeyInformation.getParameters()
                    
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["ObjectName"] := objectName
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["MethodName"] := methodName
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["Parameters"] := parameters
                }
                else{
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["isObject"] := false

                    newHotkeyKey := hotkeyInformation.getNewHotkeyName()
                    newHotkeyModifiers := hotkeyInformation.getNewHotkeyModifiers()

                    this.jsonObject[hotkeyIdentifier][hotkeyName]["key"] := newHotkeyKey
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["modifiers"] := newHotkeyModifiers
                }
            }
        }
    }

    read(){
        jsonString := Jxon_Dump(this.jsonObject)
    
        indentationLevel := 0
        textToReturn := ""
        previousValue := ""
        quotationMarkCount := 0
        inQuotes := false
    
        Loop Parse jsonString{
    
            if (Mod(quotationMarkCount, 2) = 1){
                inQuotes := true
            }
            else{
                inQuotes := false
            }
    
            if(A_LoopField = "{" and inQuotes = false){
                indentationLevel++
                textToReturn .= "{`n"
                Loop indentationLevel{
                    textToReturn .= "`t"
                }
            }
            else if (A_LoopField = "}" and inQuotes = false){
                indentationLevel--
                textToReturn .= "`n"
                Loop indentationLevel{
                    textToReturn .= "`t"
                }
                textToReturn .= "}"
        
            }
            else if (A_LoopField = "," and inQuotes = false){
                textToReturn .= ",`n"
                Loop indentationLevel{
                    textToReturn .= "`t"
                }
            }
            else if (A_LoopField = "`"" and previousValue != "``"){
                quotationMarkCount++
                textToReturn .= A_LoopField
            }
            else{
                textToReturn .= A_LoopField
            }
            previousValue := A_LoopField
        }

        FileObj := FileOpen(".\library\MetaInfo\MetaInfoReading\Json2.json", "rw" , "UTF-8")
        
        FileObj.WriteLine(textToReturn)
    }
}