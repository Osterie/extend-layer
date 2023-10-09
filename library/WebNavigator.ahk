#Requires AutoHotkey v2.0
#Include ".\Translator.ahk"

Class WebNavigator{

    ; Closes tabs to the right of the current tab, only works in chrome ATM
    CloseTabsToTheRight(){
        ; These sends could be compressed to just one, but for readability they are all seperated to each their line
        ; Focuses search bar
        Send("^l")
        ; Focuses active tab
        Send("{F6}")
        ; Right clicks active tab, opening a dropdown meny with actions
        Send("{AppsKey}")
        ; Focuses the option to close tabs to the right
        Send("{Up}")
        ; Performs said action
        Send("{Enter}")
        ; Goes back to the body of the page
        Send("{F6}") 
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
        googleSearchUrl := "https://www.google.com/search?q="
        
        clipboardValue := A_Clipboard
        Send("^c")
        isUrl := this.isUrl(A_Clipboard)
        
        ; if the highlighted text/the text in the clipboard is a url, then the url is opened
        if (isUrl) {   
            Run(A_Clipboard)
        }
        else { ;if not an url, search using google search
            joined_url := googleSearchUrl . A_Clipboard
            Run(joined_url)
        }
        
        ;put the last copied thing back in the clipboard
        A_Clipboard := clipboardValue
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

    ; if no fromLanguage is specified, then the language is automatically detected
    ; if no toLanguage is specified, then the language is translated to english
    ; if variants is not specified, only one result is returned
    TranslateText(textToTranslate, fromLanguage := "auto", toLanguage := "en", &variants := ""){
        TextTranslator := Translator()

        ; Takes a text to translate, the language to translate from, the language to translate to, and the variants of the text(optional)
        translatedText := TextTranslator.Translate(textToTranslate, fromLanguage, toLanguage, &variants)
        return translatedText
    }

    TranslateHighlightedTextOrClipboard(fromLanguage := "auto", toLanguage := "en"){
        ; saves current clipboard value to a variable
        clipboardValue := A_Clipboard
        ; saves a new value to the clipboard, if any text is highligted
        Send("^c")

        ; Creates a translator object
        TextTranslator := Translator()

        ; Takes a text to translate, the language to translate from, the language to translate to, and the variants of the text(optional)
        translatedText := TextTranslator.Translate(A_Clipboard, fromLanguage, toLanguage, &variants)
        
        ;put the last copied thing back in the clipboard
        A_Clipboard := clipboardValue

        return translatedText
    }

    ; asks chat-gpt a question, loadTime is the estimated time the site takes to load in, in probably not the best way to do this
    AskChatGpt(question, loadTime){
        Run("https://chat.openai.com/")
        Sleep(loadTime)
        Send(question)
        Send("{Enter}")
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