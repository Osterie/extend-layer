#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON>

class JsonFormatter{

    FormatJsonObject(jsonObject){
        jsonString := Jxon_Dump(jsonObject)
        return this.FormatJsonString(jsonString)
    }

    FormatJsonString(jsonString){
        indentationLevel := 0
        textToReturn := ""
        previousValue := ""
        quotationMarkCount := 0
        inQuotes := false
    
        Loop Parse jsonString{
    
            if (Mod(quotationMarkCount, 2) = 1){
                inQuotes := true
            }
            else{
                inQuotes := false
            }
    
            if(A_LoopField = "{" and inQuotes = false){
                indentationLevel++
                textToReturn .= "{`n"
                Loop indentationLevel{
                    textToReturn .= "`t"
                }
            }
            else if (A_LoopField = "}" and inQuotes = false){
                indentationLevel--
                textToReturn .= "`n"
                Loop indentationLevel{
                    textToReturn .= "`t"
                }
                textToReturn .= "}"
        
            }
            else if (A_LoopField = "," and inQuotes = false){
                textToReturn .= ",`n"
                Loop indentationLevel{
                    textToReturn .= "`t"
                }
            }
            else if (A_LoopField = "`"" and previousValue != "``"){
                quotationMarkCount++
                textToReturn .= A_LoopField
            }
            else{
                textToReturn .= A_LoopField
            }
            previousValue := A_LoopField
        }
        return textToReturn
    }
}