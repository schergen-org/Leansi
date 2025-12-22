import leansi.Style

namespace leansi

def esc : String := "\x1b["
def reset : String := esc ++ "0m"

def styleToSgr (s : Style) : List String :=
  let codes : List String := []

  let codes := match s.fg with
    | some n => codes ++ [toString n]
    | none => codes

  let codes := match s.bg with
    | some n => codes ++ [toString n]
    | none => codes


  let codes := if s.bold then codes ++ ["1"] else codes
  let codes := if s.italic then codes ++ ["3"] else codes
  let codes := if s.underline then codes ++ ["4"] else codes

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
