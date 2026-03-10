import leansi.Style.Types

namespace leansi

/-- Prefix used by ANSI Control Sequence Introducer escape sequences. -/
def esc : String := "\x1b["
/-- ANSI reset sequence that clears all active attributes. -/
def reset : String := esc ++ "0m"

/-- Convert the color part of a style into SGR parameters.
Text attributes are handled separately so callers can build the final sequence in
a clear and predictable order. -/
def getColorCodes (s : Style) : List String :=
  let codes : List String := []

  let codes := match s.fg with
    | ColorLevel.ansi16 n => codes ++ [toString n]
    | ColorLevel.ansi256 n => codes ++ ["38;5;" ++ toString n]
    | ColorLevel.truecolor (r, g, b) => codes ++ ["38;2;" ++ toString r ++ ";" ++ toString g ++ ";" ++ toString b]
    | ColorLevel.none | none => codes
  let codes := match s.bg with
    | ColorLevel.ansi16 n => codes ++ [toString (n + 10)]
    | ColorLevel.ansi256 n => codes ++ ["48;5;" ++ toString n]
    | ColorLevel.truecolor (r, g, b) => codes ++ ["48;2;" ++ toString r ++ ";" ++ toString g ++ ";" ++ toString b]
    | ColorLevel.none | none => codes
  codes

/-- Convert a full style into the list of SGR parameters understood by ANSI terminals. -/
def styleToSgr (s : Style) : List String :=
  let codes := getColorCodes s

  let codes := if s.bold then codes ++ ["1"] else codes
  let codes := if s.dim then codes ++ ["2"] else codes
  let codes := if s.italic then codes ++ ["3"] else codes
  let codes := if s.underline then codes ++ ["4"] else codes
  let codes := if s.blink then codes ++ ["5"] else codes
  let codes := if s.reverse then codes ++ ["7"] else codes
  let codes := if s.hidden then codes ++ ["8"] else codes
  let codes := if s.strikethrough then codes ++ ["9"] else codes

  codes

/-- Build an ANSI escape sequence from raw SGR parameters.
Returning the empty string for an empty parameter list lets callers skip styling
without adding a separate conditional. -/
def sgrSequence (codes : List String) : String :=
  if codes.isEmpty then
    ""
  else
    esc ++ String.intercalate ";" codes ++ "m"

/-- Encode a `Style` as the concrete ANSI prefix emitted before styled text. -/
def styleToAnsi (s : Style) : String :=
  sgrSequence (styleToSgr s)

end leansi
