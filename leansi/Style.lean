namespace leansi

inductive colorLevel where
  | none
  | ansi16
deriving Repr, Inhabited, BEq

structure Style where
  fg : Option Nat :=none
  bg : Option Nat :=none
  bold : Bool := false
  underline : Bool := false
  italic : Bool := false
deriving Repr, Inhabited, BEq

namespace Style

def boldStyle : Style := { bold := true }
def underlineStyle : Style := { underline := true }
def italicStyle : Style := { italic := true }

-- ANSI 16 Farben
def black : Style := { fg := some 30 }
def red : Style := { fg := some 31 }
def green : Style := { fg := some 32 }
def yellow : Style := { fg := some 33 }
def blue : Style := { fg := some 34 }
def magenta : Style := { fg := some 35 }
def cyan : Style := { fg := some 36 }
def white : Style := { fg := some 37 }

-- Kombination von Styles
def combine (s1 s2 : Style) : Style := {
  fg := s2.fg <|> s1.fg
  bg := s2.bg <|> s1.bg
  bold := s1.bold || s2.bold
  underline := s1.underline || s2.underline
  italic := s1.italic || s2.italic
}

end Style

end leansi
