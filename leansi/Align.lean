import leansi.Doc

namespace leansi

inductive Alignment where
  | left
  | right
  | center
  | full

-- Gets visual length of string, currently uses String.length
def visualLength (s : String) : Nat :=
  s.length

def whiteSpaceString (n : Nat) : String := String.ofList (List.replicate n ' ')

def padLeft (s : String) (len : Nat) (visualLen : Nat) : String :=
  whiteSpaceString (len - visualLen) ++ s

def padRight (s : String) (len : Nat) (visualLen : Nat) : String :=
  s ++ whiteSpaceString (len - visualLen)

def padCenter (s : String) (len : Nat) (visualLen : Nat) : String :=
  let totalPad := len - visualLen
  let leftPad := totalPad / 2
  let rightPad := totalPad - leftPad
  whiteSpaceString leftPad ++ s ++ whiteSpaceString rightPad

def justifyFull (s : String) (targetLen : Nat) : String :=
  let words := s.splitOn
  match words with
  | [] => ""
  | [w] => w ++ whiteSpaceString (targetLen - visualLength w)
  | _ =>
    let charCount := words.foldl (fun acc w => acc + visualLength w) 0
    let totalSpaces := targetLen - charCount
    let gapCount := words.length - 1

    let baseSpaces := totalSpaces / gapCount
    let extraSpaces := totalSpaces % gapCount

    let rec build (ws : List String) (i : Nat) : String :=
      match ws with
      | [] => ""
      | [last] => last
      | curr :: tail =>
        let spacesForThisGap := if i < extraSpaces then baseSpaces + 1 else baseSpaces
        curr ++ whiteSpaceString spacesForThisGap ++ build tail (i + 1)

    build words 0

def alignLine (width : Nat) (align : Alignment) (lineStr : String) : String :=
  let str := lineStr.trim
  let vLen := visualLength str
  if vLen >= width then lineStr
  else match align with
    | .left   => padRight str width vLen
    | .right  => padLeft str width vLen
    | .center => padCenter str width vLen
    | .full   => justifyFull str width

def chunkString (n : Nat) (s : String) : List String :=
  let chars := s.toList
  ((List.range ((chars.length / n) + 1)).map fun i =>
    String.ofList <|
      chars.drop (i * n) |>.take n).filter (fun s => s != "")

def alignString (width : Nat) (align : Alignment) (s : String) : String :=
  let lines := chunkString width s
  let alignedLines := lines.map (alignLine width align)
  String.intercalate "\n" alignedLines


def alignDoc {ann} (width : Nat) (alignment : Alignment) (doc : Doc ann) : Doc ann :=
    match doc with
    | Doc.text s => Doc.text (alignString width alignment s)
    | Doc.ann a d => Doc.ann a (alignDoc width alignment d)
    | Doc.empty => Doc.empty
    | Doc.concat d1 d2 => Doc.concat (alignDoc width alignment d1) (alignDoc width alignment d2)

end leansi
