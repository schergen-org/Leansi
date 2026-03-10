import leansi.Doc
import leansi.Style
import leansi.Render
import leansi.Terminal
import leansi.Align
import leansi.Layout
import leansi.Progressbar

open leansi
open leansi.Doc

def main : IO Unit := do
-- Examples ab hier
  -- let colors :=
  --   Layout.vcat
  --     [ Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "ANSI16" |> bright_red]
  --     , Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "ANSI256" |> bright_green]
  --     , Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "Truecolor, RGB" |> bright_blue]
  --     , Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "Dumb Terminals" |> bright_yellow]
  --     , Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "Automatic Downsampling" |> bright_magenta]
  --     ]


  -- let examples :=
  --   Layout.vcat
  --     [ Layout.columns [10, 20] 0 [Doc.text "Colors" |> bright_red, colors] [Alignment.center, Alignment.left] true

  --     ]
  -- println examples

  let header :=
    alignDoc 80 Alignment.center <| Doc.text "L E A N S I" |> bright_red |> bold
  println header
  println (Doc.text "\n")


  let colors :=
    Layout.vcat
      [ Layout.hcatSep 1 [Doc.text "✓", Doc.text "ANSI16" |> bright_red]
      , Layout.hcatSep 1 [Doc.text "✓", Doc.text "ANSI256" |> bright_green]
      , Layout.hcatSep 1 [Doc.text "✓", Doc.text "Truecolor, RGB" |> bright_blue]
      , Layout.hcatSep 1 [Doc.text "✓", Doc.text "Dumb Terminals" |> bright_yellow]
      , Layout.hcatSep 1 [Doc.text "✓", Doc.text "Automatic Downsampling" |> bright_magenta]
      ]
  println colors
  println (Doc.text "\n")



  let styles :=
    (Doc.text "All ansi styles: ") ++ (Doc.text "bold" |> bold) ++ Doc.text ", " ++
    (Doc.text "dim" |> dim) ++ Doc.text ", " ++
    (Doc.text "italic" |> italic) ++ Doc.text ", " ++
    (Doc.text "underline" |> underline) ++ Doc.text ", " ++
    (Doc.text "underline" |> underline) ++ Doc.text ", " ++
    (Doc.text "strikethrough" |> strikethrough) ++ Doc.text ", " ++
    (Doc.text "reverse" |> reverse) ++ Doc.text ", " ++
    (Doc.text "hidden" |> hidden) ++ Doc.text ", and even " ++
    (Doc.text "blink" |> blink) ++ Doc.text "."
  println styles
  println (Doc.text "\n")



  let alignedText := (Doc.text "Word wrap text. Justify ") ++ (Doc.text "left" |> bright_green) ++ Doc.text ", " ++ (Doc.text "center" |> bright_yellow) ++ Doc.text ", " ++ (Doc.text "right" |> bright_blue) ++ Doc.text ", or even " ++ (Doc.text "full" |> bright_red) ++ Doc.text "."
  let alignedTextDemo :=
    Layout.columns [20] 3
    [ Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." |> bright_green
    , Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et." |> bright_yellow
    , Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore." |> bright_blue
    , Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna." |> bright_red
    ]
    [Alignment.left, Alignment.center, Alignment.right, Alignment.full] false
  println alignedText
  println alignedTextDemo
  println (Doc.text "\n")



  let support ← detectColorSupport
  let supportText := (Doc.text "Detected color support: ") ++ (Doc.text s!"{support}" |> bold |> bright_cyan)
  println supportText
  println (Doc.text "\n")



  let dims ← leansi.getTerminalDimensions
  match dims with
  | some (rows, cols) => println (Doc.text (s!"Terminal-Dimensions: ") ++ (Doc.text s!"{rows}" |> bright_green) ++ (Doc.text " rows, ") ++ (Doc.text s!"{cols}" |> bright_blue) ++ (Doc.text " cols"))
  | none => println (Doc.text "Failed to detect Terminal-Dimensions" |> bright_red)
  println (Doc.text "\n")

  let more := (Doc.text "+more! \t" |> bright_red |> bold) ++ (Doc.text "Progress bars, columns, lists, and more coming soon!")
  println more

  println (Doc.text "\n")

  -- Progress bar examples
  let pbHeader := Doc.text "Progress Bars:" |> bold |> bright_cyan
  println pbHeader

  -- Simple progress bar
  println (Doc.text "Simple:    " ++ simpleProgressBar 20 75)

  -- Low battery example (threshold → red)
  println (Doc.text "Battery:   " ++ progressBar {} 15)

  -- Medium (threshold → yellow)
  println (Doc.text "Upload:    " ++ progressBar {} 50)

  -- Full (threshold → green)
  println (Doc.text "Download:  " ++ progressBar {} 100)

  -- Custom config: wider bar, no brackets, custom chars
  let customConfig : leansi.ProgressBarConfig := {
    width := 30
    filled := '▓'
    empty := '·'
    brackets := none
    thresholds := [
      { upperBound := 50, color := ColorLevel.truecolor (255, 100, 100) },
      { upperBound := 100, color := ColorLevel.truecolor (100, 255, 100) }
    ]
  }
  println (Doc.text "Custom:    " ++ progressBar customConfig 65)
