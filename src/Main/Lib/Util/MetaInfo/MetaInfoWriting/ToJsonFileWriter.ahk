#Requires AutoHotkey v2.0

#Include <Infrastructure\IO\IniFileReader>
#Include <Shared\FilePaths>
#Include <Util\MetaInfo\MetaInfoReading\KeyboadLayersInfoClassObjectReader>

; TODO change! Should only write convert a json string to a json object and write it to a file. or vice versa
; TODO Have classes a layer above which can write keyboard layers info to a file. A repository or something.
class ToJsonFileWriter{

    static WriteKeyboardLayersInfoRegisterToJsonFile(keyboardLayersInfoRegister, pathToFile){
        toJsonReader := KeyboadLayersInfoClassObjectReader()
        toJsonReader.readObjectToJson(keyboardLayersInfoRegister)
        jsonObject := toJsonReader.getJsonObject()

        formatterForJson := JsonFormatter()
        jsonString := formatterForJson.FormatJsonObject(jsonObject)
        
        FileRecycle(pathToFile)
        FileAppend(jsonString, pathToFile, "UTF-8")
    }
}