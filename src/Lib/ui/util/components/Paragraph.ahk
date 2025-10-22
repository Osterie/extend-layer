#Requires AutoHotkey v2.0

#Include <Shared\Logger>

class Paragraph {

    Logger := Logger.getInstance()

    __New(guiToAddTo, width, content) {
        this.addParagraph(guiToAddTo, width, content)
    }

    addParagraph(guiToAddTo, width, content) {
        yMarginOfGui := guiToAddTo.MarginY

        guiToAddTo.MarginY := -6
        guiToAddTo.SetFont("s12 Norm")
        paragraph := guiToAddTo.Add("Text", "w" . width, content)

        guiToAddTo.MarginY := yMarginOfGui

        lastCharacter := SubStr(content, -1, 1)
        if (lastCharacter != "." && lastCharacter != '`n'){
            this.Logger.logWarning("Section paragraph has missing period:" . SubStr(content, 1, 30) . "..." . " Last character was: " . lastCharacter )
        }
    }
}