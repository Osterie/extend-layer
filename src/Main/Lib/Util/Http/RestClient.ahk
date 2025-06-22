#Requires AutoHotkey v2.0

#Include <Util\Http\HttpClient>
#Include <Util\JsonParsing\JXON>

; RestClient class to handle RESTful API requests
; It uses HttpClient for making HTTP requests and JXON for JSON parsing.
class RestClient {

    baseUrl := ""  ; Base URL for the API
    http := HttpClient()     ; Instance of HttpClient for making requests

    ; baseUrl is the base URL for the API, for example "https://api.example.com/"
    __New(baseUrl := "") {
        this.baseUrl := baseUrl
    }

    ; Sends a GET request to the specified endpoint with optional headers.
    ; returns the response as an object containing status, text, and parsed JSON.
    Get(endpoint, headers := Map()) {
        return this.http.Request("GET", this.baseUrl . endpoint, headers)
    }

    ; Sends a POST request to the specified endpoint with a JSON body and optional headers.
    ; returns the response as an object containing status, text, and parsed JSON.
    Post(endpoint, body, headers := Map()) {
        json := Jxon_Dump(body)
        headers["Content-Type"] := "application/json"
        return this.http.Request("POST", this.baseUrl . endpoint, headers, json)
    }
}
