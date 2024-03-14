#Requires AutoHotkey v2.0
#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"

class HotkeyChangeViewFactory{

    CreateActionCrafter(){
        return HotkeyChangeViewActionCrafter();
    }

    CreateHotkeyCrafter(){
        return HotkeyChangeViewCrafter();
    }
}