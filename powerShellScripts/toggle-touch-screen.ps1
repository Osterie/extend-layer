$deviceId = 'HID\WCOM481A&COL01\5&35681C4A&1&0000'
$device   = Get-PnpDevice -InstanceId $deviceId -ErrorAction SilentlyContinue
if ($device) {
    switch ($device.Status) {
        'OK'    { Write-Host "Disabling Touch-Screen"; Disable-PnpDevice -InstanceId $deviceId -Confirm:$false; break }
        default { Write-Host "Enabling Touch-Screen";  Enable-PnpDevice -InstanceId $deviceId -Confirm:$false }
    }
}
else {
    Write-Warning "Device with ID '$deviceId' not found"
}