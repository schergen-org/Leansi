import leansi.Doc
import leansi.Style
import leansi.Ansi

namespace leansi

def renderStyled (style : Style) (text : String) : String :=
  styleToAnsi style ++ text ++ reset

def Doc.render {ann : Type} : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.concat d1 d2 => d1.render ++ d2.render
  | Doc.ann _ d => d.render

def Doc.renderWithStyle {ann : Type} (toStyle : ann → Style) : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.concat d1 d2 => d1.renderWithStyle toStyle ++ d2.renderWithStyle toStyle
  | Doc.ann a d => renderStyled (toStyle a) (d.renderWithStyle toStyle)

def render (doc : Doc Unit) : String := doc.render

/-- Allow printing `Doc Style` as rendered content. -/
instance : ToString (Doc Style) where
  toString d := d.renderWithStyle id

/-- Allow printing `Doc Unit` (unannotated docs). -/
instance : ToString (Doc Unit) where
  toString d := d.render

end leansi
