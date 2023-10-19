#Requires AutoHotkey v2.0


; TODO fixme, should have better pathing to scrips, perhaps giving the path to the scripts as a parameter to the class
; TODO ini file should probably contain paths to the scripts which control the devices
; TODO maybe possible to create a class which can run powershell scripts, which can be created by the user (perhaps uploaded by the user) and which they have to add the path to in the ini file or something (dont have to have path, only name i guesss.)


Class DeviceController{

    bluetoothActionToToggle := ""
    touchPadActionToToggle := ""
    touchScreenActionToToggle := ""
    CameraActionToToggle := ""


    UpdateDevicesActionToToggle(){

        Runwait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass -Command `"& { . '" A_ScriptDir "\scripts\get-device-states.ps1' } 1> " A_ScriptDir "\scripts\output.txt`"")
        
        ; Read the captured output from the file
        devicesActionToToggle := Fileread(A_ScriptDir "\scripts\output.txt")
    
        ; Delete the file after reading them
        FileDelete(A_ScriptDir "\scripts\output.txt")
        
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
        ; msgbox( A_ScriptDir . "..\scripts\toggle-touchpad.exe")
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\..\scripts\toggle-bluetooth.exe")
        this.Toggle(this.bluetoothActionToToggle)
    }

    GetTouchPadActionToToggle(){
        return this.touchPadActionToToggle
    }

    ToggleTouchPad(){
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\..\scripts\toggle-touchpad.exe")
        this.Toggle(this.touchPadActionToToggle)
    }

    GetTouchScreenActionToToggle(){
        return this.touchScreenActionToToggle
    } 

    ToggleTouchScreen(){
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\..\scripts\toggle-touchscreen.exe")
        this.Toggle(this.touchScreenActionToToggle)

    }

    GetCameraActionToToggle(){
        return this.cameraActionToToggle
    }

    ToggleCamera(){
        RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass " A_ScriptDir "\..\scripts\toggle-camera.exe")
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