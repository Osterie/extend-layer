#Requires AutoHotkey v2.0

#Include <Infrastructure\Repositories\ExtendLayerProfile\ExtendLayerProfileFileReader>

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>

#Include <DataModels\KeyboardLayouts\KeyboardsInfo\HotkeyLayer\HotKeyInfo>
#Include <DataModels\KeyboardLayouts\KeyboardsInfo\HotkeyLayer\HotkeyLayer>

#Include <DataModels\KeyboardLayouts\KeyboardsInfo\KeyboardOverlayLayer\KeyboardOverlayElement>
#Include <DataModels\KeyboardLayouts\KeyboardsInfo\KeyboardOverlayLayer\KeyboardOverlayLayer>

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

    getExtendLayerProfile() {
        return this.ExtendLayerProfile
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

    getHotkeysForLayer(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        currentKeyboardLayerInformation := ExtendLayerProfile.GetRegistryByLayerIdentifier(layerIdentifier)
        currentKeyboardLayerHotkeys := currentKeyboardLayerInformation.GetHotkeys()
        return currentKeyboardLayerHotkeys
    }

    load() {
        currentProfilePath := FilePaths.GetPathToCurrentKeyboardLayout()
        this.ExtendLayerProfile := this.ExtendLayerProfileFileReader.readExtendLayerProfile(currentProfilePath)
    }
}
