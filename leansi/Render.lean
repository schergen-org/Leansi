import leansi.Doc
import leansi.Style
import leansi.Ansi

namespace leansi

def Doc.render {ann : Type} : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s

def Doc.renderWithStyle {ann : Type} (toStyle : ann → Style) : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s

def render (doc : Doc Unit) : String := doc.render

def renderStyled (style : Style) (text : String) : String :=
  styleToAnsi style ++ text ++ reset

end leansi
