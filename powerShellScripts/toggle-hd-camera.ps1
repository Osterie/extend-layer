$deviceId = 'USB\VID_05C8&PID_080B&MI_00\6&1553D1E2&0&0000'
$device   = Get-PnpDevice -InstanceId $deviceId -ErrorAction SilentlyContinue
if ($device) {
    switch ($device.Status) {
        'OK'    { Write-Host "Disabling Camera"; Disable-PnpDevice -InstanceId $deviceId -Confirm:$false; break }
        default { Write-Host "Enabling Camera";  Enable-PnpDevice -InstanceId $deviceId -Confirm:$false }
    }
}
else {
    Write-Warning "Device with ID '$deviceId' not found"
}