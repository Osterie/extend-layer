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
        keyboardShortcutParagraph := "You can select this menu item by pressing 'Alt' and then pressing 'T' (the underlined character). Use the arrow keys to navigate to the theme you want, and press Enter to select it."

        aboutTitle := "About Themes"
        aboutParagraph := "There are three theme categories. Colorful, which contains vibrant themes. Dark, which has dark themes, and Light which has light themes. Choosing a theme applies it to the main GUI, popups and dialogs. Theme changes are not bound to the current profile, the theme will be used for all profiles."
        
        recommendedThemeTitle := "Recommended Theme"
        recommendedThemeParagraph := "For best readability use the Dark->Defaul theme, but use whatever theme you want. I just made them cause it was fun."


        Section(this, sectionWidth, keyboardShortcutTitle, keyboardShortcutParagraph)
        Section(this, sectionWidth, aboutTitle, aboutParagraph)
        Section(this, sectionWidth, recommendedThemeTitle, recommendedThemeParagraph)
    }
}