#Requires AutoHotkey v2.0

class OverlayElement{

    elementName := ""
    key := ""
    description := ""

    __New(elementName, key, description){
        this.elementName = elementName
        this.key = key
        this.description = description
    }

    getElementName(){
        return this.elementName
    }


}