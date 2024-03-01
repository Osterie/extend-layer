#Requires AutoHotkey v2.0

#Include "..\MetaInfoStorage\KeyboardLayouts\KeyboardLayersInfoRegistry.ahk"
#Include "..\..\JsonParsing\JXON\JXON.ahk"
#Include "..\..\JsonParsing\JsonFormatter\JsonFormatter.ahk"

class KeyboadLayersInfoClassObjectReader{

    jsonObject := Map()

    ReadObjectToJson(KeyboardLayersInfoRegister){
        if (Type(KeyboardLayersInfoRegister) = "KeyboardLayersInfoRegistry"){
            visualOverlayMap := KeyboardLayersInfoRegister.GetKeyboardOverlaysRegistry()
            hotkeysMap := KeyboardLayersInfoRegister.GetHotkeysRegistry()
            this.ReadVisualOverlay(visualOverlayMap)
            this.ReadHotkeys(hotkeysMap)
        }
        ; TODO handle an else...
    }

    getJsonObject(){
        return this.jsonObject
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
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["ObjectName"] := hotkeyInformation.getObjectName()
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["MethodName"] := hotkeyInformation.getMethodName()
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["Parameters"] := hotkeyInformation.getParameters()
                }
                else{
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["isObject"] := false
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["key"] := hotkeyInformation.getNewHotkeyName()
                    this.jsonObject[hotkeyIdentifier][hotkeyName]["modifiers"] := hotkeyInformation.getNewHotkeyModifiers()
                }
            }
        }
    }
}