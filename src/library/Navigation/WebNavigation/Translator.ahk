#Requires AutoHotkey v2.0
#Include "WebRequest.ahk"

; Copied from Teadrinker https://www.autohotkey.com/boards/viewtopic.php?f=6&t=63835 

Class Translator{

    Translate(textToTranslate, fromLanguage := 'auto', toLanguage := 'en', &variants := '') {
        static JS := ObjBindMethod(GetJsObject(), 'eval'), _ := JS(GetJScript())
        
        json := SendRequest(textToTranslate, Type(fromLanguage) = 'VarRef' ? %fromLanguage% : fromLanguage, toLanguage)
        return ExtractTranslation(json, fromLanguage, &variants)
    
        GetJsObject() {
            static document := '', JS
            if !document {
                document := ComObject('HTMLFILE')
                document.write('<meta http-equiv="X-UA-Compatible" content="IE=9">')
                JS := document.parentWindow
                (document.documentMode < 9 && JS.execScript())
            }
            return JS
        }
    
        GetJScript() {
            return '
            ( Join
                var TKK="406398.2087938574";function b(r,_){for(var t=0;t<_.length-2;t+=3){var $=_.charAt(t+2),$="a"<=$?$
                .charCodeAt(0)-87:Number($),$="+"==_.charAt(t+1)?r>>>$:r<<$;r="+"==_.charAt(t)?r+$&4294967295:r^$}return r}
                function tk(r){for(var _=TKK.split("."),t=Number(_[0])||0,$=[],a=0,h=0;h<r.length;h++){var n=r.charCodeAt(h);
                128>n?$[a++]=n:(2048>n?$[a++]=n>>6|192:(55296==(64512&n)&&h+1<r.length&&56320==(64512&r.charCodeAt(h+1))?
                (n=65536+((1023&n)<<10)+(1023&r.charCodeAt(++h)),$[a++]=n>>18|240,$[a++]=n>>12&63|128):$[a++]=n>>12|224,$
                [a++]=n>>6&63|128),$[a++]=63&n|128)}for(a=0,r=t;a<$.length;a++)r+=$[a],r=b(r,"+-a^+6");return r=b(r,
                "+-3^+b+-f"),0>(r^=Number(_[1])||0)&&(r=(2147483647&r)+2147483648),(r%=1e6).toString()+"."+(r^t)}
            )'
        }
    
        SendRequest(textToTranslate, sl, tl) {
            static webRequestInstance := ''
                 , headers := Map('Content-Type', 'application/x-www-form-urlencoded;charset=utf-8',
                                  'User-Agent'  , 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0')
            if !webRequestInstance {
                webRequestInstance := WebRequest()
                webRequestInstance.Fetch('https://translate.google.com',, headers)
            }
            translateUrl := 'https://translate.googleapis.com/translate_a/single?client=gtx'
                 . '&sl=' . sl . '&tl=' . tl . '&hl=' . tl
                 . '&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=0&ssel=0&tsel=0&pc=1&kc=1'
                 . '&tk=' . JS('tk')(textToTranslate)
            return webRequestInstance.Fetch(translateUrl, 'POST', headers, 'q=' . JS('encodeURIComponent')(textToTranslate))
        }
    
        ExtractTranslation(json, fromLanguage, &variants) {
            jsObj := JS('(' . json . ')')
            if !IsObject(jsObj.1) {
                Loop jsObj.0.length {
                    variants .= jsObj.0.%A_Index - 1%.0
                }
            } else {
                mainTrans := jsObj.0.0.0
                Loop jsObj.1.length {
                    variants .= '`n+'
                    obj := jsObj.1.%A_Index - 1%.1
                    Loop obj.length {
                        txt := obj.%A_Index - 1%
                        variants .= (mainTrans = txt ? '' : '`n' . txt)
                    }
                }
            }
            if !IsObject(jsObj.1)
                mainTrans := variants := Trim(variants, ',+`n ')
            else
                variants := mainTrans . '`n+`n' . Trim(variants, ',+`n ')
    
            (Type(fromLanguage) = 'VarRef' && %fromLanguage% := jsObj.8.3.0)
            return mainTrans
        }
    }
}