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
        clipboardValue := A_Clipboard
        Send("^c")
        googleSearchUrl := "https://www.google.com/search?q="
        
        ; if it starts with "https://" go to, rather than search in google search
        isUrl := SubStr(A_Clipboard, 1, 8)
        if (isUrl = "https://") {   
            Run(A_Clipboard)
        }
        else { ;search using google search
            joined_url := googleSearchUrl . "" . A_Clipboard
            Run(joined_url)
        }
        
        ;put the last copied thing back in the clipboard
        A_Clipboard := clipboardValue
    }

    AskChatGpt(question, loadTime){

    }
    ; !make multiple methods with good names instead of this hunk of junk (not made my myself)
    ; google(service := 1){
    ; static urls := { 0: ""
    ;     , 1 : "https://www.google.com/search?hl=en&q="
    ;     , 2 : "https://www.google.com/search?site=imghp&tbm=isch&q="
    ;     , 3 : "https://www.google.com/maps/search/"
    ;     , 4 : "https://translate.google.com/?sl=auto&tl=en&text=" }
    ; POSSIBLE TO ADD MORE. For example to search on wikipedia, or something else idk

    ; !add for chat-gpt

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