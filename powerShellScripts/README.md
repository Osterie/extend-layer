How to create exe file for powershell file.
Run in powershell these commands:

<!-- Use to digitally sign -->
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

<!-- Create exe file -->
Invoke-PS2EXE C:\Users\adria\github\extend-layer\powerShellScripts\toggle-bluetooth.ps1 C:\Users\adria\github\extend-layer\powerShellScripts\toggle-bluetooth.exe
