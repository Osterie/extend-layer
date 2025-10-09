#Requires AutoHotkey v2.0

class BackupPage {

    guiToAddTo := ""

    gropuBox := ""

    __New(guiToAddTo, options := ""){
        if (!guiToAddTo is Gui){
            throw TypeError("guiToAddTo must be a Gui object")
        }
        this.guiToAddTo := guiToAddTo
        this.createBackupPage(options)
    }

    createBackupPage(options := "") {
        this.gropuBox := this.guiToAddTo.Add("GroupBox", options, "")
        ; gropuBox.Modify("Font s10 Bold BackgroundRed")

        ; this.guiToAddTo.Add("Text", "xm ym w400 h20 Center", "Backup Documentation Page")
        ; this.guiToAddTo.Add("Text", "xm+10 ym+30 w380 h200", "This is where the backup documentation content will go.")

    }
}