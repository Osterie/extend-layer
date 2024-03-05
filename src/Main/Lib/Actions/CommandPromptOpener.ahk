#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>

Class CommandPromptOpener{

    defaultPath := ""

    __New(){
        this.SetDefaultPathFromFile()
    }

    ; public method
    ; Works with vscode, and file explorer
    OpenCmdPathedToCurrentLocation(){
        try{
            if ( WinActive("ahk_class CabinetWClass") ){ ;File explorer
                this.OpenCmdFileExplorer()
            }
            else if( WinActive("ahk_exe Code.exe") ){ ;Vscode
                this.OpenCmdFromVisualStudioCode()
            }
            else{
                this.OpenToDefaultPath()
            }
        }
        catch{
            msgbox("Error opening command prompt to current location...", "Notify")
        }
    }

    OpenCmdFileExplorer(){
        try{
            run("cmd", WinGetTitle("A"))
        }
        catch{
            this.OpenToDefaultPath()
        }
    }

    OpenCmdFromVisualStudioCode(){
        ; Save the current clipboard value
        clipboardValue := A_Clipboard

        ; This is a shortcut in visual studio code which copies the path to the currently opened file.
        Send("+!c")
    
        ; Finds the last backslash in the absolute path, because that is how pathing in the command propmt works, cant go to a specific file, only a folder.
        lastBackSlashPosition := InStr(A_Clipboard, "\",, -1, -1)
        ; The absolute path to the folder of the currently open file.
        pathToCurrentWorkFile := SubStr(A_Clipboard, 1, lastBackSlashPosition)
        ; Opens command prompt in the found path.
        try{
            run("cmd", pathToCurrentWorkFile)
        }
        catch{
            this.OpenToDefaultPath()
        }
        ;put the last copied thing back in the clipboard
        A_Clipboard := clipboardValue 
    }

    OpenToDefaultPath(){
        try{
            run("cmd", this.defaultPath)
        }
        catch{
            msgbox("Error opening command prompt the given default path, perhaps it does not exist. `nThe default path you gave was: " . this.GetDefaultPath(), "Notify")
        }
    }

    SetDefaultPathFromFile(){
        try{
            commandPromptDefaultPath := IniRead(FilePaths.GetPathToCurrentSettings(), "CommandPrompt", "DefaultPath")
            this.SetDefaultPath(commandPromptDefaultPath)
        }
        catch{
            msgbox("Error reading the default path from the settings file for Command Prompt Opener.", "Notify")
        }
    }

    SetDefaultPath(defaultPath){
        this.defaultPath := defaultPath
    }

    GetDefaultPath(){
        return this.defaultPath
    }
}

