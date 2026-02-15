import leansi.Doc
import leansi.Style
import leansi.Ansi
import leansi.Terminal
import leansi.Downsampling

namespace leansi

def convertColorLevel (colorSupport : ColorSupport) : ColorLevel → ColorLevel
  | ColorLevel.truecolor (r, g, b) =>
    match colorSupport with
    | ColorSupport.truecolor => ColorLevel.truecolor (r, g, b)
    | ColorSupport.ansi256 => ColorLevel.ansi256 (trueColorToAnsi256 r g b)
    | ColorSupport.ansi16 => ColorLevel.ansi16 (trueColorToAnsi16 r g b)
    | ColorSupport.none => ColorLevel.none
  | ColorLevel.ansi256 n =>
    match colorSupport with
    | ColorSupport.ansi16 => ColorLevel.ansi16 (ansi256ToAnsi16 n)
    | ColorSupport.none => ColorLevel.none
    | _ => ColorLevel.ansi256 n
  | ColorLevel.ansi16 n =>
    match colorSupport with
    | ColorSupport.none => ColorLevel.none
    | _ => ColorLevel.ansi16 n
  | other => other

def getSupportedStyle (colorSupport : ColorSupport) (style : Style) : Style :=
  match colorSupport with
  | ColorSupport.none => {} -- when the terminal has no colorsupport there is no style
  | _ =>
    let fg' := style.fg.map (convertColorLevel colorSupport)
    let bg' := style.bg.map (convertColorLevel colorSupport)
    {style with fg := fg', bg := bg'}

def renderStyled (style : Style) (text : String) : String :=
  styleToAnsi style ++ text ++ reset

def Doc.render {ann : Type} : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.concat d1 d2 => d1.render ++ d2.render
  | Doc.ann _ d => d.render

def Doc.renderWithStyle {ann : Type} (toStyle : ann → Style) (colorSupport : ColorSupport) : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.concat d1 d2 => d1.renderWithStyle toStyle colorSupport ++ d2.renderWithStyle toStyle colorSupport
  | Doc.ann a d => (renderStyled (getSupportedStyle colorSupport (toStyle a))) (d.renderWithStyle toStyle colorSupport)

def render (doc : Doc Unit) : String := doc.render

def println (d : Doc Style) : IO Unit := do
  let level ← detectColorSupport
  IO.println (d.renderWithStyle id level)

def print (d : Doc Style) : IO Unit := do
  let level ← detectColorSupport
  IO.print (d.renderWithStyle id level)


end leansi
