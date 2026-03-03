import leansi.Doc
import leansi.Style
import leansi.Render
import leansi.Terminal
import leansi.Align
import leansi.Layout

open leansi
open leansi.Doc

def main : IO Unit := do
  -- Doc Beispiele
  let emptyDoc : leansi.Doc Unit := leansi.Doc.empty
  let textDoc : leansi.Doc Unit := leansi.Doc.text "Hallo, leansi!"

  -- rendern
  IO.println s!"Empty Doc: '{emptyDoc.render}'"
  IO.println s!"Text Doc: '{textDoc.render}'"

  --let greeting := Doc.text "Willkommen zur leansi-Bibliothek!"
  --IO.println s!"Greeting: '{render greeting}'"

  println ((Doc.text "This is bold text.").bold.underline)
  -- IO.println ((Doc.bold.text "This is bold text."))
  -- IO.println ((Doc.bold.underline).text "This is bold and underlined text.")

  -- IO.println (Doc.bg_blue.underline.s "This text has a blue background and is underlined.")

  println ((Doc.text "some text" |> bold |> underline |> bright_green) ++ (Doc.text " and some cyan text." |> italic |> cyan |> bg_grey))

  println (Doc.text "Ansi 256 test code: 54" |> fg_ansi_256 54 |> bg_ansi_256 200)
  println (Doc.text "Ansi 256 test code: 55" |> fg_ansi_256 55)
  println (Doc.text "Ansi 256 test code: 56" |> fg_ansi_256 56)
  println (Doc.text "Ansi 256 test code: 57" |> fg_ansi_256 57 )

  println (Doc.text "Ansi 256 test code: 54" |> bg_ansi_256 154 |> underline |> red)
  println (Doc.text "Ansi 256 test code: 55" |> bg_ansi_256 155)
  println (Doc.text "Ansi 256 test code: 56" |> bg_ansi_256 156)
  println (Doc.text "Ansi 256 test code: 57" |> bg_ansi_256 157)


  println (Doc.text "RGB test 1" |> fg_rgb 100 150 200)
  println (Doc.text "RGB test 2" |> bg_rgb 255 0 0)
  println (Doc.text "RGB test 3" |> bg_rgb 0 255 0)
  println (Doc.text "RGB test 4" |> bg_rgb 0 0 255)

  println (alignDoc 80 Alignment.left <| Doc.text "Dies ist ein längerer Beispieltext, der linksbündig ausgerichtet ist. Er sollte am rechten Rand mit Leerzeichen aufgefüllt werden, damit die Zeile genau 80 Zeichen breit ist.")

  IO.println ""

  println (Doc.text "Dies ist ein längerer Beispieltext, der im Blocksatz ausgerichtet ist. Er sollte so angepasst werden, dass die Wörter gleichmäßig über die gesamte Zeilenbreite verteilt sind, um eine saubere und professionelle Optik zu erzielen." |> alignDoc 80 Alignment.full)

  IO.println ""

  println (alignDoc 80 Alignment.center <| Doc.text "Dies ist ein längerer Beispieltext, der zentriert ausgerichtet ist. Er sollte so angepasst werden, dass die Wörter gleichmäßig über die gesamte Zeilenbreite verteilt sind, um eine saubere und professionelle Optik zu erzielen." |> blue |> bold)

  IO.println ""

    -- Layout Beispiele
  IO.println "Layout examples:"

  let header :=
    Layout.hcatSep 1
      [ Doc.text "Status:" |> bold
      , Doc.text "OK" |> bright_green
      ]
  println header

  let featureList :=
    Layout.vcat
      [ Doc.text "Features" |> bold |> cyan
      , Layout.hcatSep 5
          [ Doc.text "- Styling"
          , Doc.text "- Align"
          , Doc.text "- Layout"
          ]
      ]
  println featureList

  let tableHeader :=
    Layout.columns [18]  3
      [ Doc.text "Package" |> bold
      , Doc.text "Component" |> bold
      , Doc.text "State" |> bold
      ]
      [Alignment.left, Alignment.center, Alignment.right]
  let tableRow1 :=
    Layout.columns [18] 3
      [ Doc.text "leansi-core"
      , Doc.text "renderer"
      , Doc.text "ready" |> bright_green
      ] []
  let tableRow2 :=
    Layout.columns [18] 3
      [ Doc.text "leansi-ui"
      , Doc.text "layout"
      , Doc.text "in progress" |> bright_yellow
      ]
  println (Layout.vcat [tableHeader, tableRow1, tableRow2])

  let centeredBanner ←
    Layout.fitToTerminal Alignment.center
      (Doc.text "Simple Layout Demo" |> bold |> bright_cyan)
  println centeredBanner

  -- Neofetch mockup (fake values)
  let infoRow (key value : String) : Doc Style :=
    Layout.columns [7,20] 2
      [ Doc.text (key ++ ":") |> bold |> bright_blue
      , Doc.text value |> bright_white
      ]

  let neofetchMock :=
    Layout.vcat
      [ Layout.hcatSep 4 [Doc.text "   ____   " |> bright_cyan, infoRow "User" "marvin@leanbox"]
      , Layout.hcatSep 4 [Doc.text "  / __ \\  " |> bright_cyan, infoRow "OS" "LeanixOS 1.0 (Mock)"]
      , Layout.hcatSep 4 [Doc.text " / /  \\ \\ " |> bright_cyan, infoRow "Host" "Terminal-Dev-15"]
      , Layout.hcatSep 4 [Doc.text "| |    | |" |> bright_cyan, infoRow "Kernel" "6.1.0-mock"]
      , Layout.hcatSep 4 [Doc.text "| |    | |" |> bright_cyan, infoRow "Uptime" "3 days, 7 hours"]
      , Layout.hcatSep 4 [Doc.text " \\ \\__/ / " |> bright_cyan, infoRow "Shell" "bash 5.2"]
      , Layout.hcatSep 4 [Doc.text "  \\____/  " |> bright_cyan, infoRow "Memory" "6.2 GiB / 16 GiB"]
      , Layout.hcatSep 4 [Doc.text "          " |> bright_cyan, infoRow "Theme" "Leansi Light"]
      ]
  println neofetchMock

  IO.println ""

  let testRow := Layout.columns [3, 3, 3] 1
    [ Doc.text "12345" |> red
    , Doc.text "123" |> green
    , Doc.text "123456789" |> blue
    ]
    [Alignment.center, Alignment.center, Alignment.center] false

  let testRow2 := Layout.columns [3, 3, 3] 1
    [ Doc.text "123" |> red
    , Doc.empty |> green
    , Doc.text "1234567" |> blue
    ]
    [Alignment.center, Alignment.center, Alignment.center] true

  println testRow
  println testRow

  println testRow2

-- Terminal color level detection
  let support ← detectColorSupport
  IO.println s!"Detected color support: {support}"

-- Terminal dimensions detection
  let dims ← leansi.getTerminalDimensions
  match dims with
  | some (rows, cols) => IO.println s!"Terminal: {rows} rows, {cols} cols"
  | none => IO.println "Failed to detect terminal dimensions"
