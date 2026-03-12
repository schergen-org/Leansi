import leansi

open leansi
open leansi.Doc

def main : IO Unit := do
  let colors :=
    Layout.vcat
     [ Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "ANSI16" |> bright_red]
     , Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "ANSI256" |> bright_green]
     , Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "Truecolor, RGB" |> bright_blue]
     , Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "Dumb Terminals" |> bright_yellow]
     , Layout.columns [1, 22] 1 [Doc.text "✓", Doc.text "Automatic Downsampling" |> bright_magenta]
     ]


  let styles :=
    (Doc.text "All ansi styles: ") ++ (Doc.text "bold" |> bold) ++ Doc.text ", " ++
    (Doc.text "dim" |> dim) ++ Doc.text ", " ++
    (Doc.text "italic" |> italic) ++ Doc.text ", " ++
    (Doc.text "underline" |> underline) ++ Doc.text ", " ++
    (Doc.text "strikethrough" |> strikethrough) ++ Doc.text ", " ++
    (Doc.text "reverse" |> reverse) ++ Doc.text ", " ++
    (Doc.text "hidden" |> hidden) ++ Doc.text ", and even " ++
    (Doc.text "blink" |> blink) ++ Doc.text "."


  let alignedText := (Doc.text "Word wrap text. Justify ") ++ (Doc.text "left" |> bright_green) ++ Doc.text ", " ++ (Doc.text "center" |> bright_yellow) ++ Doc.text ", " ++ (Doc.text "right" |> bright_blue) ++ Doc.text ", or even " ++ (Doc.text "full" |> bright_red) ++ Doc.text "."
  let alignedTextDemo :=
    Layout.columns [20] 3
    [ Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." |> bright_green
    , Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et." |> bright_yellow
    , Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore." |> bright_blue
    , Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna." |> bright_red
    ]
    [Alignment.left, Alignment.center, Alignment.right, Alignment.full] false


  let support ← detectColorSupport
  let supportText := (Doc.text "Detected color support: ") ++ (Doc.text s!"{support}" |> bold |> bright_cyan)


  let dims ← leansi.getTerminalDimensions
  let dimsResult := match dims with
  | some (rows, cols) => ((Doc.text s!"{rows}" |> bright_green) ++ (Doc.text " rows, ") ++ (Doc.text s!"{cols}" |> bright_blue) ++ (Doc.text " cols"))
  | none => (Doc.text "Failed to detect Terminal-Dimensions" |> bright_red)


  -- Custom config: wider bar, no brackets, custom chars
  let customConfig : leansi.ProgressBarConfig := {
    width := 22
    filled := '▓'
    empty := '·'
    brackets := none
    thresholds := [
      { upperBound := 50, color := ColorLevel.truecolor (255, 100, 100) },
      { upperBound := 100, color := ColorLevel.truecolor (100, 255, 100) }
    ]
  }
  let progressBars :=
    Layout.vcat
    [ Doc.text "Battery:   " ++ progressBar {} 15
    , Doc.text "Upload:    " ++ progressBar {} 50
    , Doc.text "Download:  " ++ progressBar {} 100
    , Doc.text "Custom:    " ++ progressBar customConfig 65
    ]

  let boxedDocs :=
    Layout.vcat
    [ Layout.columns [40] 3
      [ box
          (Layout.vcat
            [ Doc.text "Leansi can draw boxes around docs."
            , Doc.text "Title placement is configurable."
            ])
          {
            title := some (Doc.text "Unicode Box" |> bright_cyan |> bold)
            borderStyle := { fg := some (ColorLevel.truecolor (120, 190, 255)) }
            titleAlignment := Alignment.center
            paddingX := 2
            paddingY := 1
          }
      , box
          (Doc.text "ASCII fallback works as well.\nHas to be manually enabled.\nRetro!")
          {
            title := some (Doc.text "ASCII")
            chars := asciiBoxChars
            borderStyle := { fg := some (ColorLevel.truecolor (255, 180, 120)) }
            titleAlignment := Alignment.left
          }
      ]
    , Doc.empty
    , Layout.columns [40] 3
      [ box
          (Doc.text "Rounded corners are available too.\n...if your terminal supports them.")
          {
            title := some (Doc.text "Rounded")
            chars := roundedBoxChars
            borderStyle := { fg := some (ColorLevel.truecolor (160, 220, 170)) }
            titleAlignment := Alignment.right
            paddingX := 2
            maxWidth := 40
          }
      , box
        (box
          (Doc.text "Boxes inside boxes!")
          { title := some (Doc.text "Inner Box" |> bright_magenta) , chars := roundedBoxChars, borderStyle := {fg := some (ColorLevel.truecolor (255, 120, 255)) }}
        )
        { title := some (Doc.text "Outer Box" |> bright_cyan), borderStyle := {fg := some (ColorLevel.truecolor (120, 255, 255))}, paddingX := 0, paddingY := 0 }
      ]
    ]

  let layout :=
    Layout.vcat
     [ Layout.columns [1, 30] 1 [Doc.text "✓", Doc.text "Vertical Concatination" |> cyan]
     , Layout.columns [1, 30] 1 [Doc.text "✓", Doc.text "Horizontal Concatination" |> bright_green]
     , Layout.columns [1, 30] 1 [Doc.text "✓", Doc.text "Columns" |> yellow]
     , Doc.empty
     , Layout.columns [5, 50] 1 [Doc.text "Psst!" |> dim , Doc.text "These functions are used for all the examples" |> bright_blue |> dim]
     ]


  let examples :=
    Layout.vcat
      [ Layout.columns [105] 3 [Doc.text "L E A N S I" |> bright_red |> bold] [Alignment.center] true
      , Doc.empty, Doc.empty
      , Layout.columns [15, 90] 3 [Doc.text "Colors" |> bright_red, colors] [Alignment.center, Alignment.left] true
      , Doc.empty , Doc.empty
      , Layout.columns [15, 100] 3 [Doc.text "Styles" |> bright_red, styles] [Alignment.center, Alignment.left] true
      , Doc.empty, Doc.empty
      , Layout.columns [15, 90] 3 [Doc.text "Align" |> bright_red, Layout.vcat [alignedText, Doc.empty, alignedTextDemo] ] [Alignment.center, Alignment.left] true
      , Doc.empty, Doc.empty
      , Layout.columns [15, 90] 3 [Doc.text "Terminal Info" |> bright_red, supportText] [Alignment.center, Alignment.left] true
      , Doc.empty, Doc.empty
      , Layout.columns [15, 90] 3 [Doc.text "Terminal\nDimensions" |> bright_red, dimsResult] [Alignment.center, Alignment.left] true
      , Doc.empty, Doc.empty
      , Layout.columns [15, 90] 3 [Doc.text "Progress Bars" |> bright_red, progressBars] [Alignment.center, Alignment.left] true
      , Doc.empty, Doc.empty
      , Layout.columns [15, 90] 3 [Doc.text "Boxes" |> bright_red, boxedDocs] [Alignment.center, Alignment.left] true
      , Doc.empty, Doc.empty
      , Layout.columns [15,90] 3 [Doc.text "Layout" |> bright_red, layout] [Alignment.center, Alignment.left] true
      , Doc.empty, Doc.empty
      , Layout.columns [15, 90] 3 [Doc.text "And More!" |> bright_red, Doc.text "This is just the beginning. The library is still in early development, and there are many more features and improvements to come. Stay tuned for updates!" |> bright_green] [Alignment.center, Alignment.left] false
      ]
  println examples
