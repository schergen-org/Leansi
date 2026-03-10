import Lean
import Std

namespace leansi

private def parseRowsCols (s : String) : Option (Nat × Nat) :=
  let ws :=
    s.trimAscii.toString
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
  match (← IO.getEnv "LINES", ← IO.getEnv "COLUMNS") with
  | (some l, some c) =>
      match (l.toNat?, c.toNat?) with
      | (some ll, some cc) => return some (ll, cc)
      | _ => pure ()
  | _ => pure ()

  if System.Platform.isWindows then
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
    runAndParse "sh" #["-c", "stty size < /dev/tty"]

end leansi
