#Requires AutoHotkey v2.0

#Include <ui\util\DomainSpecificGuiScrollable>


class DocumentationPopup extends DomainSpecificGuiScrollable {


    __New(title := "") {
        super.__New("", title)
    }

    show(){
        ; super.show("w640 h360")
        super.show("w640 h480")
    }
}