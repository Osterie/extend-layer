#Requires AutoHotkey v2.0
#Include ".\Translator.ahk"
#Include ".\ComputerInputController.ahk"

Class WebNavigator{

    chatGptLoadTime := 3000

    ; Public method
    ; Closes tabs to the right of the current tab, only works in chrome ATM
    CloseTabsToTheRight(){

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

    LoginToSite(url, loginButtonImagePaths, loadTime){

        rememberedClipboardValue := A_Clipboard
        trimmedUrl := StrReplace(url, "https://www", "")
        trimmedUrl := StrReplace(trimmedUrl, "https://", "")
        trimmedUrl := StrReplace(trimmedUrl, "http://www", "")
        trimmedUrl := StrReplace(trimmedUrl, "http://", "")

        loginButtonClicked := false
        index := 1

        this.OpenUrl(url)
        Sleep(loadTime)


        
        while ( (index <= loginButtonImagePaths.Length) && !loginButtonClicked ){
            try{
                this.ClickLoginButton(loginButtonImagePaths[index])
                ; if it reaches here, the login button is clicked
                loginButtonClicked := true

                Sleep(loadTime/2)
                Send("^l")
                Send("^c")
                Send("{F6 2}")

                trimmedClipboard := StrReplace(A_Clipboard, "https://www", "")
                trimmedClipboard := StrReplace(trimmedClipboard, "https://", "")
                trimmedClipboard := StrReplace(trimmedClipboard, "http://www", "")
                trimmedClipboard := StrReplace(trimmedClipboard, "http://", "")

                ; this checks if the clipboard content (which is the new site url, after logging in) is the same as the given url.
                if (!InStr(trimmedClipboard, trimmedUrl)){
                    Send("^l")
                    Send(url)
                    Send("{Enter}")
                }
        
                A_Clipboard := rememberedClipboardValue
            }
            catch{
                index += 1
            }
        }
    }

    ClickLoginButton(loginButtonImagePath){
        ErrorLevel := !ImageSearch(&loginButtonXCoordinate, &loginButtonYCoordinate, 0, 0, A_ScreenWidth, A_ScreenHeight, A_ScriptDir loginButtonImagePath)
        MouseClick("left", loginButtonXCoordinate, loginButtonYCoordinate)
    }

    ; Searches google for the currently highlighteded text, or the text stored in the clipboard
    LookUpHighlitedTextOrClipboardContent(){
        
        rememberedClipboardValue := A_Clipboard
        Send("^c")
        Sleep(100)

        this.SearchInBrowser(A_Clipboard)
        
        ;put the last copied thing back in the clipboard
        A_Clipboard := rememberedClipboardValue
    }

    SearchFromInputBox(){
        inputBoxWebSearch := InputBox("What would you like to search in the browser?", "Web search", "w150 h150")
        ; Only if the search is not cancelled will it search
        if (inputBoxWebSearch.Result = "Ok"){
            this.SearchInBrowser(inputBoxWebSearch.Value)
        }
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

    ; TODO instead of using loadtime = 3000, it should be a setting in the ini file, but i dont want to do this right now, easy fix
    AskChatGptAboutHighligtedTextOrClipboardContent(){
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

    ; asks chat-gpt a question, loadTime is the estimated time the site takes to load in, in probably not the best way to do this
    AskChatGpt(question, loadTime){
        Run("https://chat.openai.com/")
        Sleep(loadTime)
        Send(question)
        Send("{Enter}")
    }

    SetChatGptLoadTime(loadTime){
        this.chatGptLoadTime := loadTime
    }

    ShowTranslatedText(fromLanguage := "auto", toLanguage := "en", &variants := ""){
        translatedText := this.TranslateHighlightedTextOrClipboard(fromLanguage, toLanguage, &variants)
        MsgBox(translatedText)
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