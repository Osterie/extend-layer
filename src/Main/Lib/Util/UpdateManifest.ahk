#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\UpdateManifestReader>

class UpdateManifest {
    static theSingleInstance := 0

    UpdateManifestReader := UpdateManifestReader(FilePaths.getPathToUpdateManifest())

    __New() {
    }

    static getInstance() {
        if (IsObject(UpdateManifest.theSingleInstance) = 0) {
            UpdateManifest.theSingleInstance := UpdateManifest() ; Default UpdateManifest
        }
        return UpdateManifest.theSingleInstance
    }

    GetOverwritePaths() {
        return this.UpdateManifestReader.GetOverwritePaths()
    }

    GetSkipPaths() {
        return this.UpdateManifestReader.GetSkipPaths()
    }
}
