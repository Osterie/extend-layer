# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass ; Invoke-PS2EXE C:\Users\adria\github\extend-layer\powerShellScripts\toggle-touchpad.ps1 C:\Users\adria\github\extend-layer\powerShellScripts\toggle-touchpad.exe

$deviceId = 'HID\VID_044E&PID_1212&COL01&COL04\7&3B3FBA1E&0&0003'
$device   = Get-PnpDevice -InstanceId $deviceId -ErrorAction SilentlyContinue
if ($device) {
    switch ($device.Status) {
        'OK'    { Write-Host "Disabling Mouse"; Start-Sleep -s 1; Disable-PnpDevice -InstanceId $deviceId -Confirm:$false; break }
        default { Write-Host "Enabling Mouse"; Start-Sleep -s 1; Enable-PnpDevice -InstanceId $deviceId -Confirm:$false }
    }
}
else {
    Write-Warning "Device with ID '$deviceId' not found"
}