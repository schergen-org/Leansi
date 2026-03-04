import leansi.Doc
import leansi.Style
import leansi.Render
import leansi.Terminal
import leansi.Align
import leansi.Layout

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



  let colors :=
    Layout.vcat
      [ Layout.hcatSep 1 [Doc.text "✓", Doc.text "ANSI16" |> bright_red]
      , Layout.hcatSep 1 [Doc.text "✓", Doc.text "ANSI256" |> bright_green]
      , Layout.hcatSep 1 [Doc.text "✓", Doc.text "Truecolor, RGB" |> bright_blue]
      , Layout.hcatSep 1 [Doc.text "✓", Doc.text "Dumb Terminals" |> bright_yellow]
      , Layout.hcatSep 1 [Doc.text "✓", Doc.text "Automatic Downsampling" |> bright_magenta]
      ]

  let examples :=
    Layout.vcat
      [ Layout.columns [10, 20] 0 [Doc.text "Colors" |> bright_red, colors] [Alignment.center, Alignment.left] true

      ]

  println examples
