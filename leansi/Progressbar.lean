import leansi.Doc
import leansi.Style

namespace leansi

/-- A threshold that determines which color to use for a given progress value.
    The `upperBound` is the maximum percentage (0-100) for which this color applies.
    Thresholds should be given in ascending order of `upperBound`. -/
structure ProgressThreshold where
  upperBound : Fin 101
  color : ColorLevel
deriving Repr, Inhabited, BEq

/-- Configuration for rendering a progress bar. -/
structure ProgressBarConfig where
  width : Nat := 20
  filled : Char := '█'
  empty : Char := '░'
  /-- Thresholds for color changes, sorted ascending by `upperBound`.
      The first threshold whose `upperBound ≥ value` determines the color. -/
  thresholds : List ProgressThreshold :=
    [ { upperBound := 33, color := ColorLevel.ansi16 ansi16Color.red }
    , { upperBound := 66, color := ColorLevel.ansi16 ansi16Color.yellow }
    , { upperBound := 100,  color := ColorLevel.ansi16 ansi16Color.green }
    ]
  /-- Fallback color if no threshold matches -/
  defaultColor : ColorLevel := ColorLevel.ansi16 ansi16Color.green
  /-- Whether to show a percentage label (e.g. " 40%") after the bar -/
  showPercentage : Bool := true
  /-- Optional bracket characters around the bar -/
  brackets : Option (Char × Char) := some ('[', ']')
deriving Repr, Inhabited, BEq

namespace Progressbar

/-- Find the color for a given value by scanning thresholds in order. -/
private def resolveColor (thresholds : List ProgressThreshold) (defaultColor : ColorLevel) (value : Fin 101) : ColorLevel :=
  match thresholds.find? (fun t => value.1 <= t.upperBound.1) with
  | some t => t.color
  | none   => defaultColor

/-- Repeat a character `n` times to produce a string. -/
private def repeatChar (c : Char) (n : Nat) : String :=
  String.ofList (List.replicate n c)

/-- Format a percentage value as a right-aligned string, e.g. " 40%" or "100%". -/
private def formatPercentage (value : Fin 101) : String :=
  let s := toString value.1 ++ "%"
  -- Right-align to 4 characters (up to "100%")
  let pad := if s.length < 4 then repeatChar ' ' (4 - s.length) else ""
  pad ++ s

end Progressbar

open Progressbar in
/-- Render a progress bar as a `Doc Style`. -/
def progressBar (config : ProgressBarConfig := {}) (value : Fin 101) : Doc Style :=
  let filledCount := ((value.1 * config.width) / 100).min config.width
  let emptyCount  := config.width - filledCount

  let color := resolveColor config.thresholds config.defaultColor value
  let barStyle : Style := { fg := some color }
  let filledDoc := Doc.text (repeatChar config.filled filledCount) |>.ann barStyle
  let emptyDoc  := Doc.text (repeatChar config.empty emptyCount)
  let barDoc    := filledDoc ++ emptyDoc

  -- Optionally wrap in brackets
  let barDoc := match config.brackets with
    | some (l, r) => Doc.text (toString l) ++ barDoc ++ Doc.text (toString r)
    | none        => barDoc

  -- Optionally append percentage label (styled with same color)
  let barDoc := if config.showPercentage then
      barDoc ++ (Doc.text (" " ++ formatPercentage value) |>.ann barStyle)
    else
      barDoc
  barDoc

def simpleProgressBar (width : Nat := 20) (value : Fin 101) : Doc Style :=
  progressBar { width := width } value

end leansi
