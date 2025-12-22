import leansi.Doc
import leansi.Style
import leansi.Render

open leansi

def main : IO Unit := do
  -- Doc Beispiele
  let emptyDoc : leansi.Doc Unit := leansi.Doc.empty
  let textDoc : leansi.Doc Unit := leansi.Doc.text "Hallo, leansi!"
  
  -- rendern
  IO.println s!"Empty Doc: '{emptyDoc.render}'"
  IO.println s!"Text Doc: '{textDoc.render}'"

  let greeting := Doc.text "Willkommen zur leansi-Bibliothek!"
  IO.println s!"Greeting: '{render greeting}'"

  -- Roter Text!
  IO.println (renderStyled Style.red "Frohe Weihnachten!")

    -- Kombinationen
  IO.println (renderStyled { Style.red with bold := true } "Rot und Fett!")
  IO.println (renderStyled Style.green "Grüner Text!")
  IO.println (renderStyled Style.blue "Blauer Text!")
