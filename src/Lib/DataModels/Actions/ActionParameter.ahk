#Requires AutoHotkey v2.0

class ActionParameter {
    ; A parameter has a name, a type and a description.

    name := ""
    type := ""
    description := ""

    __New(name, type, description) {
        this.name := name
        this.type := type
        this.description := description
    }

    getName() {
        return this.name
    }

    getType() {
        return this.type
    }

    getDescription() {
        return this.description
    }
}
