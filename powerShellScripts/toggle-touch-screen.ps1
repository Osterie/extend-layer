# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass ; Invoke-PS2EXE C:\Users\adria\github\extend-layer\powerShellScripts\toggle-touch-screen.ps1 C:\Users\adria\github\extend-layer\powerShellScripts\toggle-touch-screen.exe

$deviceId = 'HID\WCOM481A&COL01\5&35681C4A&1&0000'
$device   = Get-PnpDevice -InstanceId $deviceId -ErrorAction SilentlyContinue
if ($device) {
    switch ($device.Status) {
        'OK'    { Write-Host "Disabling Touch-Screen"; Start-Sleep -s 1; Disable-PnpDevice -InstanceId $deviceId -Confirm:$false; break }
        default { Write-Host "Enabling Touch-Screen";  Start-Sleep -s 1; Enable-PnpDevice -InstanceId $deviceId -Confirm:$false }
    }
}
else {
    Write-Warning "Device with ID '$deviceId' not found"
}