#Requires AutoHotkey v2.0


Array.Prototype.DefineProp("Contains", {Call:array_contains})
  ; When a descriptor is called, it ALWAYS sends a reference to the object as the first param.  
  ; It's known as the "this" variable when working inside an object/class/etc.  
  ; The search param is the expected item to find.  
  ; CaseSense is a bonus option added just to make the method more robust
  array_contains(arr, search, casesense:=0) {
    for index, value in arr {
        if !IsSet(value)
            continue
        else if (value == search)
            return index
        else if (value = search && !casesense)
            return index
    }
    return 0
}
