#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class ActionSettingsPopup extends DocumentationPopup {

    __New(){
        title := "Action Settings"
        header := "Action Settings Documentation"
        super.__New(title, header)

        this.createActionSettingsPopup()
        this.show()
    }

    createActionSettingsPopup() {
        aboutTitle := "About Action Settings"

        aboutParagraph := "Action settings are some settings which will change the behaviour of multiple actions. For example the action setting 'AutoClickerCps' for the 'Mouse' actions. This will changed the clicks per second of the 'Toggle auto clicker', 'Start auto clicker' and 'Stop auto clicker' actions."
        aboutParagraph .= this.NEW_LINE
        aboutParagraph .= "Currently there are no checks if the given input is valid, make sure the input you give is valid."
        aboutParagraph .= this.NEW_LINE

        futureTitle := "Future of Action Settings"
        futureParagraph := "Action settings will probably be reworked in the future, it is currently not what was envisioned. It does not just change the behaviour of multiple actions, it also changes the settings of other functionality. Here is an example: "
        futureParagraph .= this.SPACING
        futureParagraph .= "'UnautorizedUserDetector' has the 'lockComputerOnTaskBarClick' settings, which when true will lock the computer (Win+L) when the windows task bar is clicked."
        futureParagraph .= this.NEW_LINE
        futureParagraph .= "Unfortunately this is not an action setting. There are no special actions which this will affect. Therefore it should not be under action settings, in the future this will be reworked."
        
        futureParagraph .= this.SPACING
        this.section(aboutTitle, aboutParagraph)
        
        this.section(futureTitle, futureParagraph)
    }
}