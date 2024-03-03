#Requires AutoHotkey v2.0

; TODO move inifilereader to meta info reading

#Include <FoldersAndFiles\IniFileReader>

#Include "<MetaInfo\MetaInfoStorage\Files\FilePaths>"

Class ExtraKeyboardsAppGuiModel{

    keyNames := ""
    currentLayer := ""
    activeObjectsRegistry := ""
    keyboardLayerIdentifiers := ""
    keyboardLayersInfoRegister := ""

    __New(keyboardLayerIdentifiers, activeObjectsRegistry, keyboardLayersInfoRegister, keyNames){
        
        this.keyNames := keyNames
        this.activeObjectsRegistry := activeObjectsRegistry
        this.keyboardLayerIdentifiers := keyboardLayerIdentifiers
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister

    }

    GetFunctionNames(){
        pathToObjectsIniFile := this.GetPathToCurrentSettings()

        fileReader := IniFileReader()
        functionsNames := []
        try{
            functionsNames := fileReader.ReadSectionNamesToArray(pathToObjectsIniFile)
        }
        catch{
            functionName := []
        }
        
        return functionsNames
    }

    GetSettingsForFunction(functionName){
        iniFileRead := IniFileReader()
        currentSettingsSettingValuePair := iniFileRead.ReadSectionKeyPairValuesIntoTwoDimensionalArray(this.GetPathToCurrentSettings(), functionName)
        return currentSettingsSettingValuePair
    }

    GetFriendlyHotkeysForLayer(layerIdentifier){
        itemsToShowForListView := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(layerIdentifier)
        hotkeysForLayer := itemsToShowForListView.getFriendlyHotkeyActionPairValues()

        return hotkeysForLayer
    }

    GetFriendlyHotkeysForCurrentLayer(){
        itemsToShowForListView := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.currentLayer)
        hotkeysForLayer := itemsToShowForListView.getFriendlyHotkeyActionPairValues()

        return hotkeysForLayer
    }

    SetCurrentLayer(layerIdentifier){
        this.currentLayer := layerIdentifier
    }

    GetCurrentLayer(){
        return this.currentLayer
    }

    GetKeyboardLayerIdentifiers(){
        return this.keyboardLayerIdentifiers
    }

    GetCurrentLayerInfo(){
        return this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.currentLayer)
    }

    GetActiveObjectsRegistry(){
        return this.activeObjectsRegistry
    }

    GetKeyNames(){
        return this.keyNames
    }

    ChangeFunctionSetting(settingName, settingValue, currentFunctionSettings){
        try{
            IniWrite(settingValue, this.GetPathToCurrentSettings(), currentFunctionSettings, settingName)
        }
        catch{
            MsgBox("Failed to save settings")
        }
    }

    GetPathToCurrentSettings(){
        return FilePaths.GetPathToCurrentSettings()
    }

}
