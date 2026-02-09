namespace leansi

inductive colorLevel where
  | none
  | ansi16
  | ansi256
deriving Repr, Inhabited, BEq

structure Style where
  fg : Option Nat := none
  bg : Option Nat := none
  bold : Bool := false
  dim : Bool := false
  underline : Bool := false
  italic : Bool := false
  blink : Bool := false
  reverse : Bool := false
  hidden : Bool := false
  strikethrough : Bool := false
  colorLevel : colorLevel := colorLevel.none
deriving Repr, Inhabited, BEq

namespace Style

-- Kombination von Styles
def combine (s1 s2 : Style) : Style := {
  fg := s2.fg <|> s1.fg
  bg := s2.bg <|> s1.bg
  bold := s1.bold || s2.bold
  dim := s1.dim || s2.dim
  underline := s1.underline || s2.underline
  italic := s1.italic || s2.italic
  blink := s1.blink || s2.blink
  reverse := s1.reverse || s2.reverse
  hidden := s1.hidden || s2.hidden
  strikethrough := s1.strikethrough || s2.strikethrough
}

end Style

end leansi
