import leansi.Doc.Type
import leansi.Style.Styling

namespace leansi
namespace Doc

/-- Makes text appear **bold** -/
def bold (doc : Doc Style) : Doc Style := doc.ann Style.bold
/-- Makes text appear <u>underlined</u> -/
def underline (doc : Doc Style) : Doc Style := doc.ann Style.underline
/-- Makes text appear *italic* -/
def italic (doc : Doc Style) : Doc Style := doc.ann Style.italic
/-- Makes text appear dim -/
def dim (doc : Doc Style) : Doc Style := doc.ann Style.dim
/-- Makes text appear blinking -/
def blink (doc : Doc Style) : Doc Style := doc.ann Style.blink
/-- Reverses the colors of the text -/
def reverse (doc : Doc Style) : Doc Style := doc.ann Style.reverse
/-- Hides the text -/
def hidden (doc : Doc Style) : Doc Style := doc.ann Style.hidden
/-- Makes the text appear strikethrough -/
def strikethrough (doc : Doc Style) : Doc Style := doc.ann Style.strikethrough

/-- Makes text appear black -/
def black (doc : Doc Style) : Doc Style := doc.ann Style.black
/-- Makes text appear red -/
def red (doc : Doc Style) : Doc Style := doc.ann Style.red
/-- Makes text appear green -/
def green (doc : Doc Style) : Doc Style := doc.ann Style.green
/-- Makes text appear yellow -/
def yellow (doc : Doc Style) : Doc Style := doc.ann Style.yellow
/-- Makes text appear blue -/
def blue (doc : Doc Style) : Doc Style := doc.ann Style.blue
/-- Makes text appear magenta -/
def magenta (doc : Doc Style) : Doc Style := doc.ann Style.magenta
/-- Makes text appear cyan -/
def cyan (doc : Doc Style) : Doc Style := doc.ann Style.cyan
/-- Makes text appear white -/
def white (doc : Doc Style) : Doc Style := doc.ann Style.white

/-- Makes text appear grey -/
def bright_black (doc : Doc Style) : Doc Style := doc.ann Style.bright_black
/-- Makes text appear grey -/
def grey := bright_black
/-- Makes text appear gray -/
def gray := bright_black

/-- Makes text appear bright red -/
def bright_red (doc : Doc Style) : Doc Style := doc.ann Style.bright_red
/-- Makes text appear bright green -/
def bright_green (doc : Doc Style) : Doc Style := doc.ann Style.bright_green
/-- Makes text appear bright yellow -/
def bright_yellow (doc : Doc Style) : Doc Style := doc.ann Style.bright_yellow
/-- Makes text appear bright blue -/
def bright_blue (doc : Doc Style) : Doc Style := doc.ann Style.bright_blue
/-- Makes text appear bright magenta -/
def bright_magenta (doc : Doc Style) : Doc Style := doc.ann Style.bright_magenta
/-- Makes text appear bright cyan -/
def bright_cyan (doc : Doc Style) : Doc Style := doc.ann Style.bright_cyan
/-- Makes text appear bright white -/
def bright_white (doc : Doc Style) : Doc Style := doc.ann Style.bright_white

/-- Makes background appear black -/
def bg_black (doc : Doc Style) : Doc Style := doc.ann Style.bg_black
/-- Makes background appear red -/
def bg_red (doc : Doc Style) : Doc Style := doc.ann Style.bg_red
/-- Makes background appear green -/
def bg_green (doc : Doc Style) : Doc Style := doc.ann Style.bg_green
/-- Makes background appear yellow -/
def bg_yellow (doc : Doc Style) : Doc Style := doc.ann Style.bg_yellow
/-- Makes background appear blue -/
def bg_blue (doc : Doc Style) : Doc Style := doc.ann Style.bg_blue
/-- Makes background appear magenta -/
def bg_magenta (doc : Doc Style) : Doc Style := doc.ann Style.bg_magenta
/-- Makes background appear cyan -/
def bg_cyan (doc : Doc Style) : Doc Style := doc.ann Style.bg_cyan
/-- Makes background appear white -/
def bg_white (doc : Doc Style) : Doc Style := doc.ann Style.bg_white

/-- Makes background appear grey -/
def bg_bright_black (doc : Doc Style) : Doc Style := doc.ann Style.bg_bright_black
/-- Makes background appear grey -/
def bg_grey := bg_bright_black
/-- Makes background appear gray -/
def bg_gray := bg_bright_black

/-- Makes background appear bright red -/
def bg_bright_red (doc : Doc Style) : Doc Style := doc.ann Style.bg_bright_red
/-- Makes background appear bright green -/
def bg_bright_green (doc : Doc Style) : Doc Style := doc.ann Style.bg_bright_green
/-- Makes background appear bright yellow -/
def bg_bright_yellow (doc : Doc Style) : Doc Style := doc.ann Style.bg_bright_yellow
/-- Makes background appear bright blue -/
def bg_bright_blue (doc : Doc Style) : Doc Style := doc.ann Style.bg_bright_blue
/-- Makes background appear bright magenta -/
def bg_bright_magenta (doc : Doc Style) : Doc Style := doc.ann Style.bg_bright_magenta
/-- Makes background appear bright cyan -/
def bg_bright_cyan (doc : Doc Style) : Doc Style := doc.ann Style.bg_bright_cyan
/-- Makes background appear bright white -/
def bg_bright_white (doc : Doc Style) : Doc Style := doc.ann Style.bg_bright_white

/-- Set foreground color using ANSI 256 palette indices. -/
def fg_ansi_256 (color : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann (Style.fg_ansi_256 color s)

/-- Set background color using ANSI 256 palette indices. -/
def bg_ansi_256 (color : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann (Style.bg_ansi_256 color s)

/-- Set foreground color using an RGB triple.
The value is stored as truecolor and may be downsampled only when rendering to a
terminal with weaker color support. -/
def fg_rgb (r g b : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann (Style.fg_rgb r g b s)

/-- Set background color using an RGB triple. -/
def bg_rgb (r g b : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann (Style.bg_rgb r g b s)

end Doc
end leansi
