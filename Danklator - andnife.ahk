msgbox, CTRL + F11: cambia entre idiomas.`nCTRL + F12: escucha el idioma seleccionado.`n`nALT + Enter: traduce el texto seleccionado.`nCTRL + Enter: traduce y envia el texto escrito automaticamente.`n`nALT + F12: traduce el texto seleccionado a castellano.
a:=0
language = pt

^enter::
clipboard := ""
sleep 100
send ^a
sleep 50
send ^x
sleep 50
newstring := GoogleTranslate(clipboard, , language)
send %newstring%
sleep 50
send {enter}
newstring := ""
return

!enter::
clipboard := ""
send ^c
sleep 50
newstring := GoogleTranslate(clipboard, , language)
send %newstring%
newstring := ""
return

!F12::
clipboard := ""
sleep 50
send ^c
translation := GoogleTranslate(clipboard, , "es")
msgbox, TRADUCCION: %translation%
return

^F12::
switch a
{
	case 0:
		ComObjCreate("SAPI.SpVoice").Speak("Portugues")
	case 1:
		ComObjCreate("SAPI.SpVoice").Speak("Arabe")
	case 2:
		ComObjCreate("SAPI.SpVoice").Speak("Ruso")
	case 3:
		ComObjCreate("SAPI.SpVoice").Speak("Aleman")
	case 4:
		ComObjCreate("SAPI.SpVoice").Speak("Japones")
	case 5:
		ComObjCreate("SAPI.SpVoice").Speak("Coreano")
	case 6:
		ComObjCreate("SAPI.SpVoice").Speak("Rumano")
	case 7:
		ComObjCreate("SAPI.SpVoice").Speak("Amarico")
	case 8:
		ComObjCreate("SAPI.SpVoice").Speak("Frances")
	case 9:
		ComObjCreate("SAPI.SpVoice").Speak("Suajili")
	case 10:
		ComObjCreate("SAPI.SpVoice").Speak("Ingles")
}
return

^F11::
if (a=10)
	a:=-1
a:= a+1
switch a
{
	case 0:
		language = pt
		tooltip, Portugues
		settimer, removetooltip, -500
	case 1:
		language = ar
		tooltip, Arabe
		settimer, removetooltip, -500
	case 2:
		language = ru
		tooltip, Ruso
		settimer, removetooltip, -500
	case 3:
		language = de
		tooltip, Aleman
		settimer, removetooltip, -500
	case 4:
		language = ja
		tooltip, Japones
		settimer, removetooltip, -500
	case 5:
		language = ko
		tooltip, Coreano
		settimer, removetooltip, -500
	case 6:
		language = ro
		tooltip, Rumano
		settimer, removetooltip, -500
	case 7:
		language = am
		tooltip, Amarico
		settimer, removetooltip, -500
	case 8:
		language = fr
		tooltip, Frances
		settimer, removetooltip, -500
	case 9:
		language = sw
		tooltip, Suajili
		settimer, removetooltip, -500
	case 10:
		language = en
		tooltip, Ingles
		settimer, removetooltip, -500
}
return

removetooltip:
tooltip
return

 ; https://cloud.google.com/translate/docs/languages

GoogleTranslate(str, from := "auto", to := "en")  {
   static JS := CreateScriptObj(), _ := JS.( GetJScript() ) := JS.("delete ActiveXObject; delete GetObject;")
   
   json := SendRequest(JS, str, to, from, proxy := "")
   oJSON := JS.("(" . json . ")")

   if !IsObject(oJSON[1])  {
      Loop % oJSON[0].length
         trans .= oJSON[0][A_Index - 1][0]
   }
   else  {
      MainTransText := oJSON[0][0][0]
      Loop % oJSON[1].length  {
         trans .= "`n+"
         obj := oJSON[1][A_Index-1][1]
         Loop % obj.length  {
            txt := obj[A_Index - 1]
            trans .= (MainTransText = txt ? "" : "`n" txt)
         }
      }
   }
   if !IsObject(oJSON[1])
      MainTransText := trans := Trim(trans, ",+`n ")
   else
      trans := MainTransText . "`n+`n" . Trim(trans, ",+`n ")

   from := oJSON[2]
   trans := Trim(trans, ",+`n ")
   Return trans
}

SendRequest(JS, str, tl, sl, proxy) {
   static http
   ComObjError(false)
   if !http
   {
      http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
      ( proxy && http.SetProxy(2, proxy) )
      http.open( "get", "https://translate.google.com", 1 )
      http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
      http.send()
      http.WaitForResponse(-1)
   }
   http.open( "POST", "https://translate.google.com/translate_a/single?client=webapp&sl="
      . sl . "&tl=" . tl . "&hl=" . tl
      . "&dt=at&dt=bd&dt=ex&dt=ld&dt=md&dt=qca&dt=rw&dt=rm&dt=ss&dt=t&ie=UTF-8&oe=UTF-8&otf=0&ssel=0&tsel=0&pc=1&kc=1"
      . "&tk=" . JS.("tk").(str), 1 )

   http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8")
   http.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0")
   http.send("q=" . URIEncode(str))
   http.WaitForResponse(-1)
   Return http.responsetext
}

URIEncode(str, encoding := "UTF-8")  {
   VarSetCapacity(var, StrPut(str, encoding))
   StrPut(str, &var, encoding)

   While code := NumGet(Var, A_Index - 1, "UChar")  {
      bool := (code > 0x7F || code < 0x30 || code = 0x3D)
      UrlStr .= bool ? "%" . Format("{:02X}", code) : Chr(code)
   }
   Return UrlStr
}

GetJScript()
{
   script =
   (
      var TKK = ((function() {
        var a = 561666268;
        var b = 1526272306;
        return 406398 + '.' + (a + b);
      })());

      function b(a, b) {
        for (var d = 0; d < b.length - 2; d += 3) {
            var c = b.charAt(d + 2),
                c = "a" <= c ? c.charCodeAt(0) - 87 : Number(c),
                c = "+" == b.charAt(d + 1) ? a >>> c : a << c;
            a = "+" == b.charAt(d) ? a + c & 4294967295 : a ^ c
        }
        return a
      }

      function tk(a) {
          for (var e = TKK.split("."), h = Number(e[0]) || 0, g = [], d = 0, f = 0; f < a.length; f++) {
              var c = a.charCodeAt(f);
              128 > c ? g[d++] = c : (2048 > c ? g[d++] = c >> 6 | 192 : (55296 == (c & 64512) && f + 1 < a.length && 56320 == (a.charCodeAt(f + 1) & 64512) ?
              (c = 65536 + ((c & 1023) << 10) + (a.charCodeAt(++f) & 1023), g[d++] = c >> 18 | 240,
              g[d++] = c >> 12 & 63 | 128) : g[d++] = c >> 12 | 224, g[d++] = c >> 6 & 63 | 128), g[d++] = c & 63 | 128)
          }
          a = h;
          for (d = 0; d < g.length; d++) a += g[d], a = b(a, "+-a^+6");
          a = b(a, "+-3^+b+-f");
          a ^= Number(e[1]) || 0;
          0 > a && (a = (a & 2147483647) + 2147483648);
          a `%= 1E6;
          return a.toString() + "." + (a ^ h)
      }
   )
   Return script
}

CreateScriptObj() {
   static doc
   doc := ComObjCreate("htmlfile")
   doc.write("<meta http-equiv='X-UA-Compatible' content='IE=9'>")
   Return ObjBindMethod(doc.parentWindow, "eval")
}