import Std

namespace leansi

inductive ColorSupport
| none
| ansi16
| ansi256
| truecolor
deriving Repr, BEq

instance : ToString ColorSupport where
  toString
  | .none      => "none"
  | .ansi16    => "ansi16"
  | .ansi256   => "ansi256"
  | .truecolor => "truecolor"

initialize colorSupportRef : IO.Ref (Option ColorSupport) ← IO.mkRef none

/-- Test whether `sub` occurs inside `s`.
This keeps the capability detection code readable without introducing a heavier helper. -/
def containsSub (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

/-- Infer terminal color capability from common environment variables.
The heuristic gives precedence to explicit disablement and explicit truecolor hints
before falling back to broader `TERM` categories. -/
def detectColorSupport' : IO ColorSupport := do
  if (← IO.getEnv "NO_COLOR").isSome then
    return .none

  let term := ((← IO.getEnv "TERM").getD "").toLower
  let colorterm := ((← IO.getEnv "COLORTERM").getD "").toLower

  if term == "dumb" then
    return .none

  if colorterm == "truecolor" || colorterm == "24bit" then
    return .truecolor

  if containsSub term "256color" then
    return .ansi256

  if term != "" then
    return .ansi16

  return .none

/-- Detect terminal color support once and cache the result for later renders.
Rendering happens often, so repeated environment probing would be unnecessary work. -/
def detectColorSupport : IO ColorSupport := do
  let cached ← colorSupportRef.get
  match cached with
  | some level => return level
  | none =>
    let level ← detectColorSupport'
    colorSupportRef.set (some level)
    return level

end leansi
