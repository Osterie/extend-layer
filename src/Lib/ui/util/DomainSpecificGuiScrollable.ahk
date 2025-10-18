#Requires AutoHotkey v2.0

#Include <ui\util\DomainSpecificGui>

; Code from the AutoHotkey forums, original proof of concept by user 'Lexikos': https://www.autohotkey.com/board/topic/26033-scrollable-gui-proof-of-concept/#entry168174
; Further improved by user 'just me': https://www.autohotkey.com/boards/viewtopic.php?f=83&t=112708
; Modified by me to fit my needs. Also made into a class.

;Scrollable Gui - Proof of Concept - Scripts and Functions - AutoHotkey Community
;https://autohotkey.com/board/topic/26033-scrollable-gui-proof-of-concept/#entry168174
; MK_SHIFT = 0x0004, WM_MOUSEWHEEL = 0x020A, WM_MOUSEHWHEEL = 0x020E, WM_NCHITTEST = 0x0084

class DomainSpecificGuiScrollable extends DomainSpecificGui {

    ; How far to scroll for each scroll command, increase for faster scrolling, decrease for slower.
    SCROLL_STEP := 30

    ; Window message sent when scroll event occurs in the windows standard vertical scrollbar
    WM_VSCROLL := 0x0115

    ; Window message sent when scroll event occurs in the windows standard horizontal scrollbar
    WM_HSCROLL := 0x0114

    ; Window message sent to the focus window when mouse wheel is scrolled. 
    ; Also works for touchpad, although microsoft docs do not mention this.
    WM_MOUSEWHEEL := 0x020A

    ; Sent to a window in order to determine what part of the window corresponds to a particular screen coordinate
    ; This can happen, for example, when the cursor moves, when a mouse button is pressed or released, or in response to a call to a function such as WindowFromPoint
    ; Returns a value indicating the position of the cursor.
    WM_NCHITTEST := 0x0084

    ; In a horizontal scroll bar.
    HTHSCROLL := 6
    ; In a vertical scroll bar.
    HTVSCROLL := 7
    ; Mouse scroll inside client area
    HTCLIENT := 1

    ; Scrolsl up one line
    SB_LINEUP := 0
    ; Scrolls down one line
    SB_LINEDOWN := 1
    ; Scrolls up one page
    SB_PAGEUP := 2
    ; Scrolls down one page
    SB_PAGEDOWN := 3
    ; The user is dragging the scroll box
    SB_THUMBTRACK := 4
    ; The user has dragged the scroll box (thumb) and released the mouse button. 
    SB_THUMBPOSITION := 5
    ; Scrolls to the upper left
    SB_TOP := 6
    ; Scrolls to the lower left
    SB_BOTTOM := 7

    __New(options := "", title := "", eventObj := this) {
        super.__New(options, title, eventObj)
        this.makeScrollable()
    }

    makeScrollable() {
        this.OnEvent("Size", ObjBindMethod(this, "onSizeEvent"))
        OnMessage(this.WM_VSCROLL, ObjBindMethod(this, "onScroll"))
        OnMessage(this.WM_HSCROLL, ObjBindMethod(this, "onScroll"))
        OnMessage(this.WM_MOUSEWHEEL, ObjBindMethod(this, "onWheel"))
    }

    onSizeEvent(guiObj, minMax, width, height) {
        ; window is maximized
        if (minMax == 1){
            return
        }
        this.UpdateScrollBars(guiObj)
    }

    UpdateScrollBars(guiObj) {
        ; SIF_RANGE = 0x1, SIF_PAGE = 0x2, SIF_DISABLENOSCROLL = 0x8, SB_HORZ = 0, SB_VERT = 1
        ; Calculate scrolling area.
        WinGetClientPos(, , &guiWidth, &guiHeight, guiObj.Hwnd)
        left := top := 2147483647
        right := bottom := -2147483648

        for ctrlHwnd In WinGetControlsHwnd(guiObj.Hwnd) {
            ControlGetPos(&controlX, &controlY, &controlWidth, &controlHeight, ctrlHwnd)
            left := Min(controlX, left)
            top := Min(controlY, top)
            right := Max(controlX + controlWidth, right)
            bottom := Max(controlY + controlHeight, bottom)
        }
        left -= 8, top -= 8
        right += 8, bottom += 8
        scrollWidth := right - left
        scrollHeight := bottom - top
        
        ; Initialize SCROLLINFO.
        cbSize := 28
        scrollInfo := Buffer(cbSize, 0)
        NumPut("UInt", cbSize, "UInt", 3, scrollInfo, 0) ; cbSize , fMask: SIF_RANGE | SIF_PAGE
        ; Update horizontal scroll bar.
        NumPut("Int", scrollWidth, "Int", guiWidth, scrollInfo, 12) ; nMax , nPage
        DllCall("SetScrollInfo", "Ptr", guiObj.Hwnd, "Int", 0, "Ptr", scrollInfo, "Int", 1) ; SB_HORZ
        ; Update vertical scroll bar.
        ; NumPut("UInt", SIF_RANGE | SIF_PAGE | SIF_DISABLENOSCROLL, scrollInfo, 4) ; fMask
        NumPut("Int", scrollHeight, "UInt", guiHeight, scrollInfo, 12) ; nMax , nPage
        DllCall("SetScrollInfo", "Ptr", guiObj.Hwnd, "Int", 1, "Ptr", scrollInfo, "Int", 1) ; SB_VERT
        ; Scroll if necessary
        x := (left < 0) && (right < guiWidth) ? Min(Abs(left), guiWidth - right) : 0
        y := (top < 0) && (bottom < guiHeight) ? Min(Abs(top), guiHeight - bottom) : 0
        if (x || y){
            DllCall("ScrollWindow", "Ptr", guiObj.Hwnd, "Int", x, "Int", y, "Ptr", 0, "Ptr", 0)
        }
    }

    onWheel(wParameter, lParameter, message, H) {
        if !(hwnd := WinExist()) || GuiCtrlFromHwnd(H){
            return
        }

        hitTest := DllCall("SendMessage", "Ptr", hwnd, "UInt", this.WM_NCHITTEST, "Ptr", 0, "Ptr", lParameter)

        inHorizontalScrollbar := hitTest = this.HTHSCROLL
        inVerticalScrollbar := hitTest = this.HTVSCROLL
        inClientArea := hitTest = this.HTCLIENT
        
        if (inHorizontalScrollbar) || (inVerticalScrollbar) || (inClientArea) {
            doScrollDown := (wParameter & 0x80000000)

            scrollBarCommand := doScrollDown ? this.SB_LINEDOWN : this.SB_LINEUP
            scrollMessage := inHorizontalScrollbar ? this.WM_HSCROLL : this.WM_VSCROLL
            this.onScroll(scrollBarCommand, 0, scrollMessage, hwnd)
            return 0
        }
    }

    onScroll(wParameter, lParameter, message, hwnd) {
        if !(lParameter = 0) ; not sent by a standard scrollbar
            return
        bar := (message = this.WM_VSCROLL) ; SB_HORZ=0, SB_VERT=1
        scrollInfo := Buffer(28, 0)
        NumPut("UInt", 28, "UInt", 0x17, scrollInfo) ; cbSize, fMask: SIF_ALL
        if !DllCall("GetScrollInfo", "Ptr", hwnd, "Int", bar, "Ptr", scrollInfo)
            return
        RC := Buffer(16, 0)
        DllCall("GetClientRect", "Ptr", hwnd, "Ptr", RC)
        newPosition := NumGet(scrollInfo, 20, "Int") ; nPos
        minPosition := NumGet(scrollInfo, 8, "Int") ; nMin
        maxPosition := NumGet(scrollInfo, 12, "Int") ; nMax

        scrollStep := this.SCROLL_STEP
        
        altKeyIsDown := GetKeyState("Alt")
        cltrKeyIsDown := GetKeyState("Ctrl")
        if (altKeyIsDown || cltrKeyIsDown){
            scrollStep *= 3
        }

        switch (wParameter & 0xFFFF) {
            case this.SB_LINEUP: newPosition -= scrollStep
            case this.SB_LINEDOWN: newPosition += scrollStep
            case this.SB_PAGEUP: newPosition -= NumGet(RC, 12, "Int") - scrollStep
            case this.SB_PAGEDOWN: newPosition += NumGet(RC, 12, "Int") - scrollStep
            case this.SB_THUMBTRACK, this.SB_THUMBPOSITION: newPosition := wParameter >> 16
            case this.SB_TOP: newPosition := minPosition
            case this.SB_BOTTOM: newPosition := maxPosition
            Default: return
        }
        maxPosition -= NumGet(scrollInfo, 16, "Int") ; nPage
        newPosition := Min(newPosition, maxPosition)
        newPosition := Max(minPosition, newPosition)
        oldPosition := NumGet(scrollInfo, 20, "Int") ; nPos
        x := (bar = 0) ? oldPosition - newPosition : 0
        y := (bar = 1) ? oldPosition - newPosition : 0
        if (x || y) {
            ; Scroll contents of window and invalidate uncovered area.
            DllCall("ScrollWindow", "Ptr", hwnd, "Int", x, "Int", y, "Ptr", 0, "Ptr", 0)
            ; Update scroll bar.
            NumPut("Int", newPosition, scrollInfo, 20) ; nPos
            DllCall("SetScrollInfo", "ptr", hwnd, "Int", bar, "Ptr", scrollInfo, "Int", 1)
        }
    }
}