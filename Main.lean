import leansi.Doc
import leansi.Style
import leansi.Render

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

  -- Roter Text!
  IO.println (renderStyled Style.red "Frohe Weihnachten!")

  -- Kombinationen
  IO.println (renderStyled { Style.red with bold := true } "Rot und Fett!")
  IO.println (renderStyled Style.green "Grüner Text!")
  IO.println (renderStyled Style.blue "Blauer Text!")

  IO.println (renderStyled Style.boldStyle "Just bold?")

  IO.println (renderStyled Style.boldStyle.italicStyle.underlineStyle.green.black "Some test text with multiple styles.")

  -- Doc
  let testDoc : Doc Style := (Doc.text "Test tecxt with style.").ann Style.boldStyle.underlineStyle.green

  IO.println (testDoc)

  IO.println ((Doc.text "This is bold text.").bold.underline)
  -- IO.println ((Doc.bold.text "This is bold text."))
  -- IO.println ((Doc.bold.underline).text "This is bold and underlined text.")

  -- IO.println (Doc.bg_blue.underline.s "This text has a blue background and is underlined.")

  IO.println ((Doc.text "some text" |> bold |> underline |> yellow).concat (Doc.text " and some cyan text." |> italic |> cyan |> bg_magenta))
