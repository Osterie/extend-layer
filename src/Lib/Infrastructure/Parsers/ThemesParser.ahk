#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON>

#Include <DataModels\AppData\Themes\Theme>
#Include <DataModels\AppData\Themes\Themes>

#Include <Shared\Logger>

#Include <Util\Errors\FileDoesNotExistError>

class ThemesParser {

    Themes := ""
    Logger := Logger.getInstance()

    BACKGROUND_COLOR := "BackgroundColor"
    TEXT_COLOR := "TextColor"
    CONTROL_COLOR := "ControlColor"
    CAPTION_COLOR := "CaptionColor"
    CAPTION_FONT_COLOR := "CaptionFontColor"

    __New(){
        this.Themes := Themes()
    }

    readThemes(pathToThemes) {
        try{
            themesJsonInfo := this.readFile(pathToThemes)
            return this.parseThemes(themesJsonInfo)
        }
        catch Error as e {
            this.Logger.logError("Failed to read themes from file. " . e.Message)
            throw e
        }
    }

    readFile(pathToThemes) {
        if (!FileExist(pathToThemes)) {
            throw FileDoesNotExistError(pathToThemes, "Themes file does not exist at: ")
        }

        jsonStringThemes := FileRead(pathToThemes, "UTF-8")
        return jxon_load(&jsonStringThemes)
    }

    parseThemes(themesJsonInfo){
        if (!IsObject(themesJsonInfo)) {
            throw Error("Failed to parse themes from json info. Json file is malformed.")
        }

        for themeCategory, themesList in themesJsonInfo {
            if !IsObject(themesList) {
                this.Logger.logError("Failed to parse themes from json info. Themes list for category " . themeCategory . " is not an object.")
                throw Error("Failed to parse themes from json info. Themes list for category " . themeCategory . " is not an object.")
            }

            loop themesList.Length {
                themeInformationMap := themesList[A_Index]

                for themeName, themeInformation in themeInformationMap {

                    themeToAdd := this.createTheme(themeName, themeCategory, themeInformation)
                    this.Themes.AddTheme(themeToAdd)
                }
            }
        }
        return this.Themes
    }

    createTheme(themeName, themeCategory, themeInformation) {
        try{
            BackgroundColor := themeInformation[this.BACKGROUND_COLOR]
            TextColor := themeInformation[this.TEXT_COLOR]
            ControlColor := themeInformation[this.CONTROL_COLOR]
            CaptionColor := themeInformation[this.CAPTION_COLOR]
            CaptionFontColor := themeInformation[this.CAPTION_FONT_COLOR]
        }
        catch Error as e {
            this.Logger.logError("Failed to create theme, Themes.json file is malformed")
            throw Error("Failed to create theme, Themes.json file is malformed")
        }

        return Theme(themeName, themeCategory, BackgroundColor, TextColor, ControlColor, CaptionColor, CaptionFontColor)
    }
}
