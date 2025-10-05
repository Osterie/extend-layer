#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotKeyInfo>

#Include <Infrastructure\Repositories\ActionSettingsRepository>
#Include <Infrastructure\CurrentExtendLayerProfileManager>

class ExtraKeyboards {

    currentLayer := ""
    currentFunction := ""

    MainScript := ""

    ActionSettingsRepository := ActionSettingsRepository()

    __New(MainScript) {
        if (Type(MainScript) != "Main") {
            throw TypeError("MainScript must be an instance of Main class")
        }
        this.MainScript := MainScript
    }

    changeHotkey(originalHotkey, newHotkey, newAction) {
        ; Disable hotkeys for all layers to prevent conflicts when adding a new hotkey.
        this.MainScript.setHotkeysForAllLayers(false)
        ; Change the hotkey in storage.
        CurrentExtendLayerProfileManager.getInstance().changeHotkey(this.getCurrentLayer(), originalHotkey, newHotkey, newAction)
        ; Enable hotkeys for all layers again, now with the new hotkey included.
        this.MainScript.restartProfile()
    }

    addHotkey(hotkeyAction) {
        ; ; Disable hotkeys for all layers to prevent conflicts when adding a new hotkey.
        ; this.MainScript.setHotkeysForAllLayers(false)
        ; Add the new hotkey to storage.
        CurrentExtendLayerProfileManager.getInstance().addHotkey(this.getCurrentLayer(), hotkeyAction)
        ; Enable hotkeys for all layers again, now with the new hotkey included.
        this.MainScript.restartProfile()
    }

    deleteHotkey(hotkeyKey) {
        ; Disable hotkeys for all layers. Which ensures the old hotkey is disabled.
        this.MainScript.setHotkeysForAllLayers(false)

        ; Delete the hotkey from storage.
        CurrentExtendLayerProfileManager.getInstance().deleteHotkey(this.getCurrentLayer(), hotkeyKey)

        ; Enable hotkeys for all layers again, now without the deleted hotkey.
        this.MainScript.restartProfile()
    }

    getActionGroupNames() {
        return this.ActionSettingsRepository.getActionGroupNames()
    }

    getActionSettingsForCurrentActionAsArray() {
        return this.ActionSettingsRepository.getActionSettingsForActionAsArray(this.GetCurrentFunction())
    }

    getActionSettingsForCurrentAction() {
        return this.ActionSettingsRepository.getActionSettingsForAction(this.GetCurrentFunction())
    }

    GetFriendlyHotkeysForCurrentLayer() {
        return CurrentExtendLayerProfileManager.getInstance().getPairValuesForLayer(this.currentLayer)
    }

    SetCurrentLayer(layerIdentifier) {
        this.currentLayer := layerIdentifier
    }

    getCurrentLayer() {
        return this.currentLayer
    }

    SetCurrentFunction(functionName) {
        this.currentFunction := functionName
    }

    GetCurrentFunction() {
        return this.currentFunction
    }

    GetKeyboardLayerIdentifiers() {
        return CurrentExtendLayerProfileManager.getInstance().getLayerIdentifiers()
    }

    GetCurrentLayerInfo() {
        return CurrentExtendLayerProfileManager.getInstance().getLayerByLayerIdentifier(this.currentLayer)
    }

    changeActionSetting(actionName, ActionSetting) {
        this.ActionSettingsRepository.ChangeActionSetting(actionName, ActionSetting)
        this.MainScript.restartProfile()
    }

    ; This creates a copy of the HotkeyInfo instead of returning a reference to the original object.
    ; This is done to prevent the caller from modifying the original object.
    GetHotkeyInfoForCurrentLayer(hotkeyKey) {
        hotkeyInformation := CurrentExtendLayerProfileManager.getInstance().getHotkeyInfoForLayer(this.getCurrentLayer(), hotkeyKey)


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
}
