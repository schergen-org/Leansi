import leansi.Style

namespace leansi

def esc : String := "\x1b["
def reset : String := esc ++ "0m"

def getColorCodes (s : Style) : List String :=
  let codes : List String := []

  match s.colorLevel with
  | colorLevel.none => codes
  | colorLevel.ansi16 =>
    let codes := match s.fg with
      | some n => codes ++ [toString n]
      | none => codes
    let codes := match s.bg with
      | some n => codes ++ [toString n]
      | none => codes
    codes
  | colorLevel.ansi256 =>
    let codes := match s.fg with
      | some n => codes ++ ["38;5;" ++ toString n]
      | none => codes
    let codes := match s.bg with
      | some n => codes ++ ["48;5;" ++ toString n]
      | none => codes
    codes

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

/-- Build ANSI escape sequence -/
def sgrSequence (codes : List String) : String :=
  if codes.isEmpty then
    ""
  else
    esc ++ String.intercalate ";" codes ++ "m"

/-- Convert Style to ANSI escape sequence -/
def styleToAnsi (s : Style) : String :=
  sgrSequence (styleToSgr s)

end leansi
