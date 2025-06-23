#Requires AutoHotkey v2.0

#Include <Actions\HotkeyAction>

Class FileExplorerNavigator extends HotkeyAction{


    ; navigates to the specified folder
    NavigateToFolder(folderPath){
        Run(folderPath)
    }

    ; goes back one level in the file explorer
    ; GoBackOneLevel(){}
}