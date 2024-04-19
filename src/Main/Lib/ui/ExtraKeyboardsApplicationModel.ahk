#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\IniFileReader>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\MetaInfo\MetaInfoReading\KeyboadLayersInfoClassObjectReader>
#Include <Util\MetaInfo\MetaInfoWriting\ToJsonFileWriter>

Class ExtraKeyboardsApplicationModel{

    currentLayer := ""
    currentFunction := ""
    activeObjectsRegistry := ""
    keyboardLayerIdentifiers := ""
    keyboardLayersInfoRegister := ""

    actionSettings := ""
    

    __New(activeObjectsRegistry, keyboardLayersInfoRegister){
        ReaderForActionSettings := ActionSettingsReader(FilePaths.GetPathToCurrentSettings())
        this.actionSettings := ReaderForActionSettings.ReadSettings()
        
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

    DeleteHotkey(hotkeyKey){
        this.keyboardLayersInfoRegister.DeleteHotkey(this.GetCurrentLayer(), hotkeyKey)
        

        ToJsonFileWriter.WriteKeyboardLayersInfoRegisterToJsonFile(this.keyboardLayersInfoRegister, this.GetPathToCurrentProfile() . "\Keyboards.json")
    }

    GetActionNames(){
        return this.actionSettings.GetActionNames()
    }

    GetSettingsForActionAsArray(actionName){
        return this.actionSettings.GetSettingsForActionAsArray(actionName)
    }

    GetSettingsForCurrentActionAsArray(){
        return this.GetSettingsForActionAsArray(this.GetCurrentFunction())
    }

    GetSettingsForAction(actionName){
        return this.actionSettings.GetSettingsForAction(actionName)
    }

    GetSettingsForCurrentAction(){
        return this.GetSettingsForAction(this.GetCurrentFunction())
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

    SetCurrentFunction(functionName){
        this.currentFunction := functionName
    }

    GetCurrentFunction(){
        return this.currentFunction
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

    ChangeFunctionSetting(setting, actionName){
        this.actionSettings.ChangeActionSetting(actionName, this.GetPathToCurrentSettings(), setting)
    }

    GetPathToCurrentSettings(){
        return FilePaths.GetPathToCurrentSettings()
    }

    GetPathToCurrentProfile(){
        return FilePaths.GetPathToCurrentProfile()
    }

    GetHotkeyInfoForCurrentLayer(hotkeyKey){
        hotkeyInformation := this.keyboardLayersInfoRegister.GetHotkeyInfoForLayer(this.GetCurrentLayer(), hotkeyKey)
        hotkeyToReturn := HotkeyInfo(hotkeyInformation.getHotkeyName())

        if (hotkeyInformation.hotkeyIsObject()){
            hotkeyToReturn.setInfoForSpecialHotKey(hotkeyInformation.GetobjectName(), hotkeyInformation.GetMethodName(), hotkeyInformation.getparameters())
        }
        else{
            hotkeyToReturn.setInfoForNormalHotKey(hotkeyInformation.getNewHotkeyName(), hotkeyInformation.getNewHotkeyModifiers())
        }
        return hotkeyToReturn
    }

    ; GetFriendlyHotkeysForLayer(layerIdentifier){
    ;     itemsToShowForListView := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(layerIdentifier)
    ;     hotkeysForLayer := itemsToShowForListView.getFriendlyHotkeyActionPairValues()

    ;     return hotkeysForLayer
    ; }
}
