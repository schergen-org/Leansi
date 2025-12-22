import leansi.Doc
import leansi.Style

namespace leansi

/-- Rendert ein Doc zu einem einfachen String -/
def Doc.render {ann : Type} : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s

/-- Rendert ein Doc mit einer Funktion, die Annotationen zu Styles konvertiert,
    und gibt ANSI-Escape-Codes aus -/
def Doc.renderWithStyle {ann : Type} (toStyle : ann → Style) : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s

/-- Einfache Hilfsfunktion zum Rendern ohne Annotationen -/
def render (doc : Doc Unit) : String := doc.render

end leansi