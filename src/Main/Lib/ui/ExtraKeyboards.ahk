#Requires AutoHotkey v2.0

#Include <Infrastructure\IO\IniFileReader>
#Include <Shared\FilePaths>
#Include <Util\MetaInfo\MetaInfoWriting\ToJsonFileWriter>
#Include <DataModels\KeyboardLayouts\KeyboardsInfo\HotkeyLayer\HotKeyInfo>

#Include <Infrastructure\Repositories\ActionSettingsRepository>
#Include <Infrastructure\Repositories\ExtendLayerProfile\ExtendLayerProfileRepository>

class ExtraKeyboards {

    currentLayer := ""
    currentFunction := ""

    keyboardLayersInfoRegister := ""
    ActionSettingsRepository := ActionSettingsRepository()

    actionSettings := ""

    __New() {
        this.actionSettings := this.ActionSettingsRepository.getActionGroupSettingsRegistry()
        this.keyboardLayersInfoRegister := ExtendLayerProfileRepository.getInstance().getExtendLayerProfile()
    }

    ; TODO repository should do this!

    changeHotkey(originalHotkey, newHotkey, newAction) {
        this.keyboardLayersInfoRegister.changeHotkey(this.GetCurrentLayer(), originalHotkey, newHotkey)
        this.keyboardLayersInfoRegister.ChangeAction(this.GetCurrentLayer(), newHotkey, newAction)

        ToJsonFileWriter.WriteKeyboardLayersInfoRegisterToJsonFile(this.keyboardLayersInfoRegister, this.GetPathToCurrentProfile() .
        "\Keyboards.json")
    }

    addHotkey(newAction) {
        this.keyboardLayersInfoRegister.addHotkey(this.GetCurrentLayer(), newAction)
        ToJsonFileWriter.WriteKeyboardLayersInfoRegisterToJsonFile(this.keyboardLayersInfoRegister, this.GetPathToCurrentProfile() .
        "\Keyboards.json")
    }

    deleteHotkey(hotkeyKey) {
        this.keyboardLayersInfoRegister.deleteHotkey(this.GetCurrentLayer(), hotkeyKey)

        ToJsonFileWriter.WriteKeyboardLayersInfoRegisterToJsonFile(this.keyboardLayersInfoRegister, this.GetPathToCurrentProfile() .
        "\Keyboards.json")
    }

    getActionGroupNames() {
        return this.actionSettings.getActionGroupNames()
    }

    getActionSettingsForActionAsArray(actionName) {
        return this.actionSettings.getActionSettingsForActionAsArray(actionName)
    }

    getActionSettingsForCurrentActionAsArray() {
        return this.getActionSettingsForActionAsArray(this.GetCurrentFunction())
    }

    getActionSettingsForAction(actionName) {
        return this.actionSettings.getActionSettingsForAction(actionName)
    }

    getActionSettingsForCurrentAction() {
        return this.getActionSettingsForAction(this.GetCurrentFunction())
    }

    GetFriendlyHotkeysForCurrentLayer() {
        itemsToShowForListView := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.currentLayer)
        hotkeysForLayer := itemsToShowForListView.getFriendlyHotkeyActionPairValues()

        return hotkeysForLayer
    }

    SetCurrentLayer(layerIdentifier) {
        this.currentLayer := layerIdentifier
    }

    GetCurrentLayer() {
        return this.currentLayer
    }

    SetCurrentFunction(functionName) {
        this.currentFunction := functionName
    }

    GetCurrentFunction() {
        return this.currentFunction
    }

    GetKeyboardLayerIdentifiers() {
        return this.keyboardLayersInfoRegister.getLayerIdentifiers()
    }

    GetCurrentLayerInfo() {
        return this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.currentLayer)
    }

    ChangeFunctionSetting(setting, actionName) {
        this.actionSettings.ChangeActionSetting(actionName, this.GetPathToCurrentSettings(), setting)
    }

    GetPathToCurrentSettings() {
        return FilePaths.GetPathToCurrentSettings()
    }

    GetPathToCurrentProfile() {
        return FilePaths.GetPathToCurrentProfile()
    }

    GetHotkeyInfoForCurrentLayer(hotkeyKey) {
        hotkeyInformation := this.keyboardLayersInfoRegister.GetHotkeyInfoForLayer(this.GetCurrentLayer(), hotkeyKey)
        hotkeyToReturn := HotkeyInfo(hotkeyInformation.getHotkeyName())

        if (hotkeyInformation.hotkeyIsObject()) {
            hotkeyToReturn.setInfoForSpecialHotKey(hotkeyInformation.getObjectName(), hotkeyInformation.getActionName(),
            hotkeyInformation.getparameters())
        }
        else {
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
