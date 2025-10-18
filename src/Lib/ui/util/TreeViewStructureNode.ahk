#Requires AutoHotkey v2.0

class TreeViewStructureNode {
    name := ""
    children := []

    __New(name, children := []) {
        this.name := name
        this.children := children.Clone()
    }

    addChild(childNode) {
        if !IsObject(childNode)
            throw TypeError("addChild() expects a TreeViewStructureNode object")
        this.children.Push(childNode)
        return this
    }

    hasChildren() {
        return this.children.Length > 0
    }
}


; root := new TreeViewStructureNode("Animals")
; root.addChild(new TreeViewStructureNode("Mammals", [
;     new TreeViewStructureNode("Dog"),
;     new TreeViewStructureNode("Cat")
; ]))
; root.addChild(new TreeViewStructureNode("Birds", [
;     new TreeViewStructureNode("Eagle"),
;     new TreeViewStructureNode("Parrot")
; ]))



; data := [
;     new TreeNode("Animals", [
;         new TreeNode("Mammals", [
;             new TreeNode("Dog"),
;             new TreeNode("Cat")
;         ]),
;         new TreeNode("Birds", [
;             new TreeNode("Eagle"),
;             new TreeNode("Parrot")
;         ])
;     ]),
;     new TreeNode("Plants", [
;         new TreeNode("Oak"),
;         new TreeNode("Pine")
;     ])
; ]


; {


; 	"Backups":[
;         "Creating Backups":[
;             "Old Version",
;             "New Version",
;             "Test"
;         ]
;     ],
;     "Updates":[
;         "How to Update"
;     ],
;     "Profiles":[
;         "Editing",
;         "Adding",
;         "Importing",
;         "Exporting",
;         "Preset Profiles"
;     ]
;     "Menubar":[
;         "Settings",
;         "Suspending script",
;         "Themes"
;     ]
;     "Action Settings":[

;     ]
;     "Keyboards":[
;         "Global Layer",
;         "Normal Layer",
;         "Secondary Layer",
;         "Tertiary Layer"
;     ]

;     "Hotkeys":[
;         "Adding Hotkey",
;         "Editing Hotkey",
;         "Deleting Hotkey"
;     ]
; }