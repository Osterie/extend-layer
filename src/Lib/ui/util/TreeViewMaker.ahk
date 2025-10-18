#Requires AutoHotkey v2.0

#Include <ui\util\TreeViewStructureNode>

class TreeViewMaker {

    treeView := ""
    invisibleTabNames := []

    invisibleTabs := ""


    getInvisibleTabs(){
        return this.invisibleTabs
    }


    createElementsForGuiOld(guiObject, arrayOfValues) {
        If !(arrayOfValues is Array){
			throw Error("Object type not supported.", -1, Format("<Object at 0x{:p}>", ObjPtr(object)))
        }
        
        ImageListID := this.GetCustomImages()
        ; TODO should be able to pass options for treeview
        this.treeView := guiObject.Add("TreeView", "r20 ImageList" . ImageListID)
        this.treeView.Opt("-Redraw")
        
        loop arrayOfValues.Length {
            this.treeView.Add(arrayOfValues[A_Index], 0, "Icon4")
        }
        this.treeView.Opt("+Redraw")
        return this.treeView
    }

    ; Creates TreeView from a single root node or an array of root nodes
    createElementsForGui(guiObject, root, options := "r20", useInvisibleTabs := false) {
        ImageListID := this.GetCustomImages()
        
        this.treeView := guiObject.Add("TreeView", options . " ImageList" . ImageListID)

        this.invisibleTabNames := []
    
        if (Type(root) = "Array") {
            for _, node in root
                this.AddNodeRecursive(node)
        } else if (root is TreeViewStructureNode) {
            this.AddNodeRecursive(root)
        } else {
            throw TypeError("createElementsForGui expects a TreeViewStructureNode or array of nodes")
        }

        if (useInvisibleTabs) {
            this.invisibleTabNames.Push("EMPTY") ; empty tab to show when no documentation item is selected.
            this.invisibleTabs := guiObject.Add("Tab2", "w0 h0 yp xp -Wrap", this.invisibleTabNames)
        }

        return this.treeView
    }

    ; Recursive helper function
    AddNodeRecursive(node, parentId := 0) {
        if !(node is TreeViewStructureNode){
            throw TypeError("AddNodeRecursive() expects a TreeViewStructureNode object")
        }

        itemId := this.treeView.Add(node.name, parentId, "Icon4 +Checked")
        this.invisibleTabNames.Push(node.name)

        if (node.hasChildren()) {
            for _, child in node.children {
                this.AddNodeRecursive(child, itemId)
            }
        }
    }


    AddEventAction(eventType, action) {
        this.treeView.OnEvent(eventType, action)
    }

    GetCustomImages() {
        ImageListID := IL_Create(10)  ; Create an ImageList with initial capacity for 10 icons.
        loop 10  ; Load the ImageList with some standard system icons.
            IL_Add(ImageListID, "shell32.dll", A_Index)

        return ImageListID
    }

    ; TODO this might not work as i want it to...
    GetSelectionText() {
        return this.treeView.GetText(this.treeView.GetSelection())
    }
}
