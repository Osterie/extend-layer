#Requires AutoHotkey v2.0

class KeyboardOverlayElement{

    elementName := ""
    key := ""
    description := ""

    __New(elementName, key, description){
        this.elementName := elementName
        this.key := key
        this.description := description
        ; this.elementName := "Column1"
        ; this.key := "1"
        ; this.description := "Open Google Chrome"
    }

    getElementName(){
        return this.elementName
    }
    getKey(){
        return this.key
    }
    getDescription(){
        return this.description
    }
}