import leansi.Doc.DocOps

namespace leansi

inductive Alignment where
  | left
  | right
  | center
  | full

/-- Stretch a plain-text line to `targetLen` by redistributing spaces between words.
This is a simple justification algorithm tailored to terminal output, not to
high-quality typesetting. -/
def justifyFull (s : String) (targetLen : Nat) : String :=
  let words := s.splitOn " "
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

private def prependSpaces {ann} (n : Nat) (doc : Doc ann) : Doc ann :=
  if n = 0 then doc else Doc.text (whiteSpaceString n) ++ doc

private def appendSpaces {ann} (doc : Doc ann) (n : Nat) : Doc ann :=
  if n = 0 then doc else doc ++ Doc.text (whiteSpaceString n)

/-- Align a document to a fixed width.
Left, right, and center alignment preserve the original document structure and add
padding around it. Full alignment works on the plain text because redistributing
internal spaces changes the content itself. -/
def alignDoc {ann} (width : Nat) (alignment : Alignment) (doc : Doc ann) : Doc ann :=
  let doc' := coalesceText doc
  let len := docVisualLength doc'
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
