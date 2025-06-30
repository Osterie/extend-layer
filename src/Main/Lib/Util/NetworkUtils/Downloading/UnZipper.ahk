#Requires AutoHotkey v2.0

; Used to unzip ZIP files.
; Read about the Shell.Application COM object: https://learn.microsoft.com/en-us/windows/win32/shell
; Read about the Folder object: https://learn.microsoft.com/en-us/windows/win32/shell/folder
class UnZipper {


    zip(folderToZip, zipLocation, waitForCompletion := true) {
        shell := this.createShellApplication()

        zipLocation := zipLocation . (InStr(zipLocation, ".zip") ? "" : ".zip") ; Ensure the ZIP file has a .zip extension
        if !FileExist(zipLocation) {
            this.createEmptyZip(zipLocation)
        }

        toZipFolder := this.getZipFolder(shell, folderToZip)
        zipFolder := this.getZipFolder(shell, zipLocation)

        zipFolder.CopyHere(toZipFolder.Items(), 0)
        
        if (waitForCompletion) {
            this.waitForCopyCompletion(zipLocation)
            Sleep(1000) ; Give some time for the operation to complete
        }
    }

    createEmptyZip(zipFilePath) {
        bytes := Buffer(18, 0) ; Create a buffer of 18 bytes initialized to zero
        File := FileOpen(zipFilePath, "w")
        File.Write(Chr(80) . Chr(75) . Chr(5) . Chr(6))
        File.RawWrite(bytes) ; Write 18 bytes of zeroes after the EOCD signature
        File.Close()
    }

 
    ; Unzips a ZIP file to the specified destination directory.
    ; zipFilePath: The path to the ZIP file to unzip.
    ; unZipLocation: The path to the destination directory where the contents will be extracted.
    ; replace: If true, it will allow replacing existing files in the destination directory.
    unzip(zipFilePath, unZipLocation, replace := false, waitForCompletion := true) {
        shell := this.createShellApplication()
        zipFolder := this.getZipFolder(shell, zipFilePath)
        unZipFolder := this.getUnZipFolder(shell, unZipLocation)

        options := this.createOptions(replace) ; Create options for the unzipping process
        unZipFolder.CopyHere(zipFolder.Items(), options) ; 4 = No progress UI

        if (waitForCompletion){
            this.waitForCopyCompletion(unZipLocation)
            Sleep(1000) ; Give some time for the operation to complete
        }
    }

    ; Creates a Shell.Application COM object.
    createShellApplication() {
        return ComObject("Shell.Application")
    }

    getZipFolder(shell, zipFilePath) {
        ; Get the folder object for the ZIP file
        zipFilePath := this.getFullPathName(zipFilePath) ; Ensure the path is fully qualified
        zipFolder := shell.NameSpace(zipFilePath)
        if (!zipFolder) {
            throw Error("Failed to get folder object for ZIP file: " zipFilePath . "`n")
        }
        return zipFolder
    }

    getUnZipFolder(shell, unZipLocation) {
        unZipLocation := this.getFullPathName(unZipLocation) ; Ensure the path is fully qualified

        if (!DirExist(unZipLocation)) {
            DirCreate(unZipLocation) ; Ensure the destination directory exists
        }
        
        ; Folder object used by the Shell.Application to represent a folder
        unZipFolder := shell.NameSpace(unZipLocation)
        if (!unZipFolder) {
            throw Error("Failed to get folder object for destination directory: " unZipLocation)
        }

        return unZipFolder
    }

    ; unZipFiles(zipFolder, unZipFolder, replace, waitForCompletion) {
    ;     options := this.createOptions(replace) ; Create options for the unzipping process
    ;     unZipFolder.CopyHere(zipFolder.Items(), options) ; 4 = No progress UI

    ;     if (waitForCompletion){
    ;         this.waitForCopyCompletion(unZipFolder)
    ;         Sleep(1000) ; Give some time for the operation to complete
    ;     }
    ; }

    createOptions(replace) {
        noProgressDialogBox := 4
        yesToAllDisplayedDialogBoxes := 16

        options := noProgressDialogBox 

        if (replace) {
            options += yesToAllDisplayedDialogBoxes ; Allow replacing existing files without prompting
        }
        
        return options
    }

    ; TODO move to utility class
    getFullPathName(path) {
        cc := DllCall("GetFullPathNameW", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
        buf := Buffer(cc*2)
        DllCall("GetFullPathNameW", "str", path, "uint", cc, "ptr", buf, "ptr", 0, "uint")
        return StrGet(buf)
    }

    waitForCopyCompletion(destination, timeoutMs := 10000, pollInterval := 200) {
        startTime := A_TickCount
        prevCount := -1

        Loop {
            fileCount := this.countFiles(destination)

            if (fileCount == prevCount) {
                break ; File count hasn't changed — assume copy is done
            }

            prevCount := fileCount

            Sleep pollInterval
            if ((A_TickCount - startTime) > timeoutMs) {
                MsgBox "Warning: Copy may not have completed in time."
                break
            }
        }
    }

    countFiles(path) {
        count := 0
        Loop Files, path . "\*", "FRD" ; Include Files, Recurse, Dirs
            count++
        return count
    }

}