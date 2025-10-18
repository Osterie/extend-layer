#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class MenuBarThemesPopup extends DocumentationPopup {

    __New(){
        title := "Themes"
        header := "Themes Documentation"
        super.__New(title, header)

        this.createMenuBarThemesPopup()
        this.show()
    }

    createMenuBarThemesPopup() {
        sectionWidth := this.getSectionWidth()

        keyboardShortcutTitle := "Keyboard Navigation"
        keyboardShortcutParagraph := "You can select this menu item by pressing 'Alt' and then pressing 'T' (the underlined character). Then navigate with the arrow keys to the theme you want to select and hit enter."

        aboutTitle := "About Themes"
        aboutParagraph := "There are three theme categories. Colorful, which contains themes with a lot of color. Dark, which has dark themes, and Light which has light themes."
        
        recommendedThemeTitle := "Recommended Theme"
        recommendedThemeParagraph := "Text will probably be easiest to read if you use the Dark->Defaul theme, but use whatever theme you want. I just made them cause it was fun."


        Section(this, sectionWidth, keyboardShortcutTitle, keyboardShortcutParagraph)
        Section(this, sectionWidth, aboutTitle, aboutParagraph)
        Section(this, sectionWidth, recommendedThemeTitle, recommendedThemeParagraph)
    }
}