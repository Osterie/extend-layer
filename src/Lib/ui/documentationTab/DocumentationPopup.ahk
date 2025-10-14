#Requires AutoHotkey v2.0

#Include <ui\util\DomainSpecificGuiScrollable>


class DocumentationPopup extends DomainSpecificGuiScrollable {

    NEW_LINE := "`n"
    GUI_WIDTH := 640
    GUI_HEIGHT := 480

    __New(title := "") {
        super.__New("", title)
    }

    show(){
        super.show("w" . this.GUI_WIDTH . " h" . this.GUI_HEIGHT)
    }
}