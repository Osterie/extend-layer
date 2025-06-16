#Requires AutoHotkey v2.0

#Include <Util\UnZipper>

class Downloader {

    UnZipper := UnZipper()

    DownloadZip(zipUrl, downloadLocation, unzipLocation, replace := false) {
        this.Download(zipUrl, downloadLocation, replace) ; Download the zip file
        this.Unzip(downloadLocation, unzipLocation, replace) ; Unzip the downloaded file
    }

    Download(url, downloadLocation, replace := false) {
        if (replace && FileExist(downloadLocation)) {
            FileDelete(downloadLocation) ; Remove existing file if replace is true
        }

        Download(url, downloadLocation)
    }

    Unzip(zipFile, unzipLocation, replace := false) {
        if (replace) {
            this.DeleteOldDownload(unzipLocation, true) ; Remove existing directory if replace is true
        }

        this.UnZipper.Unzip(zipFile, unzipLocation, true) ; Unzip to the specified location
    }

    DeleteOldDownload(downloadLocation, directory := true) {
        if (FileExist(downloadLocation) && directory) {
            DirDelete(downloadLocation, true) ; Remove the old download directory
        }
        else if (FileExist(downloadLocation) && !directory) {
            FileDelete(downloadLocation) ; Remove the old download file
        }
        else if (directory != true && directory != false) {
            throw Error("Invalid directory parameter. It must be true or false.")
        }
    }
}