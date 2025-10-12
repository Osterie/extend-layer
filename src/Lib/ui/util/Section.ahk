#Requires AutoHotkey v2.0

class Section {
    title := ""
    content := ""

    __New(guiToAddTo, title, content, width := "") {
        this.title := title
        this.content := content

        style1 := "0x40000"
        style2 := "0x400000"
        style3 := "0x800000"
        ; style := ""

        guiToAddTo.SetFont("s14")
        guiToAddTo.Add("Text", style3 . " xp " . width, "Border 3 " . this.title)
        guiToAddTo.SetFont("s12")
        
        guiToAddTo.Add("Text", style3 . " xp " . width, "DIALOG BOX BORDER: " . this.content)
    }
}