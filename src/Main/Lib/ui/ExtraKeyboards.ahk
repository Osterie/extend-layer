#Requires AutoHotkey v2.0

#Include <Infrastructure\IO\IniFileReader>
#Include <Shared\FilePaths>
#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotKeyInfo>

#Include <Infrastructure\Repositories\ActionSettingsRepository>
#Include <Infrastructure\Repositories\ExtendLayerProfile\ExtendLayerProfileRepository>

class ExtraKeyboards {

    currentLayer := ""
    currentFunction := ""

    ; TODO make other classes use this repository instead of the ExtraKeyboards class.
    ActionSettingsRepository := ActionSettingsRepository()

    actionSettings := ""

    __New() {
        this.actionSettings := this.ActionSettingsRepository.getActionGroupSettingsRegistry()
    }

    ; TODO repository should do this!

    changeHotkey(originalHotkey, newHotkey, newAction) {
        ExtendLayerProfileRepository.getInstance().changeHotkey(this.GetCurrentLayer(), originalHotkey, newHotkey, newAction)
    }

    addHotkey(hotkeyAction) {
        ExtendLayerProfileRepository.getInstance().addHotkey(this.GetCurrentLayer(), hotkeyAction)
    }

    deleteHotkey(hotkeyKey) {
        ExtendLayerProfileRepository.getInstance().deleteHotkey(this.GetCurrentLayer(), hotkeyKey)
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
        return ExtendLayerProfileRepository.getInstance().GetActionsForLayer(this.currentLayer)
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
        return ExtendLayerProfileRepository.getInstance().getLayerIdentifiers()
    }

    GetCurrentLayerInfo() {
        return ExtendLayerProfileRepository.getInstance().GetRegistryByLayerIdentifier(this.currentLayer)
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

    ; This creates a copy of the HotkeyInfo instead of returning a reference to the original object.
    ; This is done to prevent the caller from modifying the original object.
    GetHotkeyInfoForCurrentLayer(hotkeyKey) {
        hotkeyInformation := ExtendLayerProfileRepository.getInstance().getExtendLayerProfile().GetHotkeyInfoForLayer(this.GetCurrentLayer(), hotkeyKey)

        ; Layers := ExtendLayerProfileRepository.getInstance().getExtendLayerProfile().GetRegistryByLayerIdentifier(this.GetCurrentLayer())

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
    ;     itemsToShowForListView := ExtendLayerProfileRepository.getInstance().getExtendLayerProfile().GetRegistryByLayerIdentifier(layerIdentifier)
    ;     hotkeysForLayer := itemsToShowForListView.getFriendlyHotkeyActionPairValues()

    ;     return hotkeysForLayer
    ; }
}
