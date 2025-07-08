#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON>

; Class to handle HTTP requests using WinHttp
class HttpClient {

    ; method is the HTTP method (GET, POST, etc.)
    ; url is the endpoint to which the request is made.
    ; headers is an associative array of headers to include in the request.
    ; body is the request body, if applicable (for POST, PUT, etc.) given as a string.
    ; Returns an object containing the status code, response text, and parsed JSON object.
    Request(method, url, headers := Map(), body := "") {
        this.ValidateParameters(method, url, headers, body)

        httpRequest := this.CreateHttpRequest(method, url)
        this.SetHeaders(httpRequest, headers)

        response := this.SendRequest(httpRequest, body)

        return this.CreateResponseObject(response)
    }

    ; ---------------
    ; Private methods
    ; ---------------

    ; Creates a new WinHttp request object with the specified method and URL.
    CreateHttpRequest(method, url) {
        httpRequest := ComObject("WinHttp.WinHttpRequest.5.1")
        httpRequest.Open(method, url, true)
        httpRequest.Option[6] := true ; follow redirects
        return httpRequest
    }

    ; Sets the headers for the HTTP request.
    SetHeaders(httpRequest, headers) {
        if (!headers.Has("User-Agent")) {
            httpRequest.SetRequestHeader("User-Agent", "AHK-RestClient/1.0")
        }

        for key, value in headers {
            httpRequest.SetRequestHeader(key, value)
        }
    }

    ; Sends the HTTP request and waits for the response, then returns the response object.
    SendRequest(httpRequest, body) {
        httpRequest.Send(body)
        httpRequest.WaitForResponse()
        return httpRequest
    }

    ; Creates a response object containing the status code, body as string, and parsed JSON object of the response body.
    CreateResponseObject(response) {

        responseStatus := response.Status
        responseText := response.ResponseText

        try {
            parsedObject := Jxon_Load(&responseText)
        } catch {
            parsedObject := ""  ; Response is not json.
        }

        return {
            status: responseStatus,
            text: responseText,
            objectAsMap: parsedObject
        }
    }

    ; Validates the parameters for the HTTP request.
    ; Throws an error if any parameter is invalid.
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
