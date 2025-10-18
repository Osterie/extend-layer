#Requires AutoHotkey v2.0

#Include <Util\FilePath>

class Image {

    __New(guiToAddTo, imagePath, options := "") {
        if !FileExist(imagePath) {
            imagePath := FilePaths.IMG_NOT_FOUND
        }

        path := FilePath(imagePath)
        if (path.getExtension() != "png"){
            if (!InStr(options, "AltSubmit")){
                options .= " AltSubmit"
            }
        }

        guiToAddTo.Add("Picture", options, imagePath)
    }
}