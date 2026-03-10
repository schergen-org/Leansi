import leansi.Doc.Core
import leansi.Render.Color

namespace leansi

def Doc.render {ann : Type} : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.concat d1 d2 => d1.render ++ d2.render
  | Doc.ann _ d => d.render

def Doc.renderWithStyle {ann : Type} (toStyle : ann → Style) (colorSupport : ColorSupport) : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.concat d1 d2 => d1.renderWithStyle toStyle colorSupport ++ d2.renderWithStyle toStyle colorSupport
  | Doc.ann a d => renderStyled colorSupport (toStyle a) (d.renderWithStyle toStyle colorSupport)

def render (doc : Doc Unit) : String := doc.render

end leansi
