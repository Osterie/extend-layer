#Requires AutoHotkey v2.0

#Include "..\..\FoldersAndFiles\IniFileReader.ahk"

Class KeyboardOverlaysInitializer{
    
    iniFile := ""
    objectRegistry := ""


    __New(iniFile, objectRegistry){
        this.iniFile := iniFile
        this.objectRegistry := objectRegistry
        this.IniReader := IniFileReader()
    }

    ; TODO add method to read which keys are used to show keyboard overlays, should be in the correct layer section, because only then should they activate
    ReadAllKeyboardOverlays(){

        SectionNames := IniRead(this.iniFile)
        SectionNames := StrSplit(SectionNames, "`n")
        Loop SectionNames.Length{
            SectionName := SectionNames[A_Index]
            if (InStr(SectionName, "KeyboardOverlay")){

                ; OverlayRegistry := this.ObjectRegistry.GetObjectInfo("OverlayRegistry")

                NewKeyboardOverlay := KeyboardOverlay()
                NewKeyboardOverlay.CreateGui()
                this.ReadKeyboardOverlaySection(NewKeyboardOverlay, SectionName)

                ; OverlayRegistry.addKeyboardOverlay(NewKeyboardOverlay, SectionName)
                this.ObjectRegistry.GetObjectInfo("OverlayRegistry").addKeyboardOverlay(NewKeyboardOverlay, SectionName)
                ; TODO use the keyboardOVelray class to create a new keyboard overlay, which then columns are added to
                ; TODO, each layer should have the "KeyboardOverlayKey" in it, which is then created there and such blah blah blah
            
            }
        }

    }

    ReadKeyboardOverlaySection(KeyboardOverlay, section){
        
        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)

        ; Reads where the columns start, and deletes everything before that.
        startOfColumns := InStr(iniFileSection,"Column1")
        iniFileSection := SubStr(iniFileSection,startOfColumns)

        KeyboardOverlayColumns := StrSplit(iniFileSection, "`n")
        
        ; A_LoopField is the current item in the loop.
        Loop KeyboardOverlayColumns.Length{
            ColumnValues := this.GetKeyValue(KeyboardOverlayColumns[A_Index])
            KeyboardOverlayColumnHelperKey := StrSplit(ColumnValues, ",")[1]
            KeyboardOverlayColumnHelperKey := this.GetStringWithoutQuotes(KeyboardOverlayColumnHelperKey)
            KeyboardOverlayColumnFriendlyName := StrSplit(ColumnValues, ",")[2]
            KeyboardOverlayColumnFriendlyName := this.GetStringWithoutQuotes(KeyboardOverlayColumnFriendlyName)
            this.SetKeyboardOverlayColumn(KeyboardOverlay, KeyboardOverlayColumnHelperKey, KeyboardOverlayColumnFriendlyName )
        }
    }

    SetKeyboardOverlayColumn(KeyboardOverlay, ColumnHelperKey, ColumnFriendlyName){
        KeyboardOverlay.AddStaticColumn(ColumnHelperKey, ColumnFriendlyName)
    }

    CreateHotkeysForKeyboardOverlaysByLayerSection(layerSection){
        sectionNames := IniRead(this.iniFile)
        sectionNames := StrSplit(sectionNames, "`n")
        Loop sectionNames.Length{
            sectionName := sectionNames[A_Index]
            if (InStr(sectionName, layerSection)){

                ; TODO use the keyboardOVelray class to create a new keyboard overlay, which then columns are added to
                ; TODO, each layer should have the "KeyboardOverlayKey" in it, which is then created there and such blah blah blah
                try{
                    showKeyboardOverlayKey := IniRead(this.iniFile, sectionName, "ShowKeyboardOverlayKey")
                    this.CreateHotkeyForKeyboardOverlay(sectionName, showKeyboardOverlayKey)
                }

            }
        }
    }

    CreateHotkeyForKeyboardOverlay(sectionName, showKeyboardOverlayKey){
        ; instanceOfOverlay := this.ObjectRegistry.GetObjectInfo("OverlayRegistry").GetKeyboardOverlay(sectionName)
        instanceOfRegistry := this.ObjectRegistry.GetObjectInfo("OverlayRegistry")
        HotKey(showKeyboardOverlayKey, (ThisHotkey) => instanceOfRegistry.ShowKeyboardOverlay(sectionName))
        ; TODO, this " up" should be added for all layers...
        HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => instanceOfRegistry.hideAllLayers())
    }

    GetKeyValue(key){
        return StrSplit(key, "=")[2]
    }

    GetStringWithoutQuotes(text){
        textWithoutQutoes := StrReplace(text, "`"", "")
        textWithoutQutoes := StrReplace(textWithoutQutoes, "'", "")
        return textWithoutQutoes
    }
}