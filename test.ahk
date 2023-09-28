#Requires AutoHotkey v2.0
; #Requires AutoHotkey v1.1.36.02

; Run, powercfg /s 26f0a003-088e-4bde-aa26-fbf318774ca0,,Hide ;switch to high performance - GUID needs replaced
; Turns on power saver by setting it to turn on when under 100% charge
test := 100
test2 := 20
; Run("powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD " . this.defaultBatterySaverThreshold)
; Run("powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 40")
; Returns power saver settings to default (at <= 50%)
; Run, powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 50

msgbox(run("powercfg /GETACTIVESCHEME"))
