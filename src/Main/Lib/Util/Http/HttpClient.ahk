#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON\JXON>

; Class to handle HTTP requests using WinHttp
class HttpClient {
    
    ; method is the HTTP method (GET, POST, etc.)
    ; url is the endpoint to which the request is made.
    ; headers is an associative array of headers to include in the request.
    ; body is the request body, if applicable (for POST, PUT, etc.) given as a string.
    ; Returns an object containing the status code, response text, and parsed JSON object.
    Request(method, url, headers := Map(), body := "") {
        this.ValidateParameters(method, url, headers, body)

        httpRequest := ComObject("WinHttp.WinHttpRequest.5.1")
        httpRequest.Open(method, url, true)


        for name, value in headers
            httpRequest.SetRequestHeader(name, value)

        httpRequest.Send(body)
        httpRequest.WaitForResponse()

        responseStatus := httpRequest.Status
        responseText := httpRequest.ResponseText

        responseTextAsObject := Jxon_Load(&responseText)
        return { 
            status: responseStatus, 
            text: responseText,
            objectAsMap: responseTextAsObject  ; This is a Map
        }
    }

    ValidateParameters(method, url, headers, body) {
        if (Type(headers) != "Map") {
            throw TypeError("Headers must be a Map object.")
        }
        if (Type(body) != "String") {
            throw TypeError("Body must be a String.")
        }
        if (Type(method) != "String") {
            throw TypeError("Method must be a String.")
        }
        if (Type(url) != "String") {
            throw TypeError("URL must be a String.")
        }
        if (method != "GET" && method != "POST" && method != "PUT" && method != "DELETE") {
            throw ValueError("Invalid HTTP method: " method)
        }
        if (url == "") {
            throw ValueError("URL cannot be empty.")
        }
    }
}
