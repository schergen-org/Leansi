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

end Style

end leansi
