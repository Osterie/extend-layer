#Requires AutoHotkey v2.0

; TODO move inifilereader to meta info reading

; #Include <JsonParsing\JXON\JXON>
#Include <FoldersAndFiles\IniFileReader>

#Include "Main\Functionality\ActionSettings\SettingsEditor.ahk"

#Include "Main\ProfileEditing\ProfileButtons.ahk"
#Include "Main\ProfileEditing\ProfileRegionModel.ahk"
#Include "Main\ProfileEditing\ProfileRegionView.ahk"
#Include "Main\ProfileEditing\ProfileRegionController.ahk"
#Include "Main\util\TreeViewMaker.ahk"
#Include "Main\util\ListViewMaker.ahk"
#Include "Main\Functionality\Keyboard\KeyboardEditing\HotKeyConfigurationPopup.ahk"
#Include "Main\util\GuiColorsChanger.ahk"

#Include "<MetaInfo\MetaInfoStorage\Files\FilePaths>"

#Include <FoldersAndFiles\FolderManager>
#Include <JsonParsing\JsonFormatter\JsonFormatter>

; TODO have a hotkey which sends a given key(or hotkey) after a given delay.
; TODO could also have a hotkey/key which is excecuted if a loud enough sound is caught by the mic.

; TODO make it possible for the user to add own ahk scripts to the program, and then use them as functions. 

Class ExtraKeyboardsAppGuiModel{


    keyboardLayerIdentifiers := ""
    activeObjectsRegistry := ""
    keyboardLayersInfoRegister := ""

    MainScript := ""

    currentLayer := ""

    keyNames := ""

    pathToObjectsIniFile := ""


    __New(keyboardLayerIdentifiers, activeObjectsRegistry, keyboardLayersInfoRegister, MainScript, keyNames){
        this.MainScript := MainScript
        
        this.keyNames := keyNames
        
        this.activeObjectsRegistry := activeObjectsRegistry
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister
        this.keyboardLayerIdentifiers := keyboardLayerIdentifiers

    }

    GetFunctionNames(){
        pathToObjectsIniFile := this.GetPathToCurrentSettings()

        fileReader := IniFileReader()
        functionsNames := []
        try{
            functionsNames := fileReader.ReadSectionNamesToArray(pathToObjectsIniFile)
        }
        catch{
            functionName := []
        }
        
        return functionsNames
    }

    GetSettingsForFunction(functionName){
        iniFileRead := IniFileReader()
        currentSettingsSettingValuePair := iniFileRead.ReadSectionKeyPairValuesIntoTwoDimensionalArray(this.GetPathToCurrentSettings(), functionName)
        return currentSettingsSettingValuePair
    }

    GetFriendlyHotkeysForLayer(layerIdentifier){
        itemsToShowForListView := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(layerIdentifier)
        hotkeysForLayer := itemsToShowForListView.getFriendlyHotkeyActionPairValues()

        return hotkeysForLayer
    }

    GetFriendlyHotkeysForCurrentLayer(){
        itemsToShowForListView := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.currentLayer)
        hotkeysForLayer := itemsToShowForListView.getFriendlyHotkeyActionPairValues()

        return hotkeysForLayer
    }

    SetCurrentLayer(layerIdentifier){
        this.currentLayer := layerIdentifier
    }

    GetCurrentLayer(){
        return this.currentLayer
    }

    GetKeyboardLayerIdentifiers(){
        return this.keyboardLayerIdentifiers
    }

    GetCurrentLayerInfo(){
        return this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.currentLayer)
    }

    GetActiveObjectsRegistry(){
        return this.activeObjectsRegistry
    }

    GetKeyNames(){
        return this.keyNames
    }

    ChangeFunctionSetting(settingName, settingValue, currentFunctionSettings){
        try{
            IniWrite(settingValue, this.GetPathToCurrentSettings(), currentFunctionSettings, settingName)
        }
        catch{
            MsgBox("Failed to save settings")
        }
    }

    GetPathToCurrentSettings(){
        return FilePaths.GetPathToCurrentSettings()
    }

}
