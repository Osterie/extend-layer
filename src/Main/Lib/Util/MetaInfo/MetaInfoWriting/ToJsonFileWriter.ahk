#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\IniFileReader>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\MetaInfo\MetaInfoReading\KeyboadLayersInfoClassObjectReader>

class ToJsonFileWriter{

    static WriteKeyboardLayersInfoRegisterToJsonFile(keyboardLayersInfoRegister, pathToFile){
        toJsonReader := KeyboadLayersInfoClassObjectReader()
        toJsonReader.ReadObjectToJson(keyboardLayersInfoRegister)
        jsonObject := toJsonReader.getJsonObject()

        formatterForJson := JsonFormatter()
        jsonString := formatterForJson.FormatJsonObject(jsonObject)
        
        FileRecycle(pathToFile)
        FileAppend(jsonString, pathToFile, "UTF-8")
    }
}