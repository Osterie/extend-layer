#Requires AutoHotkey v2.0

; Utils for testing performance

class Timer {
    static freq := (DllCall("QueryPerformanceFrequency", "Int64*", &f := 0), f)
    static startCounter := 0

    static Start() {
        local counter := 0
        DllCall("QueryPerformanceCounter", "Int64*", &counter)
        this.startCounter := counter
    }

    static Stop() {
        local endCounter := 0
        DllCall("QueryPerformanceCounter", "Int64*", &endCounter)

        elapsedMs := (endCounter - this.startCounter) / this.freq * 1000
        return elapsedMs
    }
}