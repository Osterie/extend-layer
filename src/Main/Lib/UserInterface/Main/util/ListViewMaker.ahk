#Requires AutoHotkey v2.0

; TODO listviewmaker and treeviewmaker could inherit from a class...
class ListViewMaker{

    listView := ""

    columnNames := Array()
    
    __New(){
        ; Empty
    }

    CreateListView(guiObject, options, columnNames){

        this.columnNames := columnNames
        
        this.listView := guiObject.Add("ListView", options, columnNames)

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
        ; TODO dont delete all items, just add new ones or modify existing ones.
        ; this.listView.Delete()

        minWidths := this.GetMinWidthsForItems(items)

        listViewLength := this.listView.GetCount()

        if (listViewLength > items.Length){
            Loop listViewLength - items.Length{
                this.listView.Delete(listViewLength-A_Index+1)
            }
        }

        Loop items.Length{
            if (A_index > listViewLength){
                this.listView.Add("Icon3", items[A_index]*)
            }
            else{
                this.listView.Modify(A_index, "Icon3",items[A_index]*)
            }
        }
        Sleep(20)
        this.SetColumnWidths(minWidths)

    }

    SetColumnWidths(columnWidths){
        Loop columnWidths.Length{
            this.listView.ModifyCol(A_Index, columnWidths[A_Index]*9)
        }
    }


    GetMinWidthsForItems(items){
        minWidths := Array()

        Loop this.columnNames.Length{
            minWidths.Push(StrLen(this.columnNames[A_Index]))
        }

        For indexRow, row in items{
            For indexColumn, column in row{
                if (StrLen(column) > minWidths[indexColumn]){
                    minWidths[indexColumn] := StrLen(column)
                }
            }
        }
        
        return minWidths
    }

    AddEventAction(eventType, action){
        this.listView.OnEvent(eventType, action)
    }

    GetSelectionText(columnNumber := 1){
        selectedText := ""
        if (this.listView.GetNext( , "Focused") = 0){
            selectedText := ""
        }
        else{
            selectedText := this.listView.GetText(this.listView.GetNext( , "Focused"), columnNumber)
        }
        return selectedText
    }
}