#Requires AutoHotkey v2.0

#Include <Infrastructure\IO\ExtendLayerProfileFileReader>

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

    ; -------------------------------
    ; ----- Changing Hotkeys --------
    ; -------------------------------


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

    ; ------------------------------------
    ; ------- Extend Layer Profile -------
    ; ------------------------------------

    getExtendLayerProfile() {
        return this.ExtendLayerProfile
    }

    getLayerIdentifiers() {
        ExtendLayerProfile := this.getExtendLayerProfile()
        layerIdentifiers := ExtendLayerProfile.GetLayerIdentifiers()
        return layerIdentifiers
    }

    getLayerByLayerIdentifier(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        return ExtendLayerProfile.getLayerByLayerIdentifier(layerIdentifier)
    }

    ; TODO change! return the class isntead of this array of pairs.
    getPairValuesForLayer(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        keyboardOverlayLayer := ExtendLayerProfile.getLayerByLayerIdentifier(layerIdentifier)
        keyboardOverlayElements := keyboardOverlayLayer.getFriendlyHotkeyActionPairValues()
        return keyboardOverlayElements
    }

    ; ------------------------------------
    ; ----- Keyboard Overlay Layer -------
    ; ------------------------------------

    GetKeyboardOverlayLayers(){
        ExtendLayerProfile := this.getExtendLayerProfile()
        return ExtendLayerProfile.GetKeyboardOverlayLayers()
    }

    ; TODO change name of method or what it returns! Since other getKeyboardOverlayByLayerIdentifier methods  return the KeyboardOverlayElements class, but this returns the map of elements.
    getKeyboardOverlayByLayerIdentifier(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        keyboardOverlayLayer := ExtendLayerProfile.getKeyboardOverlayByLayerIdentifier(layerIdentifier)
        eyboardOverlayElements := keyboardOverlayLayer.getOverlayElements()

        return eyboardOverlayElements
    }

    getShowKeyboardOverlayKey(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        keyboardOverlayLayer := ExtendLayerProfile.getKeyboardOverlayByLayerIdentifier(layerIdentifier)
        showKeyboardOverlayKey := keyboardOverlayLayer.GetShowKeyboardOverlayKey()
        return showKeyboardOverlayKey
    }


    ; ------------------------------------
    ; ---------- Hotkey Layer ------------
    ; ------------------------------------

    ; TODO rename or change implementation
    GetActionsForLayer(layer) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        HotkeyLayer := ExtendLayerProfile.getHotkeyLayerByLayerIdentifier(layer)
        hotkeysForLayer := HotkeyLayer.getFriendlyHotkeyActionPairValues()
        return hotkeysForLayer
    }

    getHotkeysForLayer(layerIdentifier) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        currentKeyboardLayerInformation := ExtendLayerProfile.getHotkeyLayerByLayerIdentifier(layerIdentifier)
        currentKeyboardLayerHotkeys := currentKeyboardLayerInformation.GetHotkeys()
        return currentKeyboardLayerHotkeys
    }

    getHotkeyInfoForLayer(layerIdentifier, hotkeyKey) {
        ExtendLayerProfile := this.getExtendLayerProfile()
        HotkeyInfo := ExtendLayerProfile.GetHotkeyInfoForLayer(layerIdentifier, hotkeyKey)
        return HotkeyInfo
    }

    ; ---------------------------------------------
    ; ----- Read from file / write to file --------
    ; ---------------------------------------------

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
