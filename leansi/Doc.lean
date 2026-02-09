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
def fg_ansi_16 (code : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with fg := some code, colorLevel := colorLevel.ansi16 }
/-- Makes text appear black -/
def black := fg_ansi_16 30
/-- Makes text appear red -/
def red := fg_ansi_16 31
/-- Makes text appear green -/
def green := fg_ansi_16 32
/-- Makes text appear yellow -/
def yellow := fg_ansi_16 33
/-- Makes text appear blue -/
def blue := fg_ansi_16 34
/-- Makes text appear magenta -/
def magenta := fg_ansi_16 35
/-- Makes text appear cyan -/
def cyan := fg_ansi_16 36
/-- Makes text appear white -/
def white := fg_ansi_16 37

def bg_ansi_16 (code : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with bg := some code, colorLevel := colorLevel.ansi16 }
/-- Makes background appear black -/
def bg_black := bg_ansi_16 40
/-- Makes background appear red -/
def bg_red := bg_ansi_16 41
/-- Makes background appear green -/
def bg_green := bg_ansi_16 42
/-- Makes background appear yellow -/
def bg_yellow := bg_ansi_16 43
/-- Makes background appear blue -/
def bg_blue := bg_ansi_16 44
/-- Makes background appear magenta -/
def bg_magenta := bg_ansi_16 45
/-- Makes background appear cyan -/
def bg_cyan := bg_ansi_16 46
/-- Makes background appear white -/
def bg_white := bg_ansi_16 47

/-- Set foreground color using Ansi256 codes -/
def fg_ansi_256 (color : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with fg := some color, colorLevel := colorLevel.ansi256 }
/-- Set background color using Ansi256 codes -/
def bg_ansi_256 (color : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with bg := some color, colorLevel := colorLevel.ansi256 }

end Doc

-- Instance op append for Doc to use `doc ++ doc`
instance {ann : Type} : Append (Doc ann) where
  append := Doc.concat

end leansi
