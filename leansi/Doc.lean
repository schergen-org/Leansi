import leansi.Style

namespace leansi

inductive Doc (ann : Type) where
| empty : Doc ann
| text : String → Doc ann
| concat : Doc ann → Doc ann → Doc ann
| ann : ann → Doc ann → Doc ann
deriving Repr, Inhabited, BEq

namespace Doc
/-- Makes text appear **bold** -/
def bold (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with bold := true }
/-- Makes text appear <u>underlined</u> -/
def underline (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with underline := true }
/-- Makes text appear *italic* -/
def italic (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with italic := true }
/-- Makes text appear dim -/
def dim (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with dim := true }
/-- Makes text appear blinking -/
def blink (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with blink := true }
/-- Reverses the colors of the text -/
def reverse (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with reverse := true }
/-- Hides the text -/
def hidden (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with hidden := true }
/-- Makes the text appear strikethrough -/
def strikethrough (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with strikethrough := true }

-- Ansi 16 colors
def fg (code : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with fg := some code }
/-- Makes text appear black -/
def black := fg 30
/-- Makes text appear red -/
def red := fg 31
/-- Makes text appear green -/
def green := fg 32
/-- Makes text appear yellow -/
def yellow := fg 33
/-- Makes text appear blue -/
def blue := fg 34
/-- Makes text appear magenta -/
def magenta := fg 35
/-- Makes text appear cyan -/
def cyan := fg 36
/-- Makes text appear white -/
def white := fg 37

def bg (code : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with bg := some code }
/-- Makes background appear black -/
def bg_black := bg 40
/-- Makes background appear red -/
def bg_red := bg 41
/-- Makes background appear green -/
def bg_green := bg 42
/-- Makes background appear yellow -/
def bg_yellow := bg 43
/-- Makes background appear blue -/
def bg_blue := bg 44
/-- Makes background appear magenta -/
def bg_magenta := bg 45
/-- Makes background appear cyan -/
def bg_cyan := bg 46
/-- Makes background appear white -/
def bg_white := bg 47

end Doc

-- Instance op append for Doc to use `doc ++ doc`
instance {ann : Type} : Append (Doc ann) where
  append := Doc.concat

end leansi
