#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>
#Include <Infrastructure\FileReaders\UpdateManifestReader>

class UpdateManifest {
    static instance := false

    UpdateManifestReader := UpdateManifestReader(FilePaths.getPathToUpdateManifest())

    __New() {
    }

    static getInstance() {
        if (IsObject(UpdateManifest.instance) = false) {
            UpdateManifest.instance := UpdateManifest() ; Default UpdateManifest
        }
        return UpdateManifest.instance
    }

    getOverwritePaths() {
        return this.UpdateManifestReader.getOverwritePaths()
    }

    getSkipPaths() {
        return this.UpdateManifestReader.getSkipPaths()
    }
}
