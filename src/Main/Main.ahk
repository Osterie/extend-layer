; AUTHOR: Adrian Gjøsund Bjørge
; Github: https://github.com/Osterie

; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
#Requires Autohotkey v2.0

#Include "<UserInterface\ExtraKeyboardsApp>"
#Include <Util\StartupConfiguration\ObjectsInitializer>




#Include <Util\StartupConfiguration\MainStartupConfigurator>
#Include <Util\MetaInfo\MetaInfoReading\ObjectsJsonReader>
#Include <Util\MetaInfo\MetaInfoReading\KeyboardLayersInfoJsonReader>
#Include <Util\MetaInfo\MetaInfoReading\KeyNamesReader>


#Include <Util\MetaInfo\MetaInfoStorage\Objects\ObjectRegistry>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>

#Include <Util\JsonParsing\JXON\JXON>

; |--------------------------------------------------|
; |------------------- OPTIMIZATIONS ----------------|
; |--------------------------------------------------|

#SingleInstance Force ; skips the dialog box and replaces the old instance automatically
A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
KeyHistory 100
ListLines(False)
SetKeyDelay(-1, -1)
SetMouseDelay(-1)
SetDefaultMouseSpeed(0)
SetWinDelay(-1)
SetControlDelay(-1)
SetWorkingDir(A_ScriptDir)
ProcessSetPriority "High"
; Not changing SendMode defaults it to "input", which makes hotkeys super mega terrible (super)
SendMode "Event"

; |----------------------------------------------------------|
; |---------------- Runs AHK script as Admin ----------------|
; |----------- Allows Excecuting Powershell Scripts ---------|
; |----- Also makes it possible to run powercfg and such ----|
; |----------------------------------------------------------|

; if (not A_IsAdmin){
;     ; "*RunAs*" is an option for the Run() function to run a program as admin
; 	Run("*RunAs `"" A_ScriptFullPath "`"") 
; }

; ------------Global or whatever stusff----------------


Class Main{

    keyboardSettingsJsonObject := ""

    ; TODO objects and objectRegister are very similiar in some ways. Objects is ONLY used to create objectregister...
    Objects := Map()
    ObjectRegister := ObjectRegistry()
    KeyboardLayersInfoRegister := KeyboardLayersInfoRegistry()
    StartupConfigurator := ""
    app := ""

    keyboardLayerIdentifiers := []

    keyNames := ""

    __New(){


    }

    ; Main method used to start the script.
    Start(){
        try{
            this.RunLogicalStartup()
            this.RunAppGui()
        }
        catch ValueError as e{
            this.ReadObjectsInformationFromJson()
            this.RunAppGui()
        }
    }

    RunLogicalStartup(){
        this.UpdatePathsToInfo()
        this.InitializeMetaInfo()
        this.RunMainStartup()
    }

    UpdatePathsToInfo(){
        try{
            ; Try to read the information for the current profile.
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
            this.keyboardSettingsJsonObject := jxon_load(&keyboardSettingsString)
        }
        catch{
            ; Unable to read information for the current profile, so we use default to an empty profile.
            FilePaths.SetCurrentProfile("Empty")
            keyboardSettingsString := FileRead(FilePaths.GetPathToCurrentKeyboardLayout(), "UTF-8")
            this.keyboardSettingsJsonObject := jxon_load(&keyboardSettingsString)
        }
    }

    InitializeMetaInfo(){
        this.InitializeObjects()
        this.ReadObjectsInformationFromJson()
        this.ReadKeyboardLayersInfoFromJson()
        this.ReadKeyNamesFromTxtFile()
    }

    RunMainStartup(enableHotkeys := true){
        this.InitializeMainStartupConfigurator()
        this.ReadAndMakeKeyboardOverlays()
        this.InitializeHotkeysForAllLayers(enableHotkeys)
    }

    InitializeMainStartupConfigurator(){
        ; This is used to read ini files, and create hotkeys from them
        this.StartupConfigurator := MainStartupConfigurator(this.keyboardSettingsJsonObject, this.ObjectRegister)
    }
    
    ReadAndMakeKeyboardOverlays(){
        ; Reads and initializes all keyboard overlays, based on how they are created in the ini file
        this.StartupConfigurator.ReadAllKeyboardOverlays()
    }

    InitializeHotkeysForAllLayers(enableHotkeys := true){
        this.StartupConfigurator.CreateGlobalHotkeysForAllKeyboardOverlays()
        this.StartupConfigurator.ReadKeysToNewActionsBySection("GlobalLayer", enableHotkeys)
        
        layers := this.getLayerController()
        HotIf "MainScript.getLayerController().getActiveLayer() == 0"
            ; Reads and initializes all the hotkeys for the normal keyboard layer, based on how they are created in the ini file
            this.StartupConfigurator.ReadKeysToNewActionsBySection("NormalLayer", enableHotkeys)
        HotIf
        
        HotIf "MainScript.getLayerController().getActiveLayer() == 1"
            this.StartupConfigurator.ReadKeysToNewActionsBySection("SecondaryLayer", enableHotkeys)
        HotIf
        
        HotIf "MainScript.getLayerController().getActiveLayer() == 2"
            this.StartupConfigurator.ReadKeysToNewActionsBySection("TertiaryLayer", enableHotkeys)
        HotIf

    }

    InitializeObjects(){

        initializerForObjects := ObjectsInitializer()
        initializerForObjects.InitializeObjects()
        this.Objects := initializerForObjects.GetObjects()
    }

    ReadObjectsInformationFromJson(){
        JsonReaderForObjects := ObjectsJsonReader(FilePaths.GetObjectInfo(), this.Objects)
        this.ObjectRegister := JsonReaderForObjects.ReadObjectsFromJson()
    }

    ReadKeyboardLayersInfoFromJson(){
        JsonReaderForKeyboardLayersInfo := KeyboardLayersInfoJsonReader(FilePaths.GetPathToCurrentKeyboardLayout())
        JsonReaderForKeyboardLayersInfo.ReadKeyboardLayersInfoFromJson()
        this.KeyboardLayersInfoRegister := JsonReaderForKeyboardLayersInfo.getKeyboardLayersInfoRegister()
        this.keyboardLayerIdentifiers := this.KeyboardLayersInfoRegister.getLayerIdentifiers()
    }

    ReadKeyNamesFromTxtFile(){
        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(FilePaths.GetPathToKeyNames(), "rw" , "UTF-8")
        this.keyNames := keyNamesFileObjReader.ReadKeyNamesFromTextFileObject(fileObjectOfKeyNames).GetKeyNames()

    }

    RunAppGui(){
        this.app := ExtraKeyboardsApp(this.keyboardLayerIdentifiers, this.ObjectRegister, this.KeyboardLayersInfoRegister, this, this.keyNames)
        this.app.Start()
    }

    getStartupConfigurator(){
        return this.StartupConfigurator
    }

    getLayerController(){
        return this.ObjectRegister.GetObjectInfo("layers").GetObjectInstance()
    }
}


#SuspendExempt
^!s::Suspend  ; Ctrl+Alt+S
#SuspendExempt False

MainScript := Main()
MainScript.Start()

#HotIf MainScript.getLayerController().getActiveLayer() == 0

#HotIf

#HotIf MainScript.getLayerController().getActiveLayer() == 1
#HotIf

#HotIf MainScript.getLayerController().getActiveLayer() == 2 
    ; ; Shows key history, used for debugging
    ; b:: KeyHistory
#HotIf

; Used to show user the script is enabled
ToolTip "Script enabled!"
SetTimer () => ToolTip(), -3000
