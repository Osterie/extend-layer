#Requires AutoHotkey v2.0

#Include "..\..\FoldersAndFiles\IniFileReader.ahk"

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
                
                this.ReadKeyboardOverlaySection(NewKeyboardOverlay, value["overlayElements"])

                this.instanceOfRegistry := this.ObjectRegistry.GetObjectInfo("OverlayRegistry").GetObjectInstance()

                this.instanceOfRegistry.addKeyboardOverlay(NewKeyboardOverlay, key)
                
                showKeyboardOverlayKey := value["ShowKeyboardOverlayKey"]
                
            }
        }
    }

    ReadKeyboardOverlaySection(KeyboardOverlay, KeyboardOverlayElements){
        For overlayElementName, overlayElementInformation in KeyboardOverlayElements{
            key := overlayElementInformation["key"]
            description := overlayElementInformation["description"]
            this.SetKeyboardOverlayColumn(KeyboardOverlay, key, description)
        }
        
    }

    SetKeyboardOverlayColumn(KeyboardOverlay, ColumnHelperKey, ColumnFriendlyName){
        KeyboardOverlay.AddStaticColumn(ColumnHelperKey, ColumnFriendlyName)
    }

    CreateHotkeysForKeyboardOverlaysByLayerSection(layerSection){

        try{
            for key, value in this.jsonFile{
                if (InStr(key, layerSection)){

                    showKeyboardOverlayKey := this.jsonFile[key]["ShowKeyboardOverlayKey"]
                    ; TODO use the keyboardOVelray class to create a new keyboard overlay, which then columns are added to
                    ; TODO, each layer should have the "KeyboardOverlayKey" in it, which is then created there and such blah blah blah
                    this.CreateHotkeyForKeyboardOverlay(key, showKeyboardOverlayKey)
                }
            }
        }
        catch{
            ; overlay does not exist...
        }
    }

    CreateHotkeyForKeyboardOverlay(sectionName, showKeyboardOverlayKey){
        HotKey(showKeyboardOverlayKey, (ThisHotkey) => this.instanceOfRegistry.ShowKeyboardOverlay(sectionName))
        HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfRegistry.hideAllLayers())
    }
}