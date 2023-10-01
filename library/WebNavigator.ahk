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
                    Sleep(loadTime)
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

    OpenUrl(url){
        Run("chrome.exe " url)
    }
}