#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class LaunchingTheScriptPopup extends DocumentationPopup {

    __New(){
        title := "Launching the Script"
        header := "Launching the Script Documentation"
        super.__New(title, header)

        this.createLaunchingTheScriptPopup()
        this.show()
    }

    createLaunchingTheScriptPopup() {
        whereToFindTitle := "Where to Find"
        whereToFindParagraph := "The scripts talked about in this section can be found in the file location where you put Extend Layer."
        whereToFindParagraph .= this.NEW_LINE
        
        whereToFindParagraph .= "- Run_this.ahk"
            whereToFindParagraph .= this.NEW_LINE
            whereToFindParagraph .= this.TAB
            whereToFindParagraph .= "Found in the root of the Extend Layer files"
        
        whereToFindParagraph .= this.NEW_LINE

        whereToFindParagraph .= "- controlScript.ahk"
            whereToFindParagraph .= this.NEW_LINE
            whereToFindParagraph .= this.TAB
            whereToFindParagraph .= "Found in src/controlScript.ahk"


        runThisTitle := "Run_this.ahk"
        runThisParagraph := "Running this script starts Extend Layer. You must have ahk v2 installed for this to work. Double click Run_this.ahk to run it."
        
        controlScriptTitle := "controlScript.ahk"
        controlScriptParagraph := "controlScript.ahk creates a shortcut which starts Extend Layer. This means you can easily launch or relaunch Extend Layer."

        controlScriptParagraph .= this.NEW_LINE
        controlScriptParagraph .= "- Ctrl + Alt + L"
            controlScriptParagraph .= this.NEW_LINE
            controlScriptParagraph .= this.TAB
            controlScriptParagraph .= "This shortcut launches Extend Layer."

            controlScriptParagraph .= this.NEW_LINE
            controlScriptParagraph .= this.TAB
            controlScriptParagraph .= "The previous instance of Extend Layer will be closed."
        
        controlScriptParagraph .= this.NEW_LINE

        controlScriptParagraph .= "- Ctrl + Alt + Esc"
            controlScriptParagraph .= this.NEW_LINE
            controlScriptParagraph .= this.TAB
            controlScriptParagraph .= "Exits the control script."

        controlScriptParagraph .= this.SPACING

        this.section(whereToFindTitle, whereToFindParagraph)
        this.section(runThisTitle, runThisParagraph)
        this.section(controlScriptTitle, controlScriptParagraph)

    }
}
