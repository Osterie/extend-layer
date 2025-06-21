#Requires Autohotkey v2.0

#Include <Actions\LayerControlling\LayerController>
#Include <Actions\KeyboardOverlay\KeyboardOverlay>
#Include <Actions\KeyboardOverlay\KeyboardOverlayRegistry>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\IniFileReader>

#Include <Actions\KeysPressedDisplay\KeysPressedGui>
#Include <Actions\ProcessManager>
#Include <Actions\CommandPromptOpener>
#Include <Actions\IODevices\Mouse>
#Include <Actions\IODevices\Monitor>
#Include <Actions\IODevices\DeviceManager>
#Include <Actions\IODevices\ComputerInputController>
#Include <Actions\AppControllers\SoundController>
#Include <Actions\Privacy\ScreenPrivacyController>
#Include <Actions\Privacy\UnauthorizedUseDetector>
#Include <Actions\BatteryAndPower\BatteryController>
#Include <Actions\Navigation\WebNavigation\WebNavigator>
#Include <Actions\Navigation\FileNavigation\FileExplorerNavigator>
#Include <Shared\FilePaths>

class ObjectsInitializer{

    objects := Map()
    IniFileReader := IniFileReader()

    InitializeObjects(){
    
        ; Used to control mouse actions, and disable/enable mouse
        MouseInstance := Mouse(true)
        this.Objects["MouseInstance"] := MouseInstance

        KeyboardInstance := Keyboard()
        this.Objects["KeyboardInstance"] := KeyboardInstance

        ProcessManagerInstance := ProcessManager()
        this.Objects["ProcessManagerInstance"] := ProcessManagerInstance

        ; Allows opening cmd pathed to the current file location for vs code and file explorer.
        CommandPrompt := CommandPromptOpener()
        this.Objects["CommandPrompt"] := CommandPrompt


        ; Allows navigating the file explorer and opening the file explorer pathed to a given file location
        FileExplorer := FileExplorerNavigator()
        this.Objects["FileExplorer"] := FileExplorer


        ; Allows to write on the screen in a textarea
        OnScreenWriter := KeysPressedGui()
        OnScreenWriter.CreateGUI()
        this.Objects["OnScreenWriter"] := OnScreenWriter


        ; Enables / disables input (mouse or keyboard)
        ComputerInput := ComputerInputController()
        this.Objects["ComputerInput"] := ComputerInput


        ; Used to hide screen and parts of the screen
        PrivacyController := ScreenPrivacyController()
        PrivacyController.CreateGui()
        ; TODO move the ini reads to the class
        ; Sets the countdown for the screen hider to 3 minutes. (change to your screen sleep time)
        ; This shows a countdown on the screen, and when it reaches 0, the screen goes to sleep
        monitorSleepTimeMinutes := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "PrivacyController", "MonitorSleepTimeMinutes", "5")
        PrivacyController.ChangeCountdown(monitorSleepTimeMinutes,0)
        this.Objects["PrivacyController"] := PrivacyController

        ; Used to get the states of devices, like if bluetooth and such is enabled, also able to disable/enable these devices
        DeviceManipulator := DeviceManager()
        ; launches a powershell script which gets the states of some devices, like if the mouse is enabled.
        ; Having this activated will slow down the startup of the script significantly.
        ; !DeviceManipulator.UpdateDevicesActionToToggle()
        this.Objects["DeviceManipulator"] := DeviceManipulator


        ; Used to change brightness and gamma settings of the monitor
        MonitorInstance := Monitor()
        this.Objects["MonitorInstance"] := MonitorInstance

        ; Used to switch between power saver mode and normal power mode (does not work as expected currently, percentage to switch to power saver is changed, but power saver is never turned on...)
        powerSaverModeGUID := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Battery", "PowerSaverModeGUID", '"7ac15103-7e10-499d-b365-9647e042cde2"')
        defaultPowerModeGUID := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Battery", "DefaultPowerModeGUID", '"8759706d-706b-4c22-b2ec-f91e1ef6ed38"')
        Battery := BatteryController(50, 50)
        Battery.setPowerSaverModeGUID(powerSaverModeGUID)
        Battery.setDefaultPowerModeGUID(defaultPowerModeGUID)
        ; Battery.ActivateNormalPowerMode()
        this.Objects["Battery"] := Battery

        ; Used to search for stuff in the browser, translate, and excecute shortcues like close tabs to the right in browser
        chatGptLoadTime := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "WebNavigator", "chatGptLoadTime", "3000")
        WebSearcher := WebNavigator()
        WebSearcher.SetChatGptLoadTime(chatGptLoadTime)
        this.Objects["WebSearcher"] := WebSearcher


        UnautorizedUserDetector := UnauthorizedUseDetector()
        this.Objects["UnautorizedUserDetector"] := UnautorizedUserDetector

        lockComputerOnTaskBarClick := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "UnauthorizedUseDetector", "lockComputerOnTaskBarClick", "false")

        if (lockComputerOnTaskBarClick = "true"){
            UnautorizedUserDetector.ActivateLockComputerOnTaskBarClick()
        }
        else{
            UnautorizedUserDetector.DisableLockComputerOnTaskBarClick()
        }

        SoundController_ := SoundController()
        this.Objects["SoundController_"] := SoundController_

        ; |------------Layer indicators------------|

        ; Used to switch the active layer
        ; TODO dont do it like this!?

        showLayerIndicatorOnAllMonitors := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Layer", "ShowLayerIndicatorOnAllMonitors", "0")
        
        layerPositionMode := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Layer", "LayerPositionMode", "0")
        
        layers := LayerController(showLayerIndicatorOnAllMonitors, layerPositionMode)

        
        layer1Color := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Layer", "LayerIndicatorColor1", '"Green"')
        layer2Color := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Layer", "LayerIndicatorColor2", '"Red"')
        
        layer1Transparent := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Layer", "LayerIndicatorTransparent1", "0")
        layer2Transparent := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Layer", "LayerIndicatorTransparent2", "0")

        layer1Image := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Layer", "LayerIndicatorImage1", "NONE")
        layer2Image := this.IniFileReader.ReadOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Layer", "LayerIndicatorImage2", "NONE")
        
        layers.addLayerIndicator(1, layer1Color, layer1Transparent, layer1Image)
        layers.addLayerIndicator(2,  layer2Color, layer2Transparent, layer2Image)

        this.Objects["layers"] := layers

        this.InitializeObjectsForKeyboardOverlays()
    }

    InitializeObjectsForKeyboardOverlays(){
        
        ; |---------------------------------|
        ; |-------Keyboard Overlays---------|
        ; |---------------------------------|

        ; |----------Main layer------------|

        ; TODO this is shit...

        ; Shows an on screen overlay for the main keyboard layer which shows which urls can be went to using the number keys
        SecondaryLayerKeyboardOverlay1 := KeyboardOverlay()
        SecondaryLayerKeyboardOverlay1.CreateGui()
        this.Objects["SecondaryLayerKeyboardOverlay1"] := SecondaryLayerKeyboardOverlay1

        ; Shows an on screen overlay for the SecondaryLayer keyboard layer which shows which file explorer paths can be went to using the number keys
        SecondaryLayerKeyboardOverlay2 := KeyboardOverlay()
        SecondaryLayerKeyboardOverlay2.CreateGui()
        this.Objects["SecondaryLayerKeyboardOverlay2"] := SecondaryLayerKeyboardOverlay2

        ; |----------Second layer-----------|

        ; Shows an on screen overlay for the main keyboard layer which shows which number keys to press to enable/disable devices
        TertiaryLayerKeyboardOverlay1 := KeyboardOverlay()
        TertiaryLayerKeyboardOverlay1.CreateGui()

        ; |---------Overlay registry--------|

        OverlayRegistry := KeyboardOverlayRegistry()
        OverlayRegistry.addKeyboardOverlay(TertiaryLayerKeyboardOverlay1, "TertiaryLayerKeyboardOverlay1")
        this.Objects["OverlayRegistry"] := OverlayRegistry
    }

    GetObjects(){
        return this.objects
    }
}