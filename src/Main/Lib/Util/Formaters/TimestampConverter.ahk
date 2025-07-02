#Requires AutoHotkey v2.0

; TODO FormatTime exists in ahk, use that instead.
; Converts timestamps to different formats.
class TimestampConverter{

    ; TimestampConverter.ISOToCompact("2025-05-23T15:21:21Z")
    ; "2025-05-23T15:21:21Z" → "20250523152121"

    ; TimestampConverter.CompactToISO("20250523152121")
    ; 20250523152121 → "2025-05-23T15:21:21Z"

    ; Convert ISO 8601 timestamp to compact format (YYYYMMDDhhmmss)
    ISOToCompact(isoTimestamp) {
        isoTimestamp := RegExReplace(isoTimestamp, "[^0-9]")  ; Remove non-numeric characters
        if (StrLen(isoTimestamp) != 14) {
            throw ValueError("Invalid ISO timestamp format. Expected format: YYYY-MM-DDThh:mm:ssZ")
        }
        return isoTimestamp
    }

    ; Convert compact timestamp (YYYYMMDDhhmmss) to ISO 8601 format
    CompactToISO(compactTimestamp) {

        if (StrLen(compactTimestamp) != 14) {
            throw ValueError("Invalid compact timestamp format. Expected format: YYYYMMDDhhmmss")
        }

        isoTimestamp := ""
        try {
            year := SubStr(compactTimestamp, 1, 4)
            month := SubStr(compactTimestamp, 5, 2)
            day := SubStr(compactTimestamp, 7, 2)
            hour := SubStr(compactTimestamp, 9, 2)
            minute := SubStr(compactTimestamp, 11, 2)
            second := SubStr(compactTimestamp, 13, 2)

            isoTimestamp := Format("{:04}-{:02}-{:02}T{:02}:{:02}:{:02}", year, month, day, hour, minute, second)
        } catch Error as e {
            throw ValueError("Invalid compact timestamp format. Expected format: YYYYMMDDhhmmss. Error: " e.Message)
        }
        return isoTimestamp
    }
}