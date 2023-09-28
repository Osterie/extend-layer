#Requires AutoHotkey v2.0

Class BatteryController{

    currentBatterySaverThreshold := 50
    defaultBatterySaverThreshold := 50
    activePowerMode := ""
    powerSaverModeGUID := ""
    defaultPowerModeGUID := ""

    __New(currentBatterySaverThreshold, defaultBatterySaverThreshold){
        this.currentBatterySaverThreshold := currentBatterySaverThreshold
        this.defaultBatterySaverThreshold := defaultBatterySaverThreshold
    }

    setPowerSaverModeGUID(GUID){
        this.powerSaverModeGUID := GUID
    }
    setDefaultPowerModeGUID(GUID){
        this.defaultPowerModeGUID := GUID
    }

    ActivatePowerSaverMode(){
        this.activePowerMode := this.powerSaverModeGUID
        Run("powercfg /s " . this.powerSaverModeGUID)
    }

    ActivateNormalPowerMode(){
        this.activePowerMode := this.defaultPowerModeGUID
        Run("powercfg /s " . this.defaultPowerModeGUID)
    }

    GetActivePowerMode(){
        Return this.activePowerMode
    }

    ; Changes Power mode, if power saver mode is on, it is turned on and default is activated, and vice versa
    TogglePowerSaverMode(){
        if (this.activePowerMode == this.powerSaverModeGUID){
            this.ActivateNormalPowerMode()
        }
        else if (this.activePowerMode == this.defaultPowerModeGUID){
            this.ActivatePowerSaverMode()
        }
    }

    SetHighestBatterySaverThreshold(){
        this.currentBatterySaverThreshold := 100
        Run("powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD " . this.currentBatterySaverThreshold)
    }

    SetDefaultBatterySaverThreshold(){
        this.currentBatterySaverThreshold := this.defaultBatterySaverThreshold
        Run("powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD " . this.defaultBatterySaverThreshold)
    }

    SetLowestBatterySaverThreshold(){
        this.currentBatterySaverThreshold := 0
        Run("powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD " . this.currentBatterySaverThreshold)
    }
    
    SetCustomBatterySaverThreshold(currentBatterySaverThreshold){
        this.currentBatterySaverThreshold := currentBatterySaverThreshold
        Run("powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD " . this.currentBatterySaverThreshold)
    }

    GetBatterySaverThreshold(){
        Return this.currentBatterySaverThreshold
    }

    ; Either changes battery saver threshold to 100 or to 50 (wont go lower than 50, that is bad)
    ToggleBatterySaverMode(){
        if (this.currentBatterySaverThreshold == 50){
            ; Turns on power saver by setting it to turn on when under 100% charge
            Run("powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 100")
            this.currentBatterySaverThreshold := 100
        }
        else if (this.currentBatterySaverThreshold == 100){
            ; Returns power saver settings to default (at <= 50%)
            Run("powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 50")
            this.currentBatterySaverThreshold := 50
        }
        else{
            MsgBox("error with battery saver threshold")
        }
    }
}