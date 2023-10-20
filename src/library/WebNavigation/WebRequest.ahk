#Requires AutoHotkey v2.0

; Created by user teadrinker, copied from the autohotkey forums.
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=63835

class WebRequest{
    __New() {
        this.httpRequest := ComObject('WinHttp.WinHttpRequest.5.1')
    }

    __Delete() {
        this.httpRequest := ''
    }

    Fetch(url, method := 'GET', HeadersMap := '', body := '', getRawData := false) {
        this.httpRequest.Open(method, url, true)

        for name, value in HeadersMap
            this.httpRequest.SetRequestHeader(name, value)

        this.error := ''
        this.httpRequest.Send(body)
        this.httpRequest.WaitForResponse()

        status := this.httpRequest.status
        if (status != 200)
            this.error := 'HttpRequest error, status: ' . status . ' — ' . this.httpRequest.StatusText
        
        SafeArray := this.httpRequest.responseBody
        pData := NumGet(ComObjValue(SafeArray) + 8 + A_PtrSize, 'Ptr')
        length := SafeArray.MaxIndex() + 1
        
        if !getRawData
            result := StrGet(pData, length, 'UTF-8')
        else {
            outData := Buffer(length, 0)
            DllCall('RtlMoveMemory', 'Ptr', outData, 'Ptr', pData, 'Ptr', length)
            result := outData
        }
        return result
    }
}
