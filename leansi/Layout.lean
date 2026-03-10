import leansi.Doc
import leansi.Align
import leansi.Terminal

namespace leansi
namespace Layout

private def joinWith (sep : Doc ann) : List (Doc ann) → Doc ann
  | [] => Doc.empty
  | d :: ds => ds.foldl (fun acc x => acc ++ sep ++ x) d

/-- A single line break. -/
def lineBreak : Doc ann :=
  Doc.text "\n"

/-- Horizontal spacing as plain spaces. -/
def spaces (n : Nat) : Doc ann :=
  Doc.text (whiteSpaceString n)

/-- Concatenate docs horizontally without spacing. -/
def hcat (docs : List (Doc ann)) : Doc ann :=
  joinWith Doc.empty docs

/-- Concatenate docs horizontally with `gap` spaces between docs. -/
def hcatSep (gap : Nat) (docs : List (Doc ann)) : Doc ann :=
  joinWith (spaces gap) docs

/-- Concatenate docs vertically with a single line break between docs. -/
def vcat (docs : List (Doc ann)) : Doc ann :=
  joinWith lineBreak docs

private def concatDocs : Doc ann → Doc ann → Doc ann
  | Doc.empty, d => d
  | d, Doc.empty => d
  | d1, d2 => Doc.concat d1 d2

private def docVisualLength : Doc ann → Nat
  | Doc.empty => 0
  | Doc.text s => visualLength s
  | Doc.ann _ d => docVisualLength d
  | Doc.concat d1 d2 => docVisualLength d1 + docVisualLength d2

private def takeDoc (n : Nat) : Doc ann → Doc ann
  | Doc.empty => Doc.empty
  | Doc.text s => Doc.text (s.take n).toString
  | Doc.ann a d =>
    let t := takeDoc n d
    match t with
    | Doc.empty => Doc.empty
    | _ => Doc.ann a t
  | Doc.concat d1 d2 =>
    let l1 := docVisualLength d1
    if n <= l1 then
      takeDoc n d1
    else
      concatDocs (takeDoc l1 d1) (takeDoc (n - l1) d2)

private def dropDoc (n : Nat) : Doc ann → Doc ann
  | Doc.empty => Doc.empty
  | Doc.text s => Doc.text (s.drop n).toString
  | Doc.ann a d =>
    let r := dropDoc n d
    match r with
    | Doc.empty => Doc.empty
    | _ => Doc.ann a r
  | Doc.concat d1 d2 =>
    let l1 := docVisualLength d1
    if n < l1 then
      concatDocs (dropDoc n d1) d2
    else
      dropDoc (n - l1) d2

private def wrapDocLine (width : Nat) (doc : Doc ann) : List (Doc ann) :=
  let w := max 1 width
  let len := docVisualLength doc
  let chunkCount := max 1 ((len + w - 1) / w)
  (List.range chunkCount).map fun i => takeDoc w (dropDoc (i * w) doc)

private def appendLineLists (l1 l2 : List (Doc ann)) : List (Doc ann) :=
  match l1.reverse, l2 with
  | [], ys => ys
  | xs, [] => xs.reverse
  | last1 :: revInit, first2 :: tail2 =>
    let init := revInit.reverse
    let merged := concatDocs last1 first2
    init ++ (merged :: tail2)

/-- Split a document into logical lines by `\n` while preserving style structure. -/
def splitDocLines : Doc ann → List (Doc ann)
  | Doc.empty => [Doc.empty]
  | Doc.text s => (s.splitOn "\n").map Doc.text
  | Doc.ann a d => (splitDocLines d).map (Doc.ann a)
  | Doc.concat d1 d2 => appendLineLists (splitDocLines d1) (splitDocLines d2)

def handleDocOverflow (width : Nat) (hideOverflow : Bool) (doc : Doc ann) : List (Doc ann) :=
  let w := max 1 width
  ((splitDocLines doc).map fun line =>
      let len := docVisualLength line
      if len <= w then [line]
      else
        if hideOverflow then [takeDoc w line]
        else wrapDocLine w line).foldr (· ++ ·) []

def columns' (colWidth : List Nat) (gap : Nat) (docs : List (Doc ann)) (alignments : List Alignment := []) : Doc ann :=
  let defaultWidth := colWidth.getD (colWidth.length - 1) 10
  let defaultAlign := Alignment.left

  let alignedCols := docs.mapIdx fun idx => (alignDoc (colWidth.getD idx defaultWidth) (alignments.getD idx defaultAlign))
  hcatSep gap alignedCols

/-- Build a simple row of fixed-width columns. -/
def columns (colWidth : List Nat) (gap : Nat) (docs : List (Doc ann)) (alignments : List Alignment := []) (hideOverflow : Bool := false) (useMinRows : Bool := false) : Doc ann :=
  let defaultWidth := colWidth.getD (colWidth.length - 1) 10

  let docsCut := docs.mapIdx fun idx => (handleDocOverflow (colWidth.getD idx defaultWidth) hideOverflow)
  let rowCounts := docsCut.map (·.length)

  let maxRows := rowCounts.foldl (fun a b => if a > b then a else b) 0
  let minRows := match rowCounts with
    | [] => 0
    | x :: xs => xs.foldl (fun a b => if a < b then a else b) x
  let rowCount := if useMinRows then minRows else maxRows

  let cols := (List.range rowCount).map fun idx => columns' colWidth gap (docsCut.map fun x => x.getD idx (Doc.text "")) alignments
  vcat cols

/-- Align to current terminal width if dimensions can be detected. -/
def fitToTerminal (alignment : Alignment) (doc : Doc ann) : IO (Doc ann) := do
  match (← getTerminalDimensions) with
  | some (_, cols) =>
    pure (alignDoc cols alignment doc)
  | none =>
    pure doc

end Layout
end leansi
