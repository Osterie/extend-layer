#Requires AutoHotkey v2.0

class Image {

    __New(guiToAddTo, imagePath, options := "") {
        if !FileExist(imagePath) {
            imagePath := FilePaths.IMG_NOT_FOUND
        }
        guiToAddTo.Add("Picture", options, imagePath)
    }
}