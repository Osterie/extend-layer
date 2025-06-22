#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\IniFileReader>
#Include <Shared\FilePaths>
#Include <Util\MetaInfo\MetaInfoReading\KeyboadLayersInfoClassObjectReader>
#Include <Util\MetaInfo\MetaInfoWriting\ToJsonFileWriter>

#Include <Infrastructure\Repositories\ActionSettingsRepository>

Class ExtraKeyboards{

    currentLayer := ""
    currentFunction := ""
    activeObjectsRegistry := ""
    keyboardLayersInfoRegister := ""
    ActionSettingsRepository := ActionSettingsRepository()

    actionSettings := ""
    
    __New(activeObjectsRegistry, keyboardLayersInfoRegister){
        this.actionSettings := this.ActionSettingsRepository.getActionGroupSettingsRegistry()
        this.activeObjectsRegistry := activeObjectsRegistry
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister
    }

    changeHotkey(originalHotkey, newHotkey, newAction){
        this.keyboardLayersInfoRegister.changeHotkey(this.GetCurrentLayer(), originalHotkey, newHotkey)
        this.keyboardLayersInfoRegister.ChangeAction(this.GetCurrentLayer(), newHotkey, newAction)

        ToJsonFileWriter.WriteKeyboardLayersInfoRegisterToJsonFile(this.keyboardLayersInfoRegister, this.GetPathToCurrentProfile() . "\Keyboards.json")
    }

    addHotkey(newAction){
        this.keyboardLayersInfoRegister.addHotkey(this.GetCurrentLayer(), newAction)
        ToJsonFileWriter.WriteKeyboardLayersInfoRegisterToJsonFile(this.keyboardLayersInfoRegister, this.GetPathToCurrentProfile() . "\Keyboards.json")
    }

    deleteHotkey(hotkeyKey){
        this.keyboardLayersInfoRegister.deleteHotkey(this.GetCurrentLayer(), hotkeyKey)
        

        ToJsonFileWriter.WriteKeyboardLayersInfoRegisterToJsonFile(this.keyboardLayersInfoRegister, this.GetPathToCurrentProfile() . "\Keyboards.json")
    }

    getActionGroupNames(){
        return this.actionSettings.getActionGroupNames()
    }

    getActionSettingsForActionAsArray(actionName){
        return this.actionSettings.getActionSettingsForActionAsArray(actionName)
    }

    getActionSettingsForCurrentActionAsArray(){
        return this.getActionSettingsForActionAsArray(this.GetCurrentFunction())
    }

    getActionSettingsForAction(actionName){
        return this.actionSettings.getActionSettingsForAction(actionName)
    }

    getActionSettingsForCurrentAction(){
        return this.getActionSettingsForAction(this.GetCurrentFunction())
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
        return this.keyboardLayersInfoRegister.getLayerIdentifiers()
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
