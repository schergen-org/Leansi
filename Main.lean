import leansi.Doc
import leansi.Style
import leansi.Render
import leansi.Terminal

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

-- Wo wird colorLevel gespeichert / wie darauf zugegriffen


-- Terminal color level detection
  let support ← detectColorSupport
  IO.println s!"Detected color support: {support}"
