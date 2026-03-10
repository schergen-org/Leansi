namespace leansi

/-- A requested color independent of what the current terminal can actually display.
Rendering may later downsample this information to ANSI 256, ANSI 16, or no color. -/
inductive ColorLevel where
  | none
  | ansi16 : Nat → ColorLevel
  | ansi256 : Nat → ColorLevel
  | truecolor : Nat × Nat × Nat → ColorLevel
deriving Repr, Inhabited, BEq

/-- Named ANSI 16 foreground color codes used by the convenience styling helpers. -/
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

/-- Default ANSI 16 palette. -/
def ansi16Color : Ansi16Color := {}

/-- Terminal styling attributes attached to document fragments.
Colors are optional so a style can override just the foreground or background
while inheriting the remaining attributes from surrounding annotations. -/
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
