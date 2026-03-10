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

end leansi
