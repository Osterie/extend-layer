#Requires AutoHotkey v2.0

class Section {

    __New(guiToAddTo, width, title, content) {
        this.addTitle(guiToAddTo, width, title)
        this.addParagraph(guiToAddTo, width, content)
    }

    addTitle(guiToAddTo, width, title) {
        yMarginOfGui := guiToAddTo.MarginY

        guiToAddTo.MarginY := 10
        guiToAddTo.SetFont("s14 Bold")
        titleControl := guiToAddTo.Add("Text", "w" . width, title)

        guiToAddTo.MarginY := yMarginOfGui
    }

    addParagraph(guiToAddTo, width, content) {
        yMarginOfGui := guiToAddTo.MarginY

        guiToAddTo.MarginY := -6
        guiToAddTo.SetFont("s12 Norm")
        paragraph := guiToAddTo.Add("Text", "w" . width, content)

        guiToAddTo.MarginY := yMarginOfGui
    }
}