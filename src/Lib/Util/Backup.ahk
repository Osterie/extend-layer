#Requires AutoHotkey v2.0

class Backup {
    ; Properties
    name := ""  ; Name of the backup
    path := ""  ; Path to the backup file
    timestamp := ""  ; Timestamp of when the backup was created
    size := 0  ; Size of the backup file in bytes

    __New(name, path, timestamp, size := 0) {
        this.name := name
        this.path := path
        this.timestamp := timestamp
        this.size := size
    }

    getName() {
        return this.name
    }

    getPath() {
        return this.path
    }

    getTimestamp() {
        return this.timestamp
    }

    ; Unit can be "B" for bytes, "K" for kilobytes, "M" for megabytes.
    ; If an incorrect unit is provided, it defaults to bytes.
    getSize(units := "B") {

        ; By default, size is in bytes
        size := this.size

        if (units = "K") {
            size := Round(this.size / 1024, 2)  ; Convert to kilobytes
        } else if (units = "M") {
            size := Round(this.size / (1024 * 1024), 2)  ; Convert to megabytes
        }

        return size
    }
}