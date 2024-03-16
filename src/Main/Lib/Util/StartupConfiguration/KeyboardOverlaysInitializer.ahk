#Requires AutoHotkey v2.0

#Include <Util\KeyboardOverlay\KeyboardOverlay>


Class KeyboardOverlaysInitializer{
    
    layersInformation := ""
    objectRegistry := ""


    __New(layersInformation, objectRegistry){
        this.layersInformation := layersInformation
        this.objectRegistry := objectRegistry
        this.instanceOfOverlayRegistry := this.objectRegistry.GetObjectInfo("OverlayRegistry").GetObjectInstance()
    }

    ; TODO add method to read which keys are used to show keyboard overlays, should be in the correct layer section, because only then should they activate
    ReadAllKeyboardOverlays(){
        For key, value in this.layersInformation.GetKeyboardOverlaysRegistry(){

            NewKeyboardOverlay := KeyboardOverlay()
            NewKeyboardOverlay.CreateGui()

            NewKeyboardOverlay.fillKeyboardOverlayInformation(value)
            
            this.instanceOfOverlayRegistry.addKeyboardOverlay(NewKeyboardOverlay, key)
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

    ; FIXME does not work probably TODO
    ChangeHotkeysStateForKeyboardOverlaysByLayerSection(layerSection, enableHotkeys := true){
        try{
            
            for key, value in this.layersInformation.GetKeyboardOverlaysRegistry(){
                if (InStr(key, layerSection)){
                    ; TODO use the keyboardOVelray class to create a new keyboard overlay, which then columns are added to
                    ; TODO, each layer should have the "KeyboardOverlayKey" in it, which is then created there and such blah blah blah
                    showKeyboardOverlayKey := this.layersInformation.GetRegistryByLayerIdentifier(key).getShowKeyboardOverlayKey()
                    this.ChangeHotkeyStateForKeyboardOverlay(key, showKeyboardOverlayKey, enableHotkeys)
                    
                }
            }
        }
        catch{
            msgbox("error in KeyboardOverlaysInitializer, layer section does not exist")
            ; overlay does not exist...
        }
    }

    ChangeHotkeyStateForKeyboardOverlay(sectionName, showKeyboardOverlayKey, enableHotkeys := true){
        if (enableHotkeys){
            HotKey(showKeyboardOverlayKey, (ThisHotkey) => this.instanceOfOverlayRegistry.ShowKeyboardOverlay(sectionName))
            HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfOverlayRegistry.hideAllLayers())
        }
        else if (enableHotkeys = false){
            HotKey(showKeyboardOverlayKey, (ThisHotkey) => this.instanceOfOverlayRegistry.ShowKeyboardOverlay(sectionName), "off")
            HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfOverlayRegistry.hideAllLayers(), "off")
        }
        else {
            msgbox("error in KeyboardOverlaysInitializer, state is not on or off")
        }
    }

    HotKeyForHidingKeyboardOverlaysUseMeGlobally(){
        try{
            for key, value in this.layersInformation.GetKeyboardOverlaysRegistry(){
                if (InStr(key, "KeyboardOverlay")){
                    showKeyboardOverlayKey := this.layersInformation.GetRegistryByLayerIdentifier(key).getShowKeyboardOverlayKey()
                    HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfOverlayRegistry.hideAllLayers())
                    
                }
            }
        }
        catch Error as e{
            msgbox(e.Message)
            ; overlay does not exist...
        }
    }
}