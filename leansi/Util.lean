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
end leansi
