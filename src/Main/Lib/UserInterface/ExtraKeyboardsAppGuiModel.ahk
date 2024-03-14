#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\IniFileReader>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\MetaInfo\MetaInfoReading\KeyboadLayersInfoClassObjectReader>
#Include <Util\MetaInfo\MetaInfoWriting\ToJsonFileWriter>

Class ExtraKeyboardsAppGuiModel{

    keyNames := ""
    currentLayer := ""
    activeObjectsRegistry := ""
    keyboardLayerIdentifiers := ""
    keyboardLayersInfoRegister := ""

    __New(activeObjectsRegistry, keyboardLayersInfoRegister, keyNames){
        
        this.keyNames := keyNames
        this.activeObjectsRegistry := activeObjectsRegistry
        this.keyboardLayerIdentifiers := keyboardLayersInfoRegister.getLayerIdentifiers()
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister

    }

    ChangeHotkey(originalHotkey, newHotkey, newAction){
        this.keyboardLayersInfoRegister.ChangeHotkey(this.GetCurrentLayer(), originalHotkey, newHotkey)
        this.keyboardLayersInfoRegister.ChangeAction(this.GetCurrentLayer(), newHotkey, newAction)

        ToJsonFileWriter.WriteKeyboardLayersInfoRegisterToJsonFile(this.keyboardLayersInfoRegister, this.GetPathToCurrentProfile() . "\Keyboards.json")
    }

    AddHotkey(newAction){

        this.keyboardLayersInfoRegister.AddHotkey(this.GetCurrentLayer(), newAction)

        ToJsonFileWriter.WriteKeyboardLayersInfoRegisterToJsonFile(this.keyboardLayersInfoRegister, this.GetPathToCurrentProfile() . "\Keyboards.json")
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

    GetPathToCurrentProfile(){
        return FilePaths.GetPathToCurrentProfile()
    }

    GetHotkeyInfoForCurrentLayer(hotkeyKey){
        return this.keyboardLayersInfoRegister.GetHotkeyInfoForLayer(this.GetCurrentLayer(), hotkeyKey)
    }

    ; GetFriendlyHotkeysForLayer(layerIdentifier){
    ;     itemsToShowForListView := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(layerIdentifier)
    ;     hotkeysForLayer := itemsToShowForListView.getFriendlyHotkeyActionPairValues()

    ;     return hotkeysForLayer
    ; }
}
