#Requires AutoHotkey v2.0

#Include <Util\Downloading\UnZipper>

; Downloader class to handle downloading and unzipping files.
class Downloader {

    UnZipper := UnZipper()

    ; Downloads and unzips a file from the given URL to the specified download location and unzip location.
    ; If replace is true, it will delete the existing file or directory before downloading or unzipping.
    ; zipUrl: The URL of the zip file to download.
    ; downloadLocation: The path where the zip file will be downloaded.
    ; unzipLocation: The path where the zip file will be unzipped.
    DownloadZip(zipUrl, downloadLocation, unzipLocation, replace := false) {
        this.Download(zipUrl, downloadLocation, replace) ; Download the zip file
        this.unzip(downloadLocation, unzipLocation, replace) ; unzip the downloaded file
    }

    ; Downloads a file from the given URL to the specified location.
    Download(url, downloadLocation, replace := false) {
        if (replace && DirExist(downloadLocation)) {
            DirDelete(downloadLocation) ; Remove existing folder if replace is true
        }
        else if (replace && FileExist(downloadLocation)) {
            FileDelete(downloadLocation) ; Remove existing file if replace is true
        }

        Download(url, downloadLocation)
    }

    ; Unzips a zip file to the specified location.
    ; zipFile: The path to the zip file to unzip.
    ; unzipLocation: The path where the zip file will be unzipped.
    ; replace: If true, it will delete the existing directory before unzipping.
    unzip(zipFile, unzipLocation, replace := false) {
        if (replace) {
            this.DeleteOldDownload(unzipLocation, true) ; Remove existing directory if replace is true
        }

        this.UnZipper.unzip(zipFile, unzipLocation, true) ; unzip to the specified location
    }

    ; Deletse the file/direcotory at the specified download location.
    ; downloadLocation: The path to the file or directory to delete.
    ; directory: true/false. If true, it will delete the directory; if false, it will delete the file.
    DeleteOldDownload(downloadLocation, directory) {
        if (directory != true && directory != false) {
            throw Error("Invalid directory parameter. It must be true or false.")
        }
        if (!FileExist(downloadLocation)){
            return ; If the file or directory does not exist, do nothing
        }

        if (directory) {
            DirDelete(downloadLocation, true) ; Remove the old download directory
        }
        else if (!directory) {
            FileDelete(downloadLocation) ; Remove the old download file
        }
    }
}