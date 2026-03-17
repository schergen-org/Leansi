namespace leansi

/-- Gets visual length of string, currently uses `String.length`. -/
def visualLength (s : String) : Nat :=
  s.length

/-- Build a string containing `n` characters. -/
def repeatChar (c : Char) (n : Nat) : String :=
  String.ofList (List.replicate n c)

/-- Build a string containing `n` ASCII spaces. -/
def whiteSpaceString (n : Nat) : String :=
  repeatChar ' ' n

/-- Converts a hexadecimal digit to its numeric value. -/
private def hexDigitValue? (c : Char) : Option Nat :=
  if '0' ≤ c && c ≤ '9' then
    some (c.toNat - '0'.toNat)
  else if 'a' ≤ c && c ≤ 'f' then
    some (10 + (c.toNat - 'a'.toNat))
  else if 'A' ≤ c && c ≤ 'F' then
    some (10 + (c.toNat - 'A'.toNat))
  else
    none

/-- Converts two hexadecimal digits to their numeric value. -/
private def hexByteValue? (hi lo : Char) : Option Nat := do
  let hi ← hexDigitValue? hi
  let lo ← hexDigitValue? lo
  pure (hi * 16 + lo)

/-- Parses a hexadecimal color string and returns its RGB values. -/
private def parseHexColor? (hex : String) : Option (Nat × Nat × Nat) :=
  let normalized :=
    if hex.startsWith "#" then
      (hex.drop 1).toString
    else
      hex
  match normalized.toList with
  | [r1, r2, g1, g2, b1, b2] => do
      let r ← hexByteValue? r1 r2
      let g ← hexByteValue? g1 g2
      let b ← hexByteValue? b1 b2
      pure (r, g, b)
  | _ => none

def rgbFromHex (hex : String) : (Nat × Nat × Nat) :=
  match parseHexColor? hex with
  | some (r, g, b) => (r, g, b)
  | none => (0, 0, 0)

end leansi
