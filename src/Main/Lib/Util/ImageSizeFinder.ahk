#Requires AutoHotkey v2.0

class ImageSizeFinder {
    static ImageSize(imagePath) {
        if !FileExist(imagePath) {
            throw TypeError("Image file does not exist: " . imagePath)
        }

        imgGui := Gui()
        imgGui.Opt("+E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow")
        imgGui.Add("Picture", "AltSubmit", imagePath)

        imgGui.Show("NoActivate")
        imgGui.GetPos(&x, &y, &w, &h)
        
        imgGui.hide()
        imgGui.Destroy()
        return [w, h]
    }
    
}