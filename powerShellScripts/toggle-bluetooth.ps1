# [CmdletBinding()] Param (
#     [Parameter()][ValidateSet('On', 'Off')][string]$BluetoothStatus
# )

# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass ; Invoke-PS2EXE C:\Users\adria\github\extend-layer\powerShellScripts\toggle-bluetooth.ps1 C:\Users\adria\github\extend-layer\powerShellScripts\toggle-bluetooth.exe


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
if (!$BluetoothStatus) { if ($bluetooth.state -eq 'On') { $BluetoothStatus = 'Off'; Write-Host "Disable bluetooth"; Start-Sleep -s 1 } else { $BluetoothStatus = 'On' ; Write-Host "Enabling bluetooth" ; Start-Sleep -s 1} }
Await ($bluetooth.SetStateAsync($BluetoothStatus)) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null