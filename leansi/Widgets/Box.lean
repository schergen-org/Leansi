import leansi.Doc.DocOps
import leansi.Align.AlignCore
import leansi.Util
import leansi.Layout.LayoutCore

namespace leansi

/-- Characters used to draw a text box border. -/
structure BoxChars where
  topLeft : Char := '┌'
  topRight : Char := '┐'
  bottomLeft : Char := '└'
  bottomRight : Char := '┘'
  horizontal : Char := '─'
  vertical : Char := '│'
deriving Repr, Inhabited, BEq

/-- ASCII fallback border characters for environments where Unicode line-art is undesired. -/
def asciiBoxChars : BoxChars := {
  topLeft := '+'
  topRight := '+'
  bottomLeft := '+'
  bottomRight := '+'
  horizontal := '-'
  vertical := '|'
}

/-- Rounded Unicode border characters for a softer visual style. -/
def roundedBoxChars : BoxChars := {
  topLeft := '╭'
  topRight := '╮'
  bottomLeft := '╰'
  bottomRight := '╯'
  horizontal := '─'
  vertical := '│'
}

/-- Configuration for rendering boxed documents. -/
structure BoxConfig where
  /-- Border glyph set used for top/bottom lines and side walls. -/
  chars : BoxChars := {}
  /-- Style applied to border characters only. -/
  borderStyle : Style := {}
  /-- Optional title drawn into the top border with one space on each side. -/
  title : Option (Doc Style) := none
  /-- Placement of the title inside the available top border width. -/
  titleAlignment : Alignment := Alignment.center
  /-- Horizontal padding between the content and the border. -/
  paddingX : Nat := 1
  /-- Vertical padding rows above and below the content. -/
  paddingY : Nat := 0
  /-- Minimum inner width (excluding padding and border). -/
  minInnerWidth : Nat := 0

namespace Box

/-- Render one styled border glyph. -/
private def borderText (cfg : BoxConfig) (c : Char) : Doc Style :=
  (Doc.text (toString c)).ann cfg.borderStyle

/-- Render a horizontal border segment with `n` repeated border characters. -/
private def borderRun (cfg : BoxConfig) (n : Nat) : Doc Style :=
  (Doc.text (repeatChar cfg.chars.horizontal n)).ann cfg.borderStyle

/-- Render an unstyled repeated character run (used for space padding). -/
private def plainRun (c : Char) (n : Nat) : Doc Style :=
  Doc.text (repeatChar c n)

/-- Compute the width of the widest logical content line. -/
private def maxLineWidth (lines : List (Doc Style)) : Nat :=
  lines.foldl (fun acc line => max acc (docVisualLength line)) 0

/-- Return title width including the surrounding spaces inserted in the border. -/
private def titleLength (title : Option (Doc Style)) : Nat :=
  match title with
  | none => 0
  | some t => docVisualLength t + 2

/-- Build the top border line, optionally embedding the title. -/
private def topBorder (cfg : BoxConfig) (contentWidth : Nat) : Doc Style :=
  let borderWidth := contentWidth + (cfg.paddingX * 2)
  let leftCorner := borderText cfg cfg.chars.topLeft
  let rightCorner := borderText cfg cfg.chars.topRight
  match cfg.title with
  | none =>
    leftCorner ++ borderRun cfg borderWidth ++ rightCorner
  | some title =>
    let titleDoc := Doc.text " " ++ title ++ Doc.text " "
    let tLen := docVisualLength titleDoc
    let fill := borderWidth - tLen
    let leftFill :=
      match cfg.titleAlignment with
      | Alignment.left => 0
      | Alignment.center => fill / 2
      | Alignment.right => fill
      | Alignment.full => fill / 2
    let rightFill := fill - leftFill
    leftCorner ++ borderRun cfg leftFill ++ titleDoc ++ borderRun cfg rightFill ++ rightCorner

/-- Build one boxed content row with horizontal padding and width fill. -/
private def contentLine (cfg : BoxConfig) (contentWidth : Nat) (line : Doc Style) : Doc Style :=
  let leftBorder := borderText cfg cfg.chars.vertical
  let rightBorder := borderText cfg cfg.chars.vertical
  let sidePadding := plainRun ' ' cfg.paddingX
  let lineLen := docVisualLength line
  let rightPadding := plainRun ' ' (contentWidth - lineLen)
  leftBorder ++ sidePadding ++ line ++ rightPadding ++ sidePadding ++ rightBorder

/-- Build an empty boxed row used for vertical padding. -/
private def emptyContentLine (cfg : BoxConfig) (contentWidth : Nat) : Doc Style :=
  contentLine cfg contentWidth Doc.empty

/-- Build the bottom border line. -/
private def bottomBorder (cfg : BoxConfig) (contentWidth : Nat) : Doc Style :=
  let borderWidth := contentWidth + (cfg.paddingX * 2)
  borderText cfg cfg.chars.bottomLeft ++ borderRun cfg borderWidth ++ borderText cfg cfg.chars.bottomRight

end Box

/-- Draw a box around a styled document with optional title and configurable border style. -/
def box (content : Doc Style) (cfg : BoxConfig := {}) : Doc Style :=
  let lines := splitDocLines content
  let contentWidth := Box.maxLineWidth lines
  let minForTitle := (Box.titleLength cfg.title) - (cfg.paddingX * 2)
  let innerWidth := max cfg.minInnerWidth (max contentWidth minForTitle)

  let paddingLines := (List.range cfg.paddingY).map (fun _ => Box.emptyContentLine cfg innerWidth)
  let contentLines := lines.map (Box.contentLine cfg innerWidth)

  Layout.vcat ([Box.topBorder cfg innerWidth] ++ paddingLines ++ contentLines ++ paddingLines ++ [Box.bottomBorder cfg innerWidth])

end leansi
