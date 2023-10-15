#Requires AutoHotkey v2.0

Class CommandPromptOpener{

    defaultPath := ""

    __New(defaultPath){
        this.defaultPath := defaultPath
    }

    ; public method
    OpenCmdPathedToCurrentLocation(){

        if ( WinActive("ahk_class CabinetWClass") ){
            this.OpenCmdFileExplorer()
        }
        else if( WinActive("ahk_exe Code.exe") ){
            this.OpenCmdFromVisualStudioCode()
        }
        else{
            run("cmd", this.defaultPath)
        }
    }

    OpenCmdFileExplorer(){
        try{
            run("cmd", WinGetTitle("A"))
        }
        catch{
            run("cmd", this.defaultPath)
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
        run("cmd", pathToCurrentWorkFile)
        ;put the last copied thing back in the clipboard
        A_Clipboard := clipboardValue 
    }

    SetDefaultPath(defaultPath){
        this.defaultPath := defaultPath
    }

    GetDefaultPath(){
        return this.defaultPath
    }
}

