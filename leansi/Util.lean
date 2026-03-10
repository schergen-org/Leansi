namespace leansi

/-- Gets visual length of string, currently uses `String.length`. -/
def visualLength (s : String) : Nat :=
  s.length

/-- Build a string containing `n` ASCII spaces.
Centralising this helper keeps padding logic consistent across alignment and layout code. -/
def whiteSpaceString (n : Nat) : String :=
  String.ofList (List.replicate n ' ')

end leansi
