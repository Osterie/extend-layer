#Requires AutoHotkey v2.0

#Include <ui\util\components\Paragraph>
#Include <ui\util\components\Section>
#Include <ui\util\components\Image>

#Include <ui\util\DomainSpecificGuiScrollable>

class DocumentationPopup extends DomainSpecificGuiScrollable {

    NEW_LINE := "`n"
    SPACING := "`n`n"
    TAB := "`t"
    
    GUI_WIDTH := 640
    GUI_HEIGHT := 480

    __New(title := "", header := "") {
        super.__New("", title)
        this.createHeader(header)
    }

    createHeader(header := ""){
        if (header = ""){
            return
        }
        this.SetFont("s16 Bold")
        this.Add("Text", "", header)
        this.SetFont("s10")
    }

    paragraph(content, width := this.getSectionWidth()){
        Paragraph(this, width, content)
    }

    section(title, paragraph, width := this.getSectionWidth()){
        Section(this, width, title, paragraph)
    }

    image(imageName, options := ""){
        DocumentationImage(this, imageName, options)
    }

    show(){
        super.show("w" . this.GUI_WIDTH . " h" . this.GUI_HEIGHT)
    }

    getSectionWidth(){
        return this.GUI_WIDTH - this.MarginX*3
    }
}