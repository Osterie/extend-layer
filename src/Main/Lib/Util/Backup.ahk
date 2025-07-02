#Requires AutoHotkey v2.0

class Backup {
    ; Properties
    name := ""  ; Name of the backup
    path := ""  ; Path to the backup file
    timestamp := ""  ; Timestamp of when the backup was created

    __New(name, path, timestamp) {
        this.name := name
        this.path := path
        this.timestamp := timestamp
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
}