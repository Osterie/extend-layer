#Requires AutoHotkey v2.0

#Include <Actions\HotkeyAction>

class FileExplorerNavigator extends HotkeyAction {

    destroy() {
        ; Empty
    }

    ; navigates to the specified folder
    NavigateToFolder(folderPath) {
        Run(folderPath)
    }

    ; goes back one level in the file explorer
    ; GoBackOneLevel(){}
}
