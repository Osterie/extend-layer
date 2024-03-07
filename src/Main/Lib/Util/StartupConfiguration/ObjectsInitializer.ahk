#Requires Autohotkey v2.0

#Include <Util\KeyboardOverlay\KeyboardOverlay>
#Include <Util\KeyboardOverlay\KeyboardOverlayRegistry>

#Include <Actions\KeysPressedGui>
#Include <Actions\ProcessManager>
#Include <Actions\CommandPromptOpener>
#Include <Actions\IODevices\Mouse>
#Include <Actions\IODevices\Monitor>
#Include <Actions\IODevices\DeviceManager>
#Include <Actions\IODevices\ComputerInputController>
#Include <Actions\Privacy\ScreenPrivacyController>
#Include <Actions\Privacy\UnauthorizedUseDetector>
#Include <Actions\BatteryAndPower\BatteryController>
#Include <Actions\Navigation\WebNavigation\WebNavigator>
#Include <Actions\Navigation\FileNavigation\FileExplorerNavigator>
#Include <LayerControlling\LayerController>

class ObjectsInitializer{

    objects := Map()

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
        monitorSleepTimeMinutes := IniRead(FilePaths.GetPathToCurrentSettings(), "PrivacyController", "MonitorSleepTimeMinutes")
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
        powerSaverModeGUID := IniRead(FilePaths.GetPathToCurrentSettings(), "Battery", "PowerSaverModeGUID")
        defaultPowerModeGUID := IniRead(FilePaths.GetPathToCurrentSettings(), "Battery", "DefaultPowerModeGUID")
        Battery := BatteryController(50, 50)
        Battery.setPowerSaverModeGUID(powerSaverModeGUID)
        Battery.setDefaultPowerModeGUID(defaultPowerModeGUID)
        ; Battery.ActivateNormalPowerMode()
        this.Objects["Battery"] := Battery

        ; Used to search for stuff in the browser, translate, and excecute shortcues like close tabs to the right in browser
        chatGptLoadTime := IniRead(FilePaths.GetPathToCurrentSettings(), "WebNavigator", "chatGptLoadTime")
        WebSearcher := WebNavigator()
        WebSearcher.SetChatGptLoadTime(chatGptLoadTime)
        this.Objects["WebSearcher"] := WebSearcher


        UnautorizedUserDetector := UnauthorizedUseDetector()
        this.Objects["UnautorizedUserDetector"] := UnautorizedUserDetector

        lockComputerOnTaskBarClick := IniRead(FilePaths.GetPathToCurrentSettings(), "UnauthorizedUseDetector", "lockComputerOnTaskBarClick")

        if (lockComputerOnTaskBarClick = "true"){
            UnautorizedUserDetector.ActivateLockComputerOnTaskBarClick()
        }
        else{
            UnautorizedUserDetector.DisableLockComputerOnTaskBarClick()
        }

        ; |------------Layer indicators------------|

        ; Used to switch the active layer
        layers := LayerController()
        layers.addLayerIndicator(1, "Green")
        layers.addLayerIndicator(2, "Red")

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