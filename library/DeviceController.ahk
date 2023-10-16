#Requires AutoHotkey v2.0

Class DeviceController{

    bluetoothActionToToggle := ""
    touchPadActionToToggle := ""
    touchScreenActionToToggle := ""
    CameraActionToToggle := ""


    UpdateDevicesActionToToggle(){

        Runwait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass -Command `"& { . '" A_ScriptDir "\powerShellScripts\get-device-states.ps1' } 1> " A_ScriptDir "\powerShellScripts\output.txt`"")
        
        ; Read the captured output from the file
        devicesActionToToggle := Fileread(A_ScriptDir "\powerShellScripts\output.txt")
    
        ; Delete the file after reading them
        FileDelete(A_ScriptDir "\powerShellScripts\output.txt")
        
        deviceActionToTogglesArray := StrSplit(devicesActionToToggle,"`n")
        
        This.BluetoothActionToToggle := deviceActionToTogglesArray[1]
        This.touchPadActionToToggle := deviceActionToTogglesArray[2]
        This.touchScreenActionToToggle := deviceActionToTogglesArray[3]
        This.CameraActionToToggle := deviceActionToTogglesArray[4]
    }

    GetBluetoothActionToToggle(){
        return this.bluetoothActionToToggle
    }

    ToggleBluetooth(){
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-bluetooth.exe")
        this.Toggle(this.bluetoothActionToToggle)
    }

    GetTouchPadActionToToggle(){
        return this.touchPadActionToToggle
    }

    ToggleTouchPad(){
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-touchpad.exe")
        this.Toggle(this.touchPadActionToToggle)
    }

    GetTouchScreenActionToToggle(){
        return this.touchScreenActionToToggle
    } 

    ToggleTouchScreen(){
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-touchscreen.exe")
        this.Toggle(this.touchScreenActionToToggle)

    }

    GetCameraActionToToggle(){
        return this.cameraActionToToggle
    }

    ToggleCamera(){
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\powerShellScripts\toggle-camera.exe")
        this.Toggle(this.cameraActionToToggle)
    }

    Toggle(Toggle){
        
        if (StrLower(Toggle) == "enable"){
            Toggle := "Disable"
        }
        else if (StrLower(Toggle) == "disable"){
            Toggle := "Enable"
        }
    }
}