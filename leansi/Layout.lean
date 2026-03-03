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

/-- Build a simple row of fixed-width columns. -/
def columns (colWidth : List Nat) (gap : Nat) (docs : List (Doc ann)) (alignments : List Alignment := []) : Doc ann :=
  let defaultWidth := colWidth.getD (colWidth.length - 1) 10
  let defaultAlign := Alignment.left
  let cols := docs.mapIdx fun idx => (alignDoc (colWidth.getD idx defaultWidth) (alignments.getD idx defaultAlign))
  hcatSep gap cols

/-- Align to current terminal width if dimensions can be detected. -/
def fitToTerminal (alignment : Alignment) (doc : Doc ann) : IO (Doc ann) := do
  match (← getTerminalDimensions) with
  | some (_, cols) =>
    pure (alignDoc cols alignment doc)
  | none =>
    pure doc

end Layout
end leansi
