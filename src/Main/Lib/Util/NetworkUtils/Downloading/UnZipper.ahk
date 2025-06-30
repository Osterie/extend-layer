#Requires AutoHotkey v2.0

; Used to unzip ZIP files.
; Read about the Shell.Application COM object: https://learn.microsoft.com/en-us/windows/win32/shell
; Read about the Folder object: https://learn.microsoft.com/en-us/windows/win32/shell/folder
class UnZipper {


    zip(folderToZip, zipLocation){
        shell := this.createShellApplication()

        zipLocation := zipLocation . (InStr(zipLocation, ".zip") ? "" : ".zip") ; Ensure the ZIP file has a .zip extension
        if !FileExist(zipLocation) {
            this.createEmptyZip(zipLocation)
        }

        toZipFolder := this.getZipFolder(shell, folderToZip)
        zipFolder := this.getZipFolder(shell, zipLocation)

        zipFolder.CopyHere(toZipFolder.Items(), 0)
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
    unzip(zipFilePath, unZipLocation, replace := false) {
        shell := this.createShellApplication()
        zipFolder := this.getZipFolder(shell, zipFilePath)
        unZipFolder := this.getUnZipFolder(shell, unZipLocation)

        ; Copy the contents of the ZIP file to the destination directory
        this.unZipFiles(zipFolder, unZipFolder, replace)
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

    unZipFiles(zipFolder, unZipFolder, replace) {
        options := this.createOptions(replace) ; Create options for the unzipping process
        unZipFolder.CopyHere(zipFolder.Items(), options) ; 4 = No progress UI
    }

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
}