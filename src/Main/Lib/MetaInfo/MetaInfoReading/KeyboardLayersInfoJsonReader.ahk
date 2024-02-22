#Requires AutoHotkey v2.0

; #Include "..\MetaInfoStorage\KeyboardLayouts\KeyboardLayersInfoRegistry.ahk"

#Include ..\MetaInfoStorage

#Include ".\KeyboardLayouts\KeyboardLayersInfoRegistry.ahk"
#Include ".\KeyboardLayouts\KeyboardsInfo\Hotkeys\logic\HotkeysRegistry.ahk"
#Include ".\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo.ahk"

#Include ".\KeyboardLayouts\KeyboardsInfo\KeyboardOverlays\logic\KeyboardOverlayElementRegistry.ahk"
#Include ".\KeyboardLayouts\KeyboardsInfo\KeyboardOverlays\entity\KeyboardOverlayElement.ahk"
#Include ".\KeyboardLayouts\KeyboardsInfo\KeyboardOverlays\KeyboardOverlayInfo.ahk"



class KeyboardLayersInfoJsonReader{
    

    PATH_TO_KEYBOARD_INFO := ""
    keyboardInfo := ""

    KeyboardLayersInfoRegister := ""


    __New(jsonFilePath){
        this.PATH_TO_KEYBOARD_INFO := jsonFilePath
        this.KeyboardLayersInfoRegister := KeyboardLayersInfoRegistry()
    }

    ReadKeyboardLayersInfoFromJson(){
        try{
            jsonStringKeyboardInfo := FileRead(this.PATH_TO_KEYBOARD_INFO, "UTF-8")
        }
        catch{
            throw ("Could not read the file: " . this.PATH_TO_KEYBOARD_INFO)
        }
        this.keyboardInfo := jxon_load(&jsonStringKeyboardInfo)

        ; -----------Read JSON----------------

        ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
        For layerIdentifier , layerInfoContents in this.keyboardInfo{
            if (InStr(layerIdentifier, "Hotkeys")){
                this.ReadHotkeys(layerIdentifier, layerinfoContents)
            }
            else if (InStr(layerIdentifier, "KeyboardOverlay")){
                this.ReadKeyboardOverlay(layerIdentifier, layerInfoContents)
            }
            else{
                throw ("Unknown layer type: " . layerIdentifier)
            }
        }
    }
    
    ReadHotkeys(layerIdentifier, layerInfoContents){
        HotkeysRegister := HotkeysRegistry(layerIdentifier)
        For hotkeyName, informationAboutHotkey in layerInfoContents{
            hotKeyInformation := HotKeyInfo(hotkeyName)
            
            if (informationAboutHotkey["isObject"]){
                hotKeyInformation.setInfoForSpecialHotKey(informationAboutHotkey["ObjectName"], informationAboutHotkey["MethodName"], informationAboutHotkey["Parameters"])
            }
            else if (!informationAboutHotkey["isObject"]){
                hotKeyInformation.setInfoForNormalHotKey(informationAboutHotkey["key"], informationAboutHotkey["modifiers"])
            }
            else{
                throw ("Unknown hotkey type: " . informationAboutHotkey)
            }
            HotkeysRegister.addHotkey(hotKeyInformation)
        }
        this.KeyboardLayersInfoRegister.AddHotkeysRegistry(HotkeysRegister)
    }

    ReadKeyboardOverlay(layerIdentifier, layerInfoContents){
        ShowKeyboardOverlayKey := ""

        For key, informationAboutKey in layerInfoContents{
            if (key == "overlayElements"){
                
                elementRegistry := KeyboardOverlayElementRegistry(key)
                For overlayElementName, informationAboutOverlayElement in informationAboutKey{
                    elementName := overlayElementName
                    overlayKeyToPress := informationAboutOverlayElement["key"]
                    description := informationAboutOverlayElement["description"]
                    element := KeyboardOverlayElement(elementName, overlayKeyToPress, description)
                    elementRegistry.addKeyboardOverlayElement(element)
                }
            }
        }
        try{
            KeyboardOverlayInformation := KeyboardOverlayInfo(layerInfoContents["ShowKeyboardOverlayKey"], layerIdentifier, elementRegistry)
            this.KeyboardLayersInfoRegister.AddKeyboardOverlayLayerInfo(KeyboardOverlayInformation)
        }
    }

    getKeyboardLayersInfoRegister(){
        return this.KeyboardLayersInfoRegister
    }

}