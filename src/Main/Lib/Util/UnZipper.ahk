#Requires AutoHotkey v2.0

class UnZipper{
 
    Unzip(zipFilePath, destDir) {
        shell := ComObject("Shell.Application")
        zip := shell.NameSpace(zipFilePath)
        if (!zip){
            throw Error("Invalid ZIP file: " zipFilePath)
        }

        DirCreate(destDir) ; Ensure the destination directory exists
        ; https://learn.microsoft.com/en-us/windows/win32/shell/shell-namespace
        ; Folder object used by the Shell.Application to represent a folder
        folder := shell.NameSpace(destDir)

        ; Copy the contents of the ZIP file to the destination directory
        folder.CopyHere(zip.Items(), 4) ; 4 = No progress UI
        
        ; https://learn.microsoft.com/en-us/windows/win32/shell/folder-copyhere

        ; Wait a bit to ensure it completes before processing files
        Sleep 1000


        ; {
        ; FileCreateDir, %destDir%
        ; psh  := ComObjCreate("Shell.Application")
        ; psh.Namespace( destDir ).CopyHere( psh.Namespace( zipFilePath ).items, 4|16 )
	    ; }
    }
}