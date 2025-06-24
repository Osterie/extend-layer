#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>

#Include <DataModels\KeyboardLayouts\KeyboardsInfo\HotkeyLayer\HotKeyInfo>
#Include <DataModels\KeyboardLayouts\KeyboardsInfo\HotkeyLayer\HotkeyLayer>

#Include <DataModels\KeyboardLayouts\KeyboardsInfo\KeyboardOverlayLayer\KeyboardOverlayElement>
#Include <DataModels\KeyboardLayouts\KeyboardsInfo\KeyboardOverlayLayer\KeyboardOverlayLayer>

#Include <Util\JsonParsing\JXON>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

class KeyboardLayersInfoJsonReader {

    Logger := Logger.getInstance()
    ExtendLayerProfile := ExtendLayerProfile()

    __New() {

    }

    ; TODO add a "for current profile"
    ReadKeyboardLayersInfoForCurrentProfile() {
        try {
            ; Try to read the information for the current profile.
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
        }
        catch {
            ; Unable to read information for the current profile, so we use default to an empty profile.
            FilePaths.SetCurrentProfile("Empty")
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
            msgbox("Unable to read information for the current profile. Defaulting to an empty profile.")
        }

        keyboardLayersInfo := jxon_load(&keyboardSettingsString)

        ; -----------Read JSON----------------

        ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
        for layerIdentifier, layerInfoContents in keyboardLayersInfo {
            if (InStr(layerIdentifier, "Hotkeys")) {
                this.readHotkeys(layerIdentifier, layerinfoContents)
            }
            else if (InStr(layerIdentifier, "KeyboardOverlay")) {
                try {
                    this.ReadKeyboardOverlay(layerIdentifier, layerInfoContents)
                }
                catch Error as e {
                    Logger.logError("Error while reading keyboard overlay information: " . e.message)
                }
            }
            else {
                throw ("Unknown layer type: " . layerIdentifier)
            }
        }
    }

    readHotkeys(layerIdentifier, layerInfoContents) {
        HotkeysLayer := HotkeyLayer(layerIdentifier)
        for hotkeyName, informationAboutHotkey in layerInfoContents {
            hotKeyInformation := HotKeyInfo(hotkeyName)

            if (informationAboutHotkey["isObject"]) {
                hotKeyInformation.setInfoForSpecialHotKey(informationAboutHotkey["ObjectName"], informationAboutHotkey[
                    "MethodName"], informationAboutHotkey["Parameters"])
            }
            else if (!informationAboutHotkey["isObject"]) {
                hotKeyInformation.setInfoForNormalHotKey(informationAboutHotkey["key"], informationAboutHotkey[
                    "modifiers"])
            }
            else {
                throw ("Unknown hotkey type: " . informationAboutHotkey)
            }
            HotkeysLayer.addHotkey(hotKeyInformation)
        }
        this.ExtendLayerProfile.AddHotkeyLayer(HotkeysLayer)
    }

    ReadKeyboardOverlay(layerIdentifier, layerInfoContents) {
        ShowKeyboardOverlayKey := ""
        KeyboardOverlayInformation := ""
        try {
            KeyboardOverlayInformation := KeyboardOverlayLayer(layerInfoContents["ShowKeyboardOverlayKey"],
                layerIdentifier)
        }
        catch Error as e {
            Logger.logError("Error while reading keyboard overlay information: " . e.message)
            throw ("Error while reading keyboard overlay information: " . e.message)
        }

        for key, informationAboutKey in layerInfoContents {
            if (key == "overlayElements") {

                for overlayElementName, informationAboutOverlayElement in informationAboutKey {
                    elementName := overlayElementName
                    overlayKeyToPress := informationAboutOverlayElement["key"]
                    description := informationAboutOverlayElement["description"]
                    element := KeyboardOverlayElement(elementName, overlayKeyToPress, description)
                    KeyboardOverlayInformation.addKeyboardOverlayElement(element)
                }
            }
        }

        this.ExtendLayerProfile.AddKeyboardOverlayLayerInfo(KeyboardOverlayInformation)
    }

    getExtendLayerProfile() {
        return this.ExtendLayerProfile
    }

}
