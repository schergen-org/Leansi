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

-- Ansi 16 colors
/-- Makes text appear black -/
def black (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with fg := some 30 }
/-- Makes text appear red -/
def red (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with fg := some 31 }
/-- Makes text appear green -/
def green (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with fg := some 32 }
/-- Makes text appear yellow -/
def yellow (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with fg := some 33 }
/-- Makes text appear blue -/
def blue (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with fg := some 34 }
/-- Makes text appear magenta -/
def magenta (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with fg := some 35 }
/-- Makes text appear cyan -/
def cyan (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with fg := some 36 }
/-- Makes text appear white -/
def white (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with fg := some 37 }

/-- Makes background appear black -/
def bg_black (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with bg := some 40 }
/-- Makes background appear red -/
def bg_red (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with bg := some 41 }
/-- Makes background appear green -/
def bg_green (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with bg := some 42 }
/-- Makes background appear yellow -/
def bg_yellow (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with bg := some 43 }
/-- Makes background appear blue -/
def bg_blue (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with bg := some 44 }
/-- Makes background appear magenta -/
def bg_magenta (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann {s with bg := some 45 }
/-- Makes background appear cyan -/
def bg_cyan (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with bg := some 46 }
/-- Makes background appear white -/
def bg_white (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with bg := some 47 }

end Doc

-- Instance op append for Doc to use `doc ++ doc`
instance {ann : Type} : Append (Doc ann) where
  append := Doc.concat

end leansi
