#Requires AutoHotkey v2.0

#Include "..\..\FoldersAndFiles\IniFileReader.ahk"

Class KeyboardOverlaysInitializer{
    
    jsonFile := ""
    objectRegistry := ""


    __New(jsonFile, objectRegistry){
        this.jsonFile := jsonFile
        this.objectRegistry := objectRegistry
    }

    ; TODO add method to read which keys are used to show keyboard overlays, should be in the correct layer section, because only then should they activate
    ReadAllKeyboardOverlays(){

        For key, value in this.jsonFile{
            if (InStr(key, "KeyboardOverlay")){

                ; OverlayRegistry := this.ObjectRegistry.GetObjectInfo("OverlayRegistry")

                NewKeyboardOverlay := KeyboardOverlay()
                NewKeyboardOverlay.CreateGui()
                this.ReadKeyboardOverlaySection(NewKeyboardOverlay, value["overlayElements"])

                instanceOfRegistry := this.ObjectRegistry.GetObjectInfo("OverlayRegistry").GetObjectInstance()

                instanceOfRegistry.addKeyboardOverlay(NewKeyboardOverlay, key)
                ; TODO use the keyboardOVelray class to create a new keyboard overlay, which then columns are added to
                ; TODO, each layer should have the "KeyboardOverlayKey" in it, which is then created there and such blah blah blah
                
                showKeyboardOverlayKey := value["ShowKeyboardOverlayKey"]
                
                ; HotKey(oldHotKey, (ThisHotkey) => this.SendKeysDown(newKeysDown, newHotKeyModifiers)) 

                ; HotKey(oldHotKey . " Up", (ThisHotkey) => this.SendKeysUp(newKeysUp, newHotKeyModifiers))
                
                ; HotKey(showKeyboardOverlayKey, (ThisHotkey) => instanceOfRegistry.ShowKeyboardOverlay(key))
                ; ; TODO, this " up" should be added for all layers...
                ; HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => instanceOfRegistry.hideAllLayers())
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
                    this.CreateHotkeyForKeyboardOverlay(layerSection, showKeyboardOverlayKey)
                }
            }
            msgbox("created hotkey for " . layerSection)

        }
        catch{
            ; overlay does not exist...
        }
    }

    CreateHotkeyForKeyboardOverlay(sectionName, showKeyboardOverlayKey){
        instanceOfRegistry := this.ObjectRegistry.GetObjectInfo("OverlayRegistry").GetObjectInstance()
        

        HotKey(showKeyboardOverlayKey, (ThisHotkey) => instanceOfRegistry.ShowKeyboardOverlay(sectionName))
        ; TODO, this " up" should be added for all layers...
        HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => instanceOfRegistry.hideAllLayers())
    }
}