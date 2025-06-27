#Requires AutoHotkey v2.0

#Include <Infrastructure\Repositories\ExtendLayerProfile\ExtendLayerProfileFileReader>

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>

#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotKeyInfo>
#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotkeyLayer>

#Include <DataModels\KeyboardLayouts\KeyboardOverlayLayer\KeyboardOverlayElement>
#Include <DataModels\KeyboardLayouts\KeyboardOverlayLayer\KeyboardOverlayLayer>

#Include <Util\JsonParsing\JXON>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

; TODO make singleton and read current profile on initialization.
class ExtendLayerProfileRepository {

    static instance := false
    Logger := Logger.getInstance()
    ExtendLayerProfile := ExtendLayerProfile()
    ExtendLayerProfileFileReader := ExtendLayerProfileFileReader()

    __New() {
        this.load()
    }

    static getInstance() {
        if (ExtendLayerProfileRepository.instance = false) {
            ExtendLayerProfileRepository.instance := true
            ExtendLayerProfileRepository.instance := ExtendLayerProfileRepository()
        }
        return ExtendLayerProfileRepository.instance
    }

    changeHotkey(layer, originalHotkey, newHotkey, newAction) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        ExtendLayerProfile.changeHotkey(layer, originalHotkey, newHotkey)
        ExtendLayerProfile.ChangeAction(layer, newHotkey, newAction)

        this.save(ExtendLayerProfile)
    }

    addHotkey(layer, hotkeyAction) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        ExtendLayerProfile.addHotkey(layer, hotkeyAction)

        this.save(ExtendLayerProfile)
    }

    deleteHotkey(layer, hotkeyKey) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        ExtendLayerProfile.deleteHotkey(layer, hotkeyKey)

        this.save(ExtendLayerProfile)
    }

    GetActionsForLayer(layer) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        HotkeyLayer := ExtendLayerProfile.GetRegistryByLayerIdentifier(layer)
        hotkeysForLayer := HotkeyLayer.getFriendlyHotkeyActionPairValues()
        return hotkeysForLayer
    }

    getExtendLayerProfile() {
        return this.ExtendLayerProfile
    }

    getLayerIdentifiers() {
        ExtendLayerProfile := this.getExtendLayerProfile()
        layerIdentifiers := ExtendLayerProfile.GetLayerIdentifiers()
        return layerIdentifiers
    }

    getKeyboardOverlays(){
        ExtendLayerProfile := this.getExtendLayerProfile()
        currentKeyboardOverlays := ExtendLayerProfile.GetKeyboardOverlays()

        return currentKeyboardOverlays
    }

    getShowKeyboardOverlayKey(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        currentKeyboardOverlayInformation := ExtendLayerProfile.getKeyboardOverlayByLayerIdentifier(layerIdentifier)
        showKeyboardOverlayKey := currentKeyboardOverlayInformation.GetShowKeyboardOverlayKey()
        return showKeyboardOverlayKey
    }

    getKeyboardOverlayByLayerIdentifier(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        currentKeyboardOverlayInformation := ExtendLayerProfile.getKeyboardOverlayByLayerIdentifier(layerIdentifier)
        currentKeyboardOverlayElements := currentKeyboardOverlayInformation.getOverlayElements()

        return currentKeyboardOverlayElements
    }

    getRegistryByLayerIdentifier(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        currentKeyboardLayerInformation := ExtendLayerProfile.GetRegistryByLayerIdentifier(layerIdentifier)
        return currentKeyboardLayerInformation
    }

    getHotkeysForLayer(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        currentKeyboardLayerInformation := ExtendLayerProfile.GetRegistryByLayerIdentifier(layerIdentifier)
        currentKeyboardLayerHotkeys := currentKeyboardLayerInformation.GetHotkeys()
        return currentKeyboardLayerHotkeys
    }

    getHotkeyInfoForLayer(layerIdentifier, hotkeyKey) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        HotkeyInfo := ExtendLayerProfile.GetHotkeyInfoForLayer(layerIdentifier, hotkeyKey)
        return HotkeyInfo
    }

    load() {
        currentProfilePath := FilePaths.GetPathToCurrentKeyboardLayout()
        this.ExtendLayerProfile := this.ExtendLayerProfileFileReader.readExtendLayerProfile(currentProfilePath)
    }

    save(ExtendLayerProfile) {
        if (Type(ExtendLayerProfile) != "ExtendLayerProfile") {
            this.Logger.logError("The ExtendLayerProfile must be an instance of ExtendLayerProfile.")
            throw TypeError("The ExtendLayerProfile must be an instance of ExtendLayerProfile.")
        }
        currentProfilePath := FilePaths.GetPathToCurrentKeyboardLayout()
        this.ExtendLayerProfileFileReader.writeExtendLayerProfile(ExtendLayerProfile, currentProfilePath)
    }
}
