#Requires AutoHotkey v2.0


class IniProfilesReader{

    
    ReadClassObjects(){
        IniRead, this.ClassObjects, %A_ScriptDir%\Profiles.ini, ClassObjects
        return this.ClassObjects
    }
}