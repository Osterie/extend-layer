#Requires AutoHotkey v2.0

#Include <Util\KeyboardOverlay\KeyboardOverlay>


Class KeyboardOverlaysInitializer{
    
    jsonFile := ""
    objectRegistry := ""


    __New(jsonFile, objectRegistry){
        this.jsonFile := jsonFile
        this.objectRegistry := objectRegistry
        this.instanceOfRegistry := this.ObjectRegistry.GetObjectInfo("OverlayRegistry").GetObjectInstance()
    }

    ; TODO add method to read which keys are used to show keyboard overlays, should be in the correct layer section, because only then should they activate
    ReadAllKeyboardOverlays(){
        For key, value in this.jsonFile{
            if (InStr(key, "KeyboardOverlay")){
                NewKeyboardOverlay := KeyboardOverlay()
                NewKeyboardOverlay.CreateGui()
                if (value.has("overlayElements")){
                    this.fillKeyboardOverlayInformation(NewKeyboardOverlay, value["overlayElements"])
                    this.instanceOfRegistry := this.ObjectRegistry.GetObjectInfo("OverlayRegistry").GetObjectInstance()
                    this.instanceOfRegistry.addKeyboardOverlay(NewKeyboardOverlay, key)
                }
            }
        }
    }

    fillKeyboardOverlayInformation(KeyboardOverlay, KeyboardOverlayElements){
        For overlayElementName, overlayElementInformation in KeyboardOverlayElements{
            key := overlayElementInformation["key"]
            description := overlayElementInformation["description"]
            this.SetKeyboardOverlayValues(KeyboardOverlay, key, description)
        }
        
    }

    SetKeyboardOverlayValues(KeyboardOverlay, ColumnHelperKey, ColumnFriendlyName){
        KeyboardOverlay.AddStaticColumn(ColumnHelperKey, ColumnFriendlyName)
    }

    ChangeHotkeysStateForKeyboardOverlaysByLayerSection(layerSection, enableHotkeys := true){
        try{
            for key, value in this.jsonFile{
                if (InStr(key, layerSection)){

                    showKeyboardOverlayKey := this.jsonFile[key]["ShowKeyboardOverlayKey"]
                    ; TODO use the keyboardOVelray class to create a new keyboard overlay, which then columns are added to
                    ; TODO, each layer should have the "KeyboardOverlayKey" in it, which is then created there and such blah blah blah
                    this.ChangeHotkeyStateForKeyboardOverlay(key, showKeyboardOverlayKey, enableHotkeys)
                }
            }
        }
        catch{
            ; overlay does not exist...
        }
    }

    ChangeHotkeyStateForKeyboardOverlay(sectionName, showKeyboardOverlayKey, enableHotkeys := true){
        if (enableHotkeys){
            HotKey(showKeyboardOverlayKey, (ThisHotkey) => this.instanceOfRegistry.ShowKeyboardOverlay(sectionName))
            HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfRegistry.hideAllLayers())
        }
        else if (enableHotkeys = false){
            HotKey(showKeyboardOverlayKey, (ThisHotkey) => this.instanceOfRegistry.ShowKeyboardOverlay(sectionName), "off")
            HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfRegistry.hideAllLayers(), "off")
        }
        else {
            msgbox("error in KeyboardOverlaysInitializer, state is not on or off")
        }
    }

    HotKeyForHidingKeyboardOverlaysUseMeGlobally(){
        try{
            for key, value in this.jsonFile{
                if (InStr(key, "KeyboardOverlay")){
                    showKeyboardOverlayKey := this.jsonFile[key]["ShowKeyboardOverlayKey"]
                    HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfRegistry.hideAllLayers())
                }
            }
        }
        catch{
            ; overlay does not exist...
        }
    }
}