import leansi.Doc.Type
import leansi.Render.Color

namespace leansi

/-- Render a document by ignoring all annotations and concatenating only its text. -/
def Doc.render {ann : Type} : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.concat d1 d2 => d1.render ++ d2.render
  | Doc.ann _ d => d.render

/-- Render a document whose annotations can be interpreted as styles.
The document tree remains abstract until this point; only here are annotations
translated into terminal escape sequences. -/
def Doc.renderWithStyle {ann : Type} (toStyle : ann → Style) (colorSupport : ColorSupport) : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.concat d1 d2 => d1.renderWithStyle toStyle colorSupport ++ d2.renderWithStyle toStyle colorSupport
  | Doc.ann a d => renderStyled colorSupport (toStyle a) (d.renderWithStyle toStyle colorSupport)

/-- Convenience wrapper for rendering unannotated documents. -/
def render (doc : Doc Unit) : String := doc.render

end leansi
