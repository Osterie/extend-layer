#Requires AutoHotkey v2.0
#Include ".\Translator.ahk"
#Include "..\..\IODevices\ComputerInputController.ahk"

#Include <Actions\HotkeyAction>
#Include <Util\Sanitizers\UrlSanitizer>
#Include <Util\UrlUtils>

class WebNavigator extends HotkeyAction {

    chatGptLoadTime := 3000

    PATH_TO_IMAGE_ASSETS := A_ScriptDir . "\..\assets\imageSearchImages\"
    PATH_TO_TEST_IMAGE := this.PATH_TO_IMAGE_ASSETS . "testImage.png"

    __New() {
        if (!FileExist(this.PATH_TO_TEST_IMAGE)) {
            msgbox("WebNavigator could not find the test image at " this.PATH_TO_TEST_IMAGE)
        }
    }

    destroy() {
        ; Empty
    }

    ; Public method
    ; Closes tabs to the right of the current tab, works for chrome, firefox and edge.
    ; Uses the computer input controller to block keyboard input while the tabs are being closed.
    ; This is to prevent the user from interfering with the process.
    CloseTabsToTheRight() {

        ComputerInput := ComputerInputController()
        Sleep(100)
        ComputerInput.BlockKeyboard()

        ; Schedule an unblock fail-safe in 5 seconds
        SetTimer(this.UnblockFailSafe.Bind(this, ComputerInput), -5000)  ; negative = run once after delay

        if (WinActive("ahk_exe chrome.exe")) {
            this.closeTabsToTheRightChrome()
        }
        else if (WinActive("ahk_exe firefox.exe")) {
            this.closeTabsToTheRightFirefox()
        }
        else if (WinActive("ahk_exe msedge.exe")) {
            this.closeTabsToTheRightEdge()
        }

        ComputerInput.UnBlockKeyboard()
    }

    UnblockFailSafe(ComputerInput) {
        ComputerInput.UnBlockKeyboard()
    }

    closeTabsToTheRightChrome() {
        ; These sends could be compressed to just one, but for readability they are all seperated to each their line
        ; Focuses search bar
        Send("^l")
        Sleep(80)
        ; Focuses active tab
        Send("{F6}")
        Sleep(80)
        ; Right clicks active tab, opening a dropdown meny with actions
        Send("{AppsKey}")
        Sleep(80)
        ; Focuses the option to close tabs to the right
        Send("{Up}")
        Sleep(80)
        ; Performs said action
        Send("{Enter}")
        Sleep(80)
        ; Goes back to the body of the page
        Send("{F6}")
    }

    closeTabsToTheRightFireFox() {
        ; These sends could be compressed to just one, but for readability they are all seperated to each their line
        
        ; Focuses search bar, but it might not be possible to change focus to the active tab yet
        Send("^l")
        Sleep(80)
        
        ; Focuses main body of the browser
        Send("{F6}")
        Sleep(80)
        
        ; Focuses the search bar again, now it is possible to change focus to the active tab
        Send("{F6}")
        Sleep(80)
        
        ; Focuses active tab
        Send("+{Tab}")
        Sleep(80)
        Send("+{Tab}")
        Sleep(80)
        Send("+{Tab}")
        Sleep(80)
        Send("+{Tab}")
        Sleep(80)
        
        ; Right clicks active tab, opening a dropdown meny with actions
        Send("{AppsKey}")
        Sleep(80)
        
        ; Focuses the option to close tabs to the right
        Send("{Up}")
        Sleep(80)
        Send("{Up}")
        Sleep(80)
        Send("{Right}")
        Sleep(80)
        Send("{Down}")
        Sleep(80)
        
        ; Performs said action
        Send("{Enter}")
        Sleep(80)
        ; Goes back to the body of the page
        Send("{F6}")
    }

    closeTabsToTheRightEdge() {
        ; These sends could be compressed to just one, but for readability they are all seperated to each their line
        
        ; Focuses search bar
        Send("^l")
        Sleep(80)
        
        ; Focuses active tab
        Send("{F6}")
        Sleep(80)
        Send("{F6}")
        Sleep(80)

        ; Right clicks active tab, opening a dropdown meny with actions
        Send("{AppsKey}")
        Sleep(80)
        
        ; Focuses the option to close tabs to the right
        Send("{Up}")
        Sleep(80)
        Send("{Up}")
        Sleep(80)
        Send("{Up}")
        Sleep(80)
        Send("{Up}")
        Sleep(80)
        
        ; Performs said action
        Send("{Enter}")
        Sleep(80)
        
        ; Goes back to the body of the page
        Send("{F6}")
        Sleep(80)
        Send("{F6}")
    }

    ; Public method
    ; Images should be for example "loginButton.png"
    LoginToSite(url, images, loadTime, preferedBrowser := "") {
        this.OpenUrl(url, preferedBrowser)

        if (images = "") {
            return
        }

        Sleep(loadTime)

        loginButtonClicked := false
        timesTriedToClickLoginButton := 1
        targetSiteUrl := UrlSanitizer.sanitizeUrl(url)

        while ((timesTriedToClickLoginButton <= images.Length) && !loginButtonClicked) {
            try {
                this.ClickLoginButton(this.PATH_TO_IMAGE_ASSETS . images[timesTriedToClickLoginButton])
                ; if it reaches here, the login button is clicked
                loginButtonClicked := true

                currentSiteUrl := UrlSanitizer.sanitizeUrl(this.GetCurrentUrl())

                ; this checks if the clipboard content (which is the new site url, after logging in) is the same as the given url.
                if (!InStr(currentSiteUrl, targetSiteUrl)) {
                    this.ChangeCurrentUrl(currentSiteUrl)
                }
            }
            catch {
                Sleep(loadTime / (images.Length))
                timesTriedToClickLoginButton += 1
            }
        }
    }

    ; TODO check if a webbrowser is active perhaps.
    ; Private method.
    GetCurrentUrl() {
        Sleep(200)
        rememberedClipboardValue := A_Clipboard

        Send("!d")
        Send("^c")
        Send("{F6 2}")

        urlText := A_Clipboard
        A_Clipboard := rememberedClipboardValue

        return urlText
    }

    ChangeCurrentUrl(newUrl) {
        Send("!d")
        Send(newUrl)
        Send("{Enter}")
    }

    ; Private method
    ClickLoginButton(loginButtonImagePath) {
        ErrorLevel := !ImageSearch(&loginButtonXCoordinate, &loginButtonYCoordinate, 0, 0, A_ScreenWidth,
            A_ScreenHeight, loginButtonImagePath)
        MouseClick("left", loginButtonXCoordinate, loginButtonYCoordinate)
    }

    ; Public method
    ; Searches google for the currently highlighteded text, or the text stored in the clipboard
    LookUpHighlitedTextOrClipboardContent() {

        rememberedClipboardValue := A_Clipboard
        Send("^c")
        Sleep(100)

        this.SearchInBrowser(A_Clipboard)

        ;put the last copied thing back in the clipboard
        A_Clipboard := rememberedClipboardValue
    }

    ; Public method
    SearchFromInputBox() {
        inputBoxWebSearch := InputBox("What would you like to search for in the browser?", "Web search", "w150 h150")
        ; Only if the search is not cancelled will it search
        if (inputBoxWebSearch.Result = "Ok") {
            this.SearchInBrowser(inputBoxWebSearch.Value)
        }
    }

    ; Private method
    SearchInBrowser(searchTerm) {
        googleSearchUrl := "https://www.google.com/search?q="

        ; if the highlighted text/the text in the clipboard is a url, then the url is opened
        if (UrlUtils.isUrl(searchTerm)) {
            Run(searchTerm)
        }
        else { ;if not an url, search using google search
            joined_url := googleSearchUrl . searchTerm
            Run(joined_url)
        }
    }

    ; Public method.
    QuestionChatGpt() {
        ; saves current clipboard value to a variable
        clipboardValue := A_Clipboard
        ; saves a new value to the clipboard, if any text is highligted
        Send("^c")
        Sleep(100)

        ; Opens the chat-gpt site and then pastes the clipboard value (which could be the text which was highlighted)
        this.AskChatGpt(A_Clipboard, this.chatGptLoadTime)

        ;put the last copied thing back in the clipboard
        A_Clipboard := clipboardValue
    }

    ; Private method
    ; asks chat-gpt a question, loadTime is the estimated time the site takes to load in, in probably not the best way to do this
    AskChatGpt(question, loadTime) {
        Run("https://chat.openai.com/")
        Sleep(loadTime)
        Send(question)
        Sleep(1000)
        Send("{Enter}")
    }

    ; Public method
    ; Translates highligted text or the text in the clipboard, and then shows it in a message box
    ShowTranslatedText(fromLanguage := "auto", toLanguage := "en", &variants := "") {
        translatedText := this.TranslateHighlightedTextOrClipboard(fromLanguage, toLanguage, &variants)
        MsgBox(translatedText)
    }

    OpenUrl(url, preferedBrowser := "") {

        if (preferedBrowser != "") {
            try {
                if (!InStr(preferedBrowser, ".exe")) {
                    preferedBrowser := preferedBrowser . ".exe"
                }
                Run(preferedBrowser . " " . url)
            }
            catch Error as e {
                if (InStr(e.Message, "Failed attempt to launch program or document")) {
                    MsgBox("Failed to open the url: " url ". Please check if you have the chosen prefered browser: " preferedBrowser ", installed.")
                }
                else {
                    MsgBox("An error occurred while trying to open the url: " url ". Error: " e.Message)
                }
            }
            return
        }

        try{
            Run("chrome.exe " . url)
            return
        }
        try{
            Run("firefox.exe " . url)
            return
        }
        try{
            Run("msedge.exe " . url)
            return
        }

        MsgBox("Failed to open the url: " url ". Please check if you have any of the following browsers installed: Chrome, Edge, Firefox.")
    }

    ; Translates highligted text or the text in the clipboard
    ; if no fromLanguage is specified, then the language is automatically detected
    ; if no toLanguage is specified, then the language is translated to english
    ; if variants is not specified, only one result is returned
    TranslateHighlightedTextOrClipboard(fromLanguage := "auto", toLanguage := "en", &variants := "") {
        ; saves current clipboard value to a variable
        clipboardValue := A_Clipboard
        ; saves a new value to the clipboard, if any text is highligted
        Send("^c")
        Sleep(100)

        ; Takes a text to translate, the language to translate from, the language to translate to, and the variants of the text(optional)
        translatedText := this.TranslateText(A_Clipboard, fromLanguage, toLanguage, &variants)

        ;put the last copied thing back in the clipboard
        A_Clipboard := clipboardValue

        return translatedText
    }

    ; if no fromLanguage is specified, then the language is automatically detected
    ; if no toLanguage is specified, then the language is translated to english
    ; if variants is not specified, only one result is returned
    TranslateText(textToTranslate, fromLanguage := "auto", toLanguage := "en", &variants := "") {
        TextTranslator := Translator()

        ; Takes a text to translate, the language to translate from, the language to translate to, and the variants of the text(optional)
        translatedText := TextTranslator.Translate(textToTranslate, fromLanguage, toLanguage, &variants)
        return translatedText
    }

    SetChatGptLoadTime(loadTime) {
        this.chatGptLoadTime := loadTime
    }
}
