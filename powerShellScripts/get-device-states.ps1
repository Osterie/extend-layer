# BLUETOOTH: Writes to terminal bluetooth state (which is interpreted in extend_extra_extreme.ahk)
If ((Get-Service bthserv).Status -eq 'Stopped') { Start-Service bthserv }
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | ? { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
Function Await($WinRtTask, $ResultType) {
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    $netTask.Wait(-1) | Out-Null
    $netTask.Result
}
[Windows.Devices.Radios.Radio,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
[Windows.Devices.Radios.RadioAccessStatus,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
Await ([Windows.Devices.Radios.Radio]::RequestAccessAsync()) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null
$radios = Await ([Windows.Devices.Radios.Radio]::GetRadiosAsync()) ([System.Collections.Generic.IReadOnlyList[Windows.Devices.Radios.Radio]])
$bluetooth = $radios | ? { $_.Kind -eq 'Bluetooth' }
[Windows.Devices.Radios.RadioState,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
if (!$BluetoothStatus) { if ($bluetooth.state -eq 'On') { $BluetoothStatus = 'Off'; Write-Output "Disable Blue  tooth"; Start-Sleep -s 1 } else { $BluetoothStatus = 'On' ; Write-Output "Enable Blue  tooth" ; Start-Sleep -s 1} }


# TOUCHPAD Writes to terminal touchpad state (which is interpreted in extend_extra_extreme.ahk)
$deviceId = 'HID\VID_044E&PID_1212&COL01&COL04\7&3B3FBA1E&0&0003'
$device   = Get-PnpDevice -InstanceId $deviceId -ErrorAction SilentlyContinue
if ($device) {
    switch ($device.Status) {
        'OK'    { Write-Output "Disable Mouse"}
        default { Write-Output "Enable Mouse"}
    }
}
else {
    Write-Warning "TOUCHPAD: Device with ID '$deviceId' not found"
}

# TOUCH-SCREEN Writes to terminal touch-screen state (which is interpreted in extend_extra_extreme.ahk)
$deviceId = 'HID\WCOM481A&COL01\5&35681C4A&1&0000'
$device   = Get-PnpDevice -InstanceId $deviceId -ErrorAction SilentlyContinue
if ($device) {
    switch ($device.Status) {
        'OK'    { Write-Output "Disable Touch-Screen";}
        default { Write-Output "Enable Touch-Screen";}
    }
}
else {
    Write-Warning "TOUCH-SCREEN: Device with ID '$deviceId' not found"
}

# CAMERA Writes to terminal camera state (which is interpreted in extend_extra_extreme.ahk)
$deviceId = 'USB\VID_05C8&PID_080B&MI_00\6&1553D1E2&0&0000'
$device   = Get-PnpDevice -InstanceId $deviceId -ErrorAction SilentlyContinue
if ($device) {
    switch ($device.Status) {
        'OK'    { Write-Output "Disable Camera";}
        default { Write-Output "Enable Camera";}
    }
}
else {
    Write-Warning "CAMERA: Device with ID '$deviceId' not found"
}