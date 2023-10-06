#Requires Autohotkey v2.0

; ----------------------------------------------
; ----------- FUNCTIONS ------------------------
; ----------------------------------------------

; --------------Seach----------

; Searches google for the currently highlighteded text, or the text stored in the clipboard
SearchHighlitedOrClipboard(){
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