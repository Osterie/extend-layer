#Requires AutoHotkey v2.0

; TODO listviewmaker and treeviewmaker could inherit from a class...
; TODO atleas inheritance from list view gui control...
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
        minWidths := this.GetMinWidthsForItems(items)
        this.TrimList(items.Length)
        this.RenewItems(items)
        this.SetColumnWidths(minWidths)
    }

    ; Makes the list the same length as newLength if it is larger than newLength
    TrimList(newLength){
        listViewLength := this.listView.GetCount()

        if (listViewLength > newLength){
            Loop listViewLength - newLength{
                this.listView.Delete(listViewLength-A_Index+1)
            }
        }
    }
    
    RenewItems(newItems){
        listViewLength := this.listView.GetCount()

        Loop newItems.Length{
            if (A_index > listViewLength){
                this.listView.Add("Icon3", newItems[A_index]*)
            }
            else{
                this.listView.Modify(A_index, "Icon3",newItems[A_index]*)
            }
        }
    }

    SetColumnWidths(columnWidths){
        Loop columnWidths.Length{
            this.listView.ModifyCol(A_Index, "AutoHdr", )
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

    GetCount(){
        return this.listView.GetCount()
    }
}