#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>
#Include <ui\util\components\Image>

class DocumentationImage extends Image {

    __New(guiToAddTo, documentationImage, options := "") {
        imagePath := FilePaths.ASSETS_DOCUMENTATION_IMAGES . "\" . documentationImage
        super.__New(guiToAddTo, imagePath, options)
    }
}