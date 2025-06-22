#Requires AutoHotkey v2.0

; #Include "..\MetaInfoStorage\KeyboardLayouts\KeyboardLayersInfoRegistry.ahk"

#Include ..\MetaInfoStorage

#Include ".\KeyboardLayouts\KeyboardLayersInfoRegistry.ahk"
#Include ".\KeyboardLayouts\KeyboardsInfo\Hotkeys\logic\HotkeysRegistry.ahk"
#Include ".\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo.ahk"

#Include ".\KeyboardLayouts\KeyboardsInfo\KeyboardOverlays\logic\KeyboardOverlayElementRegistry.ahk"
#Include ".\KeyboardLayouts\KeyboardsInfo\KeyboardOverlays\entity\KeyboardOverlayElement.ahk"
#Include ".\KeyboardLayouts\KeyboardsInfo\KeyboardOverlays\KeyboardOverlayInfo.ahk"

#Include <Util\JsonParsing\JXON>



class KeyboardLayersInfoJsonReader{
    

    keyboardLayersInfo := ""

    KeyboardLayersInfoRegister := ""


    __New(){
        this.KeyboardLayersInfoRegister := KeyboardLayersInfoRegistry()
    }

    ; TODO add a "for current profile"
    ReadKeyboardLayersInfoForCurrentProfile(){
        try{
            ; Try to read the information for the current profile.
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
        }
        catch{
            ; Unable to read information for the current profile, so we use default to an empty profile.
            FilePaths.SetCurrentProfile("Empty")
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
            msgbox("Unable to read information for the current profile. Defaulting to an empty profile.")
        }

        this.keyboardLayersInfo := jxon_load(&keyboardSettingsString)

        ; -----------Read JSON----------------

        ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
        For layerIdentifier , layerInfoContents in this.keyboardLayersInfo{
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