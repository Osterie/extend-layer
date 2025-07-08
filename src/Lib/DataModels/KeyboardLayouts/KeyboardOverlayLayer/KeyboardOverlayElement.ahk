#Requires AutoHotkey v2.0

; TODO does not need elementName, should always be same as key. Remove elemenetName!
class KeyboardOverlayElement {

    elementName := ""
    key := ""
    description := ""

    ; Example names:
    ; elementName := "Column1". Displays "Columns"
    ; key := "1"
    ; description := "Open Google Chrome"
    __New(elementName, key, description) {
        this.elementName := elementName
        this.key := key
        this.description := description
    }

    getElementName() {
        return this.elementName
    }
    getKey() {
        return this.key
    }
    getDescription() {
        return this.description
    }

    toJson() {
        jsonObject := Map()
        jsonObject["elementName"] := this.elementName
        jsonObject["key"] := this.key
        jsonObject["description"] := this.description
        return jsonObject
    }

    static fromJson(jsonObject) {
        if (jsonObject = "") {
            return ""
        }
        elementName := jsonObject["elementName"]
        key := jsonObject["key"]
        description := jsonObject["description"]
        return KeyboardOverlayElement(elementName, key, description)
    }
}
