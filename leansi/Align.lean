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

/-- Merge adjacent text fragments so alignment can work on logical lines
    instead of on each tiny concatenated text node. -/
def coalesceText {ann} : Doc ann → Doc ann
  | Doc.empty => Doc.empty
  | Doc.text s => Doc.text s
  | Doc.ann a d => Doc.ann a (coalesceText d)
  | Doc.concat d1 d2 =>
    let d1' := coalesceText d1
    let d2' := coalesceText d2
    match d1', d2' with
    | Doc.empty, d => d
    | d, Doc.empty => d
    | Doc.text s1, Doc.text s2 => Doc.text (s1 ++ s2)
    | d1'', d2'' => Doc.concat d1'' d2''

private def docTextLength {ann} : Doc ann → Nat
  | Doc.empty => 0
  | Doc.text s => visualLength s
  | Doc.ann _ d => docTextLength d
  | Doc.concat d1 d2 => docTextLength d1 + docTextLength d2

private def plainText {ann} : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.ann _ d => plainText d
  | Doc.concat d1 d2 => plainText d1 ++ plainText d2

private def prependSpaces {ann} (n : Nat) (doc : Doc ann) : Doc ann :=
  if n = 0 then doc else Doc.text (whiteSpaceString n) ++ doc

private def appendSpaces {ann} (doc : Doc ann) (n : Nat) : Doc ann :=
  if n = 0 then doc else doc ++ Doc.text (whiteSpaceString n)

def alignDoc {ann} (width : Nat) (alignment : Alignment) (doc : Doc ann) : Doc ann :=
  let doc' := coalesceText doc
  let len := docTextLength doc'
  match alignment with
  | .left =>
    appendSpaces doc' (width - len)
  | .right =>
    prependSpaces (width - len) doc'
  | .center =>
    let total := width - len
    let leftPad := total / 2
    let rightPad := total - leftPad
    appendSpaces (prependSpaces leftPad doc') rightPad
  | .full =>
    match doc' with
    | Doc.text s => Doc.text (justifyFull s.trimAscii.toString width)
    | Doc.ann a d => Doc.ann a (Doc.text (justifyFull (plainText d).trimAscii.toString width))
    | _ => Doc.text (justifyFull (plainText doc').trimAscii.toString width)

end leansi
