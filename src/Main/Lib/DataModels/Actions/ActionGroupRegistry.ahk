#Requires AutoHotkey v2.0

class ActionGroupRegistry {

    ObjectMap := Map()

    __New() {

        ; if object is not found in map, 0 is returned
        this.ObjectMap.Default := 0
    }

    AddObject(objectName, ObjectInfo) {
        this.ObjectMap[objectName] := ObjectInfo
    }

    GetObjectInfo(objectName) {
        return this.ObjectMap[objectName]
    }

    GetMap() {
        return this.ObjectMap
    }

    GetFriendlyNames() {
        friendlyNames := Array()
        for objectName, ObjectInfo in this.ObjectMap {
            friendlyMethodNames := ObjectInfo.getFriendlyNames()

            loop friendlyMethodNames.Length {
                friendlyNames.Push(friendlyMethodNames[A_index])
            }
        }

        return friendlyNames
    }

    GetObjectByFriendlyMethodName(friendlyMethodName) {
        for objectName, ObjectInfo in this.ObjectMap {
            friendlyMethodNames := ObjectInfo.getFriendlyNames()

            loop friendlyMethodNames.Length {
                if (friendlyMethodNames[A_index] = friendlyMethodName) {
                    return ObjectInfo
                }
            }
        }
    }

    DestroyObjects() {
        for objectName, objectInfo in this.ObjectMap {
            objectInfo.DestroyObject()
        }
    }

}
