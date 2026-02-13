namespace leansi

inductive ColorLevel where
  | none
  | ansi16 : Nat → ColorLevel
  | ansi256 : Nat → ColorLevel
  | truecolor : Nat × Nat × Nat → ColorLevel
deriving Repr, Inhabited, BEq

structure Ansi16Color where
  black : Nat := 30
  red : Nat := 31
  green : Nat := 32
  yellow : Nat := 33
  blue : Nat := 34
  magenta : Nat := 35
  cyan : Nat := 36
  white : Nat := 37
  bright_black : Nat := 90
  bright_red : Nat := 91
  bright_green : Nat := 92
  bright_yellow : Nat := 93
  bright_blue : Nat := 94
  bright_magenta : Nat := 95
  bright_cyan : Nat := 96
  bright_white : Nat := 97

def ansi16Color : Ansi16Color := {}

structure Style where
  fg : Option ColorLevel := none
  bg : Option ColorLevel := none
  bold : Bool := false
  dim : Bool := false
  underline : Bool := false
  italic : Bool := false
  blink : Bool := false
  reverse : Bool := false
  hidden : Bool := false
  strikethrough : Bool := false
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
