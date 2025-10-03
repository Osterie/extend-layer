#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>

#Include <Infrastructure\Repositories\ExtendLayerProfileRepository>
#Include <Infrastructure\Services\ExtendLayerProfileService>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

class CurrentExtendLayerProfileManager {
    static instance := false
    Repository := ExtendLayerProfileRepository()
    Service := ExtendLayerProfileService()
    Profile := false

    __New() {
        this.load()
    }

    static getInstance() {
        if (!CurrentExtendLayerProfileManager.instance) {
            CurrentExtendLayerProfileManager.instance := CurrentExtendLayerProfileManager()
        }
        return CurrentExtendLayerProfileManager.instance
    }

    getHotkeysForLayer(layerIdentifier) {
        return this.Service.getHotkeysForLayer(this.Profile, layerIdentifier)
    }

    changeHotkey(layer, originalHotkey, newHotkey, newAction) {
        this.Service.changeHotkey(this.Profile, layer, originalHotkey, newHotkey, newAction)
    }

    addHotkey(layer, hotkeyAction) {
        this.Service.addHotkey(this.Profile, layer, hotkeyAction)
    }

    deleteHotkey(layer, hotkeyKey) {
        this.Service.deleteHotkey(this.Profile, layer, hotkeyKey)
    }

    getKeyboardOverlayLayers(){
        return this.Service.getKeyboardOverlayLayers(this.Profile)
    }

    getShowKeyboardOverlayKey(keyboardOverlayLayerName){
        return this.Service.getShowKeyboardOverlayKey(this.Profile, keyboardOverlayLayerName)
    }

    ; TODO inconsistent naming, somewhere layerName, somewhere layerIdentifier
    hasLayer(layerName) {
        return this.Service.hasLayer(this.Profile, layerName)
    }

    getLayerIdentifiers() {
        return this.Service.getLayerIdentifiers(this.Profile)
    }

    getLayerByLayerIdentifier(layerIdentifier) {
        return this.Service.getLayerByLayerIdentifier(this.Profile, layerIdentifier)
    }

    getHotkeyInfoForLayer(layerName, hotkeyKey) {
        return this.Service.getHotkeyInfoForLayer(this.Profile, layerName, hotkeyKey)
    }

    getPairValuesForLayer(layerName) {
        return this.Service.getPairValuesForLayer(this.Profile, layerName)
    }

    load() {
        currentProfileName := FilePaths.GetCurrentProfile()
        this.Profile := this.Repository.getProfile(currentProfileName)
    }
}
