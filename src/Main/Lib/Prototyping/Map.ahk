#Requires AutoHotkey v2.0


Map.Prototype.DefineProp("toValues", {Call:mapToValues})
Map.Prototype.DefineProp("toKeys", {Call:mapToKeys})
  ; When a descriptor is called, it ALWAYS sends a reference to the object as the first param.  
  ; It's known as the "this" variable when working inside an object/class/etc.  
  ; The search param is the expected item to find.  
  ; CaseSense is a bonus option added just to make the method more robust
mapToValues(map_) {
    arrayToReturn := Array()
    for key, value in map_ {
        arrayToReturn.Push(value)
    }

    return arrayToReturn
}

mapToKeys(map_) {
    arrayToReturn := Array()
    for key, value in map_ {
        arrayToReturn.Push(key)
    }

    return arrayToReturn
}
