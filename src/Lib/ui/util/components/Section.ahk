#Requires AutoHotkey v2.0

#Include <Shared\Logger>
#Include <ui\util\components\Paragraph>

class Section {

    Logger := Logger.getInstance()

    __New(guiToAddTo, width, title, content) {
        this.addTitle(guiToAddTo, width, title)
        Paragraph(guiToAddTo, width, content)
    }

    addTitle(guiToAddTo, width, title) {
        yMarginOfGui := guiToAddTo.MarginY

        guiToAddTo.MarginY := 10
        guiToAddTo.SetFont("s14 Bold")
        titleControl := guiToAddTo.Add("Text", "w" . width, title)

        guiToAddTo.MarginY := yMarginOfGui
    }
}