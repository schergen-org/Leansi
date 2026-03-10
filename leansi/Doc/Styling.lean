import leansi.Doc.Type

namespace leansi
namespace Doc

/-- Makes text appear **bold** -/
def bold (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with bold := true }
/-- Makes text appear <u>underlined</u> -/
def underline (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with underline := true }
/-- Makes text appear *italic* -/
def italic (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with italic := true }
/-- Makes text appear dim -/
def dim (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with dim := true }
/-- Makes text appear blinking -/
def blink (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with blink := true }
/-- Reverses the colors of the text -/
def reverse (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with reverse := true }
/-- Hides the text -/
def hidden (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with hidden := true }
/-- Makes the text appear strikethrough -/
def strikethrough (doc : Doc Style) (s : Style := {}) : Doc Style := doc.ann { s with strikethrough := true }

/-- Apply an ANSI 16 foreground color code to a document.
The optional base style lets callers update the foreground while keeping other
style choices intact. -/
def fg_ansi_16 (code : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with fg := some (ColorLevel.ansi16 code) }

/-- Makes text appear black -/
def black := fg_ansi_16 ansi16Color.black
/-- Makes text appear red -/
def red := fg_ansi_16 ansi16Color.red
/-- Makes text appear green -/
def green := fg_ansi_16 ansi16Color.green
/-- Makes text appear yellow -/
def yellow := fg_ansi_16 ansi16Color.yellow
/-- Makes text appear blue -/
def blue := fg_ansi_16 ansi16Color.blue
/-- Makes text appear magenta -/
def magenta := fg_ansi_16 ansi16Color.magenta
/-- Makes text appear cyan -/
def cyan := fg_ansi_16 ansi16Color.cyan
/-- Makes text appear white -/
def white := fg_ansi_16 ansi16Color.white

/-- Makes text appear grey -/
def bright_black := fg_ansi_16 ansi16Color.bright_black
/-- Makes text appear grey -/
def grey := bright_black
/-- Makes text appear gray -/
def gray := bright_black

/-- Makes text appear bright red -/
def bright_red := fg_ansi_16 ansi16Color.bright_red
/-- Makes text appear bright green -/
def bright_green := fg_ansi_16 ansi16Color.bright_green
/-- Makes text appear bright yellow -/
def bright_yellow := fg_ansi_16 ansi16Color.bright_yellow
/-- Makes text appear bright blue -/
def bright_blue := fg_ansi_16 ansi16Color.bright_blue
/-- Makes text appear bright magenta -/
def bright_magenta := fg_ansi_16 ansi16Color.bright_magenta
/-- Makes text appear bright cyan -/
def bright_cyan := fg_ansi_16 ansi16Color.bright_cyan
/-- Makes text appear bright white -/
def bright_white := fg_ansi_16 ansi16Color.bright_white

/-- Apply an ANSI 16 background color code to a document. -/
def bg_ansi_16 (code : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with bg := some (ColorLevel.ansi16 code) }

/-- Makes background appear black -/
def bg_black := bg_ansi_16 ansi16Color.black
/-- Makes background appear red -/
def bg_red := bg_ansi_16 ansi16Color.red
/-- Makes background appear green -/
def bg_green := bg_ansi_16 ansi16Color.green
/-- Makes background appear yellow -/
def bg_yellow := bg_ansi_16 ansi16Color.yellow
/-- Makes background appear blue -/
def bg_blue := bg_ansi_16 ansi16Color.blue
/-- Makes background appear magenta -/
def bg_magenta := bg_ansi_16 ansi16Color.magenta
/-- Makes background appear cyan -/
def bg_cyan := bg_ansi_16 ansi16Color.cyan
/-- Makes background appear white -/
def bg_white := bg_ansi_16 ansi16Color.white

/-- Makes background appear grey -/
def bg_bright_black := bg_ansi_16 ansi16Color.bright_black
/-- Makes background appear grey -/
def bg_grey := bg_bright_black
/-- Makes background appear gray -/
def bg_gray := bg_bright_black

/-- Makes background appear bright red -/
def bg_bright_red := bg_ansi_16 ansi16Color.bright_red
/-- Makes background appear bright green -/
def bg_bright_green := bg_ansi_16 ansi16Color.bright_green
/-- Makes background appear bright yellow -/
def bg_bright_yellow := bg_ansi_16 ansi16Color.bright_yellow
/-- Makes background appear bright blue -/
def bg_bright_blue := bg_ansi_16 ansi16Color.bright_blue
/-- Makes background appear bright magenta -/
def bg_bright_magenta := bg_ansi_16 ansi16Color.bright_magenta
/-- Makes background appear bright cyan -/
def bg_bright_cyan := bg_ansi_16 ansi16Color.bright_cyan
/-- Makes background appear bright white -/
def bg_bright_white := bg_ansi_16 ansi16Color.bright_white

/-- Set foreground color using ANSI 256 palette indices. -/
def fg_ansi_256 (color : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with fg := some (ColorLevel.ansi256 color) }

/-- Set background color using ANSI 256 palette indices. -/
def bg_ansi_256 (color : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with bg := some (ColorLevel.ansi256 color) }

/-- Set foreground color using an RGB triple.
The value is stored as truecolor and may be downsampled only when rendering to a
terminal with weaker color support. -/
def fg_rgb (r g b : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with fg := some (ColorLevel.truecolor (r, g, b)) }

/-- Set background color using an RGB triple. -/
def bg_rgb (r g b : Nat) (doc : Doc Style) (s : Style := {}) : Doc Style :=
  doc.ann { s with bg := some (ColorLevel.truecolor (r, g, b)) }

end Doc
end leansi
