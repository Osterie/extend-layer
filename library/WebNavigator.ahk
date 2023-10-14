#Requires AutoHotkey v2.0
#Include ".\Translator.ahk"
#Include ".\ComputerInputController.ahk"

Class WebNavigator{

    ; Public method
    ; Closes tabs to the right of the current tab, only works in chrome ATM
    CloseTabsToTheRight(*){

        ComputerInput := ComputerInputController()
        Sleep(500)
        ComputerInput.BlockKeyboard()
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

        ComputerInput.UnBlockKeyboard()
    }

    LoginToSite(url, loginButtonImagePaths, loadTime, loginRedirect){

        loginButtonClicked := false
        index := 1

        this.OpenUrl(url)
        Sleep(loadTime)
        
        while ( (index <= loginButtonImagePaths.Length) && !loginButtonClicked ){
            try{
                this.ClickLoginButton(loginButtonImagePaths[index])
                loginButtonClicked := true

                if(loginRedirect){
                    Sleep(loadTime/2)
                    Send("^l")
                    Send(url)
                    Send("{Enter}")
                }
            }
            catch{
                index += 1
            }
        }
    }

    ClickLoginButton(loginButtonImagePath){

        ErrorLevel := !ImageSearch(&loginButtonXCoordinate, &loginButtonYCoordinate, 0, 0, A_ScreenWidth, A_ScreenHeight, A_ScriptDir loginButtonImagePath)
        if (ErrorLevel = 1){
            ; Icon could not be found on the screen.
        }
        else{
            MouseClick("left", loginButtonXCoordinate, loginButtonYCoordinate)
        }
    }

    ; Searches google for the currently highlighteded text, or the text stored in the clipboard
    LookUpHighlitedTextOrClipboardContent(){
        
        rememberedClipboardValue := A_Clipboard
        Send("^c")

        this.SearchInBrowser(A_Clipboard)
        
        ;put the last copied thing back in the clipboard
        A_Clipboard := rememberedClipboardValue
    }

    SearchInBrowser(searchTerm){
        googleSearchUrl := "https://www.google.com/search?q="
        isUrl := this.isUrl(searchTerm)
        
        ; if the highlighted text/the text in the clipboard is a url, then the url is opened
        if (isUrl) {   
            Run(searchTerm)
        }
        else { ;if not an url, search using google search
            joined_url := googleSearchUrl . searchTerm
            Run(joined_url)
        }
    }

    AskChatGptAboutHighligtedTextOrClipboardContent(loadTime){
        ; saves current clipboard value to a variable
        clipboardValue := A_Clipboard
        ; saves a new value to the clipboard, if any text is highligted
        Send("^c")
        
        ; Opens the chat-gpt site and then pastes the clipboard value (which could be the text which was highlighted)
        Run("https://chat.openai.com/")
        Sleep(loadTime)
        Send(A_Clipboard)
        Send("{Enter}")
        
        ;put the last copied thing back in the clipboard
        A_Clipboard := clipboardValue
    }

    ; asks chat-gpt a question, loadTime is the estimated time the site takes to load in, in probably not the best way to do this
    AskChatGpt(question, loadTime){
        Run("https://chat.openai.com/")
        Sleep(loadTime)
        Send(question)
        Send("{Enter}")
    }

    ; Translates highligted text or the text in the clipboard
    ; if no fromLanguage is specified, then the language is automatically detected
    ; if no toLanguage is specified, then the language is translated to english
    ; if variants is not specified, only one result is returned
    TranslateHighlightedTextOrClipboard(fromLanguage := "auto", toLanguage := "en", &variants := ""){
        ; saves current clipboard value to a variable
        clipboardValue := A_Clipboard
        ; saves a new value to the clipboard, if any text is highligted
        Send("^c")

        ; Takes a text to translate, the language to translate from, the language to translate to, and the variants of the text(optional)
        translatedText := this.TranslateText(A_Clipboard, fromLanguage, toLanguage, &variants)

        ;put the last copied thing back in the clipboard
        A_Clipboard := clipboardValue

        return translatedText
    }

    ; if no fromLanguage is specified, then the language is automatically detected
    ; if no toLanguage is specified, then the language is translated to english
    ; if variants is not specified, only one result is returned
    TranslateText(textToTranslate, fromLanguage := "auto", toLanguage := "en", &variants := ""){
        TextTranslator := Translator()

        ; Takes a text to translate, the language to translate from, the language to translate to, and the variants of the text(optional)
        translatedText := TextTranslator.Translate(textToTranslate, fromLanguage, toLanguage, &variants)
        return translatedText
    }

    ; meant to be a private method, checks if a text is a url
    ; returns a boolean
    IsUrl(text){
        isUrl := ""
        ; if it starts with "https://", then the text is considered a url
        startOfText := SubStr(text, 1, 8)
        if (startOfText = "https://") {   
            isUrl := true
        }
        else{
            isUrl := false
        }
        return isUrl
    }

    OpenUrl(url){
        Run("chrome.exe " url)
    }
}