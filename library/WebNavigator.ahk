#Requires AutoHotkey v2.0

Class WebNavigator{


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

    ; !make multiple methods with good names instead of this hunk of junk (not made my myself)
    ; google(service := 1){
    ; static urls := { 0: ""
    ;     , 1 : "https://www.google.com/search?hl=en&q="
    ;     , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="
    ;     , 3 : "https://www.google.com/maps/search/"
    ;     , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }
    ; POSSIBLE TO ADD MORE. For example to search on wikipedia, or something else idk

    ; backup := ClipboardAll
    ; Clipboard := ""
    ; Send ^c
    ; ClipWait 0
    ; if ErrorLevel
    ;     InputBox query, Google Search,,, 200, 100
    ; else query := Clipboard
    ; Run % urls[service] query
    ; Clipboard := backup
    ; F1::google(1) ; Regular search
    ; F2::google(2) ; Images search
    ; F3::google(3) ; Maps search
    ; F4::google(4) ; Translation
; }

    OpenUrl(url){
        Run("chrome.exe " url)
    }
}