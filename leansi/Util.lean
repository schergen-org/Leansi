namespace leansi

/-- Gets visual length of string, currently uses `String.length`. -/
def visualLength (s : String) : Nat :=
  s.length

/-- Build a string containing `n` ASCII spaces. -/
def whiteSpaceString (n : Nat) : String :=
  String.ofList (List.replicate n ' ')

end leansi
