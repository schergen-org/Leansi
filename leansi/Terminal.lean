import Lean
import Std

namespace leansi



-- Terminal color level detection
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

def containsSub (s sub : String) : Bool :=
  (s.splitOn sub).length > 1

def detectColorSupport' : IO ColorSupport := do
  if (← IO.getEnv "NO_COLOR").isSome then
    return .none

  let term      := ((← IO.getEnv "TERM").getD "").toLower
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

def detectColorSupport : IO ColorSupport := do
  let cached ← colorSupportRef.get
  match cached with
  | some level => return level
  | none =>
    let level ← detectColorSupport'
    colorSupportRef.set (some level)
    return level




-- Terminal dimensions detection
private def parseRowsCols (s : String) : Option (Nat × Nat) :=
  let ws :=
    s.trim
      |>.splitToList (fun c => c.isWhitespace)
      |>.filter (· ≠ "")
  match ws with
  | r :: c :: _ =>
      match (r.toNat?, c.toNat?) with
      | (some rr, some cc) => some (rr, cc)
      | _ => none
  | _ => none

private def runAndParse (cmd : String) (args : Array String) : IO (Option (Nat × Nat)) := do
  try
    let out ← IO.Process.output { cmd := cmd, args := args }
    if out.exitCode == 0 then
      return parseRowsCols out.stdout
    else
      return none
  catch _ =>
    return none

/-- Cross-platform (pragmatic) terminal size detection.

Order:
1) `LINES` + `COLUMNS` env vars (if present)
2) Linux/macOS: `stty size < /dev/tty`
3) Windows: PowerShell `$Host.UI.RawUI.WindowSize`

Returns `none` if not attached to a real TTY (e.g. redirected / CI / some IDE runs). -/
def getTerminalDimensions : IO (Option (Nat × Nat)) := do
  -- 1) env vars (often set by shells/terminals)
  match (← IO.getEnv "LINES", ← IO.getEnv "COLUMNS") with
  | (some l, some c) =>
      match (l.toNat?, c.toNat?) with
      | (some ll, some cc) => return some (ll, cc)
      | _ => pure ()
  | _ => pure ()

  -- 2/3) fallback via OS-specific commands
  if System.Platform.isWindows then
    -- Try Windows PowerShell first, then PowerShell 7 (pwsh) as fallback.
    let psArgs :=
      #["-NoProfile", "-NonInteractive", "-Command",
        "$s=$Host.UI.RawUI.WindowSize; Write-Output \"$($s.Height) $($s.Width)\""]
    let r1 ← runAndParse "powershell" psArgs
    match r1 with
    | some dims => return some dims
    | none =>
      let r2 ← runAndParse "pwsh" psArgs
      return r2
  else
    -- Important: `/dev/tty` so stty talks to the actual terminal, not piped stdin.
    runAndParse "sh" #["-c", "stty size < /dev/tty"]

end leansi
