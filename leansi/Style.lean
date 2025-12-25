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
