#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\UpdateManifestReader>

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
