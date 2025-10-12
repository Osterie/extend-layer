#Requires AutoHotkey v2.0

#Include <ui\util\DomainSpecificGui>

; Code from the AutoHotkey forums, original proof of concept by user 'Lexikos': https://www.autohotkey.com/board/topic/26033-scrollable-gui-proof-of-concept/#entry168174
; Further improved by user 'just me': https://www.autohotkey.com/boards/viewtopic.php?f=83&t=112708
; Modified by me to fit my needs. Also made into a class.

;[edited to make it x64/x32 compatible]
;Scrollable Gui - Proof of Concept - Scripts and Functions - AutoHotkey Community
;https://autohotkey.com/board/topic/26033-scrollable-gui-proof-of-concept/#entry168174
; MK_SHIFT = 0x0004, WM_MOUSEWHEEL = 0x020A, WM_MOUSEHWHEEL = 0x020E, WM_NCHITTEST = 0x0084

class DomainSpecificGuiScrollable extends DomainSpecificGui {

    __New(options := "", title := "", eventObj := this) {
        super.__New(options, title, eventObj)
        this.makeScrollable()

    }

    makeScrollable() {

        this.OnEvent("Size", ObjBindMethod(this, "onSizeEvent"))
        OnMessage(0x0115, ObjBindMethod(this, "onScroll")) ; WM_VSCROLL
        OnMessage(0x0114, ObjBindMethod(this, "onScroll")) ; WM_HSCROLL
        OnMessage(0x020A, ObjBindMethod(this, "onWheel"))  ; WM_MOUSEWHEEL
        ; OnMessage(0x0115, this.onScroll) ; WM_VSCROLL
        ; OnMessage(0x0114, this.onScroll) ; WM_HSCROLL
        ; OnMessage(0x020A, this.onWheel)  ; WM_MOUSEWHEEL
    }

    onSizeEvent(GuiObj, MinMax, Width, Height) {
        if (MinMax != 1)
            this.UpdateScrollBars(GuiObj)
    }

    UpdateScrollBars(GuiObj) {
        ; SIF_RANGE = 0x1, SIF_PAGE = 0x2, SIF_DISABLENOSCROLL = 0x8, SB_HORZ = 0, SB_VERT = 1
        ; Calculate scrolling area.
        WinGetClientPos(, , &GuiW, &GuiH, GuiObj.Hwnd)
        L := T := 2147483647   ; Left, Top
        R := B := -2147483648  ; Right, Bottom
        for CtrlHwnd In WinGetControlsHwnd(GuiObj.Hwnd) {
            ControlGetPos(&CX, &CY, &CW, &CH, CtrlHwnd)
            L := Min(CX, L)
            T := Min(CY, T)
            R := Max(CX + CW, R)
            B := Max(CY + CH, B)
        }
        L -= 8, T -= 8
        R += 8, B += 8
        ScrW := R - L ; scroll width
        ScrH := B - T ; scroll height
        ; Initialize SCROLLINFO.
        SI := Buffer(28, 0)
        NumPut("UInt", 28, "UInt", 3, SI, 0) ; cbSize , fMask: SIF_RANGE | SIF_PAGE
        ; Update horizontal scroll bar.
        NumPut("Int", ScrW, "Int", GuiW, SI, 12) ; nMax , nPage
        DllCall("SetScrollInfo", "Ptr", GuiObj.Hwnd, "Int", 0, "Ptr", SI, "Int", 1) ; SB_HORZ
        ; Update vertical scroll bar.
        ; NumPut("UInt", SIF_RANGE | SIF_PAGE | SIF_DISABLENOSCROLL, SI, 4) ; fMask
        NumPut("Int", ScrH, "UInt", GuiH, SI, 12) ; nMax , nPage
        DllCall("SetScrollInfo", "Ptr", GuiObj.Hwnd, "Int", 1, "Ptr", SI, "Int", 1) ; SB_VERT
        ; Scroll if necessary
        X := (L < 0) && (R < GuiW) ? Min(Abs(L), GuiW - R) : 0
        Y := (T < 0) && (B < GuiH) ? Min(Abs(T), GuiH - B) : 0
        if (X || Y)
            DllCall("ScrollWindow", "Ptr", GuiObj.Hwnd, "Int", X, "Int", Y, "Ptr", 0, "Ptr", 0)
    }

    onWheel(W, L, M, H) {
        if !(HWND := WinExist()) || GuiCtrlFromHwnd(H)
            return
        HT := DllCall("SendMessage", "Ptr", HWND, "UInt", 0x0084, "Ptr", 0, "Ptr", l) ; WM_NCHITTEST = 0x0084
        if (HT = 6) || (HT = 7) || (HT = 1) { ; HTHSCROLL = 6, HTVSCROLL = 7, mouse scroll inside client area = 1
            SB := (W & 0x80000000) ? 1 : 0 ; SB_LINEDOWN = 1, SB_LINEUP = 0
            SM := (HT = 6) ? 0x0114 : 0x0115 ;  WM_HSCROLL = 0x0114, WM_VSCROLL = 0x0115
            this.onScroll(SB, 0, SM, HWND)
            return 0
        }
    }

    onScroll(WP, LP, M, H) {
        static SCROLL_STEP := 10
        if !(LP = 0) ; not sent by a standard scrollbar
            return
        Bar := (M = 0x0115) ; SB_HORZ=0, SB_VERT=1
        SI := Buffer(28, 0)
        NumPut("UInt", 28, "UInt", 0x17, SI) ; cbSize, fMask: SIF_ALL
        if !DllCall("GetScrollInfo", "Ptr", H, "Int", Bar, "Ptr", SI)
            return
        RC := Buffer(16, 0)
        DllCall("GetClientRect", "Ptr", H, "Ptr", RC)
        NewPos := NumGet(SI, 20, "Int") ; nPos
        MinPos := NumGet(SI, 8, "Int") ; nMin
        MaxPos := NumGet(SI, 12, "Int") ; nMax
        switch (WP & 0xFFFF) {
            case 0: NewPos -= SCROLL_STEP ; SB_LINEUP
            case 1: NewPos += SCROLL_STEP ; SB_LINEDOWN
            case 2: NewPos -= NumGet(RC, 12, "Int") - SCROLL_STEP ; SB_PAGEUP
            case 3: NewPos += NumGet(RC, 12, "Int") - SCROLL_STEP ; SB_PAGEDOWN
            case 4, 5: NewPos := WP >> 16 ; SB_THUMBTRACK, SB_THUMBPOSITION
            case 6: NewPos := MinPos ; SB_TOP
            case 7: NewPos := MaxPos ; SB_BOTTOM
            Default: return
        }
        MaxPos -= NumGet(SI, 16, "Int") ; nPage
        NewPos := Min(NewPos, MaxPos)
        NewPos := Max(MinPos, NewPos)
        OldPos := NumGet(SI, 20, "Int") ; nPos
        X := (Bar = 0) ? OldPos - NewPos : 0
        Y := (Bar = 1) ? OldPos - NewPos : 0
        if (X || Y) {
            ; Scroll contents of window and invalidate uncovered area.
            DllCall("ScrollWindow", "Ptr", H, "Int", X, "Int", Y, "Ptr", 0, "Ptr", 0)
            ; Update scroll bar.
            NumPut("Int", NewPos, SI, 20) ; nPos
            DllCall("SetScrollInfo", "ptr", H, "Int", Bar, "Ptr", SI, "Int", 1)
        }
    }
}

; ; Code from the AutoHotkey forums, original proof of concept by user 'Lexikos': https://www.autohotkey.com/board/topic/26033-scrollable-gui-proof-of-concept/#entry168174
; ; Further improved by user 'just me': https://www.autohotkey.com/boards/viewtopic.php?f=83&t=112708
; ; Modified by me to fit my needs. Also made into a class.

; ;[edited to make it x64/x32 compatible]
; ;Scrollable Gui - Proof of Concept - Scripts and Functions - AutoHotkey Community
; ;https://autohotkey.com/board/topic/26033-scrollable-gui-proof-of-concept/#entry168174
; ; MK_SHIFT = 0x0004, WM_MOUSEWHEEL = 0x020A, WM_MOUSEHWHEEL = 0x020E, WM_NCHITTEST = 0x0084
; Lines := "1`n2`n3`n4`n5`n6`n7`n8`n9`n10"
; ScrollGui := Gui("", "Scrollable GUI") ; WS_VSCROLL | WS_HSCROLL
; ScrollGui.OnEvent("Size", ScrollGui_Size)
; ScrollGui.OnEvent("Close", ScrollGui_Close)
; Loop 8
;     ScrollGui.AddText("r5 w600", Lines)
; ScrollGui.AddButton( , "Do absolutely nothing")
; ScrollGui.Show("w400 h300")
; OnMessage(0x0115, this.onScroll) ; WM_VSCROLL
; OnMessage(0x0114, this.onScroll) ; WM_HSCROLL
; OnMessage(0x020A, this.onWheel)  ; WM_MOUSEWHEEL
; ; ======================================================================================================================
; ScrollGui_Size(GuiObj, MinMax, Width, Height) {
;    If (MinMax != 1)
;       UpdateScrollBars(GuiObj)
; }
; ; ======================================================================================================================
; ScrollGui_Close(*) {
;    ExitApp
; }
; ; ======================================================================================================================
; UpdateScrollBars(GuiObj) {
;    ; SIF_RANGE = 0x1, SIF_PAGE = 0x2, SIF_DISABLENOSCROLL = 0x8, SB_HORZ = 0, SB_VERT = 1
;    ; Calculate scrolling area.
;    WinGetClientPos( , , &GuiW, &GuiH, GuiObj.Hwnd)
;    L := T := 2147483647   ; Left, Top
;    R := B := -2147483648  ; Right, Bottom
;    For CtrlHwnd In WinGetControlsHwnd(GuiObj.Hwnd) {
;       ControlGetPos(&CX, &CY, &CW, &CH, CtrlHwnd)
;       L := Min(CX, L)
;       T := Min(CY, T)
;       R := Max(CX + CW, R)
;       B := Max(CY + CH, B)
;    }
;    L -= 8, T -= 8
;    R += 8, B += 8
;    ScrW := R - L ; scroll width
;    ScrH := B - T ; scroll height
;    ; Initialize SCROLLINFO.
;    SI := Buffer(28, 0)
;    NumPut("UInt", 28, "UInt", 3, SI, 0) ; cbSize , fMask: SIF_RANGE | SIF_PAGE
;    ; Update horizontal scroll bar.
;    NumPut("Int", ScrW, "Int", GuiW, SI, 12) ; nMax , nPage
;    DllCall("SetScrollInfo", "Ptr", GuiObj.Hwnd, "Int", 0, "Ptr", SI, "Int", 1) ; SB_HORZ
;    ; Update vertical scroll bar.
;    ; NumPut("UInt", SIF_RANGE | SIF_PAGE | SIF_DISABLENOSCROLL, SI, 4) ; fMask
;    NumPut("Int", ScrH, "UInt", GuiH,  SI, 12) ; nMax , nPage
;    DllCall("SetScrollInfo", "Ptr", GuiObj.Hwnd, "Int", 1, "Ptr", SI, "Int", 1) ; SB_VERT
;    ; Scroll if necessary
;    X := (L < 0) && (R < GuiW) ? Min(Abs(L), GuiW - R) : 0
;    Y := (T < 0) && (B < GuiH) ? Min(Abs(T), GuiH - B) : 0
;    If (X || Y)
;       DllCall("ScrollWindow", "Ptr", GuiObj.Hwnd, "Int", X, "Int", Y, "Ptr", 0, "Ptr", 0)
; }
; ; ======================================================================================================================
; this.onWheel(W, L, M, H) {
;    If !(HWND := WinExist()) || GuiCtrlFromHwnd(H)
;       Return
;    HT := DllCall("SendMessage", "Ptr", HWND, "UInt", 0x0084, "Ptr", 0, "Ptr", l) ; WM_NCHITTEST = 0x0084
;    If (HT = 6) || (HT = 7) || (HT = 1) { ; HTHSCROLL = 6, HTVSCROLL = 7, mouse scroll inside client area = 1
;       SB := (W & 0x80000000) ? 1 : 0 ; SB_LINEDOWN = 1, SB_LINEUP = 0
;       SM := (HT = 6) ? 0x0114 : 0x0115 ;  WM_HSCROLL = 0x0114, WM_VSCROLL = 0x0115
;       this.onScroll(SB, 0, SM, HWND)
;       Return 0
;    }
; }
; ; ======================================================================================================================
; this.onScroll(WP, LP, M, H) {
;    Static SCROLL_STEP := 10
;    If !(LP = 0) ; not sent by a standard scrollbar
;       Return
;    Bar := (M = 0x0115) ; SB_HORZ=0, SB_VERT=1
;    SI := Buffer(28, 0)
;    NumPut("UInt", 28, "UInt", 0x17, SI) ; cbSize, fMask: SIF_ALL
;    If !DllCall("GetScrollInfo", "Ptr", H, "Int", Bar, "Ptr", SI)
;       Return
;    RC := Buffer(16, 0)
;    DllCall("GetClientRect", "Ptr", H, "Ptr", RC)
;    NewPos := NumGet(SI, 20, "Int") ; nPos
;    MinPos := NumGet(SI,  8, "Int") ; nMin
;    MaxPos := NumGet(SI, 12, "Int") ; nMax
;    Switch (WP & 0xFFFF) {
;       Case 0: NewPos -= SCROLL_STEP ; SB_LINEUP
;       Case 1: NewPos += SCROLL_STEP ; SB_LINEDOWN
;       Case 2: NewPos -= NumGet(RC, 12, "Int") - SCROLL_STEP ; SB_PAGEUP
;       Case 3: NewPos += NumGet(RC, 12, "Int") - SCROLL_STEP ; SB_PAGEDOWN
;       Case 4, 5: NewPos := WP >> 16 ; SB_THUMBTRACK, SB_THUMBPOSITION
;       Case 6: NewPos := MinPos ; SB_TOP
;       Case 7: NewPos := MaxPos ; SB_BOTTOM
;       Default: Return
;    }
;    MaxPos -= NumGet(SI, 16, "Int") ; nPage
;    NewPos := Min(NewPos, MaxPos)
;    NewPos := Max(MinPos, NewPos)
;    OldPos := NumGet(SI, 20, "Int") ; nPos
;    X := (Bar = 0) ? OldPos - NewPos : 0
;    Y := (Bar = 1) ? OldPos - NewPos : 0
;    If (X || Y) {
;       ; Scroll contents of window and invalidate uncovered area.
;       DllCall("ScrollWindow", "Ptr", H, "Int", X, "Int", Y, "Ptr", 0, "Ptr", 0)
;       ; Update scroll bar.
;       NumPut("Int", NewPos, SI, 20) ; nPos
;       DllCall("SetScrollInfo", "ptr", H, "Int", Bar, "Ptr", SI, "Int", 1)
;    }
; }
