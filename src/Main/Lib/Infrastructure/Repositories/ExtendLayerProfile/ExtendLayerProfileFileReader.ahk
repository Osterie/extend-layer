#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>
#Include <Infrastructure\Repositories\ExtendLayerProfile\HotkeyLayerMapper>
#Include <Infrastructure\Repositories\ExtendLayerProfile\KeyboardOverlayMapper>

#Include <Util\JsonParsing\JXON>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

class ExtendLayerProfileFileReader {

    ; TODO does not need to be field probably.
    ExtendLayerProfile := ExtendLayerProfile()
    
    readExtendLayerProfile(profilePath) {
        if (!FileExist(profilePath)) {
            throw ValueError("The specified profile path does not exist: " . profilePath)
        }

        HotkeyLayerMapper_ := HotkeyLayerMapper()
        KeyboardOverlayMapper_ := KeyboardOverlayMapper()

        jsonString := ""

        try {
            jsonString := FileRead(profilePath, "UTF-8")
        } catch {
            FilePaths.SetCurrentProfile("Empty")
            emptyProfilePath := FilePaths.GetPathToCurrentKeyboardLayout()
            jsonString := FileRead(emptyProfilePath, "UTF-8")
            msgbox("Unable to read information for the current profile. Defaulting to an empty profile.")
        }

        extendLayerProfileJsonObject := jxon_load(&jsonString)

        for layerIdentifier, layerInfoContents in extendLayerProfileJsonObject {
            if (InStr(layerIdentifier, "Hotkeys")) {
                HotkeyLayer_ := HotkeyLayerMapper_.Map(layerIdentifier, layerInfoContents)
                this.ExtendLayerProfile.addHotkeyLayer(HotkeyLayer_)
                ; this.readHotkeys(layerIdentifier, layerinfoContents)
            }
            else if (InStr(layerIdentifier, "KeyboardOverlay")) {
                try {
                    KeyboardOverlayLayer_ := KeyboardOverlayMapper_.Map(layerIdentifier, layerInfoContents)
                    this.ExtendLayerProfile.AddKeyboardOverlayLayerInfo(KeyboardOverlayLayer_)
                    ; this.ReadKeyboardOverlay(layerIdentifier, layerInfoContents)
                }
                catch Error as e {
                    Logger.logError("Error while reading keyboard overlay information: " . e.message)
                }
            }
            else {
                throw ("Unknown layer type: " . layerIdentifier)
            }
        }

        return this.ExtendLayerProfile
        
    }
}
