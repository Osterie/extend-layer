#Requires AutoHotkey v2.0

#Include <Infrastructure\Repositories\ExtendLayerProfileRepository>

class ExtendLayerProfileService {
    Repository := ExtendLayerProfileRepository()

    setDescription(profile, description) {
        profile.setDescription(description)
        this.Repository.save(profile, profile.getName())
    }

    getDescription(profile) {
        return profile.getDescription()
    }

    ; -------------------------------
    ; Hotkey operations
    ; -------------------------------
    changeHotkey(profile, layer, originalHotkey, newHotkey, newAction) {
        profile.changeHotkey(layer, originalHotkey, newHotkey)
        profile.changeAction(layer, newHotkey, newAction)
        this.Repository.save(profile, profile.getName())
        return profile
    }

    addHotkey(profile, layer, hotkeyAction) {
        profile.addHotkey(layer, hotkeyAction)
        this.Repository.save(profile, profile.getName())
        return profile
    }

    deleteHotkey(profile, layer, hotkeyKey) {
        profile.deleteHotkey(layer, hotkeyKey)
        this.Repository.save(profile, profile.getName())
        return profile
    }

    ; -------------------------------
    ; Accessors
    ; -------------------------------
    getLayerIdentifiers(profile) {
        return profile.getLayerIdentifiers()
    }

    getLayerByLayerIdentifier(profile, layerIdentifier) {
        return profile.getLayerByLayerIdentifier(layerIdentifier)
    }

    ; TODO change! return the class isntead of this array of pairs.
    getPairValuesForLayer(profile, layerIdentifier) {
        layer := profile.getLayerByLayerIdentifier(layerIdentifier)
        return layer.getFriendlyHotkeyActionPairValues()
    }

    ; TODO rename or change implementation
    getActionsForLayer(profile, layer) {
        HotkeyLayer := profile.getHotkeyLayerByLayerIdentifier(layer)
        return HotkeyLayer.getFriendlyHotkeyActionPairValues()
    }

    getHotkeysForLayer(profile, layerIdentifier) {
        hotkeyLayer := profile.getHotkeyLayerByLayerIdentifier(layerIdentifier)
        return hotkeyLayer.getHotkeys()
    }

    getHotkeyInfoForLayer(profile, layerIdentifier, hotkeyKey) {
        return profile.getHotkeyInfoForLayer(layerIdentifier, hotkeyKey)
    }

    hasLayer(profile, layerIdentifier) {
        return profile.hasHotkeyLayer(layerIdentifier)
    }

    ; ------------------------------------
    ; ----- Keyboard Overlay Layer -------
    ; ------------------------------------

    getKeyboardOverlayLayers(profile){
        return profile.GetKeyboardOverlayLayers()
    }

    ; TODO change name of method or what it returns! Since other getKeyboardOverlayByLayerIdentifier methods  return the KeyboardOverlayElements class, but this returns the map of elements.
    getKeyboardOverlayByLayerIdentifier(profile, layerIdentifier) {
        keyboardOverlayLayer := profile.getKeyboardOverlayByLayerIdentifier(layerIdentifier)
        return keyboardOverlayLayer.getOverlayElements()
    }

    getShowKeyboardOverlayKey(profile, layerIdentifier) {
        keyboardOverlayLayer := profile.getKeyboardOverlayByLayerIdentifier(layerIdentifier)
        return keyboardOverlayLayer.GetShowKeyboardOverlayKey()
    }
}
