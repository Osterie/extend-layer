#Requires AutoHotkey v2.0

class TreeViewMaker{

    __New(){

    }
    
    createElementsForGui(guiObject, arrayOfValues){
        ImageListID := this.GetCustomImages()
        this.treeView := guiObject.Add("TreeView", "r20 ImageList" . ImageListID)
        if (Type(arrayOfValues) = "Array"){
            Loop arrayOfValues.Length{
                this.treeView.Add(arrayOfValues[A_Index], 0, "Icon4")
            }
        }
        else{
            Throw TypeError("Given values must be an array of values to create treeview")
        }
    }

    AddEventAction(eventType, action){
        this.treeView.OnEvent(eventType, action)
    }

    GetCustomImages(){
        ImageListID := IL_Create(10)  ; Create an ImageList with initial capacity for 10 icons.
        Loop 10  ; Load the ImageList with some standard system icons.
            IL_Add(ImageListID, "shell32.dll", A_Index)

        return ImageListID
    }

    ; TODO this might not work as i want it to...
    GetSelectionText(){
        return this.treeView.GetText(this.treeView.GetSelection())
    }
}