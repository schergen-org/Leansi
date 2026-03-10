import leansi.Style.Types
import leansi.Ansi.Encode
import leansi.Terminal.ColorSupport
import leansi.Color.Downsampling

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

def renderStyled (colorSupport : ColorSupport) (style : Style) (text : String) : String :=
  match colorSupport with
  | ColorSupport.none => text
  | _ =>
    let fg' := style.fg.map (convertColorLevel colorSupport)
    let bg' := style.bg.map (convertColorLevel colorSupport)
    styleToAnsi {style with fg := fg', bg := bg'} ++ text ++ reset

end leansi
