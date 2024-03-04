#Requires AutoHotkey v2.0

class ListViewMaker{

    listView := ""
    
    __New(){
        ; Empty
    }

    CreateListView(guiObject, columnNames){
        
        this.listView := guiObject.Add("ListView", "r20 w600 x+10", columnNames)

        ; Attach the ImageLists to the ListView so that it can later display the icons:
        this.listView.SetImageList(this.getImageList())
    }

    getImageList(){
        ImageListID := IL_Create(10)  ; Create an ImageList with initial capacity for 10 icons.
        Loop 10  ; Load the ImageList with some standard system icons.
            IL_Add(ImageListID, "shell32.dll", A_Index)
        return ImageListID
    }

    ; Takes a two dimensional array, items, and adds each item to the listView
    SetNewListViewItems(items){
        this.listView.Delete()
        Loop items.Length{
            this.listView.Add("Icon3", items[A_index]*)
        }
        this.listView.ModifyCol()
    }

    AddEventAction(eventType, action){
        this.listView.OnEvent(eventType, action)
    }
}