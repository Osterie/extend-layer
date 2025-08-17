#Requires AutoHotkey v2.0

#Include <ui\util\DomainSpecificGui>

class ProgressBar extends DomainSpecificGui {
    progressText := ""
    progressBar := ""

    __New(title := "Progress Bar") {
        super.__New("-SysMenu", title)
        this.create()
        this.show()
    }

    show(){
        super.Show("w300 h100")
    }

    create() {
        this.progressText := this.Add("Text", "w280 r2", "")
        this.progressBar := this.Add("Progress", "w280 r4 cBlue")
    }

    updateProgress(text, value) {
        this.progressText.Value := text
        this.progressBar.Value := value
    }
}