import leansi.Doc.Type

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
    , { upperBound := 100, color := ColorLevel.ansi16 ansi16Color.green }
    ]
  /-- Fallback color if no threshold matches -/
  defaultColor : ColorLevel := ColorLevel.ansi16 ansi16Color.green
  /-- Whether to show a percentage label (e.g. " 40%") after the bar -/
  showPercentage : Bool := true
  /-- Optional bracket characters around the bar -/
  brackets : Option (Char × Char) := some ('[', ']')
deriving Repr, Inhabited, BEq

namespace Progressbar

/-- Choose the first threshold whose upper bound still contains the current value.
This lets threshold lists describe ordered ranges such as red/yellow/green states. -/
private def resolveColor (thresholds : List ProgressThreshold) (defaultColor : ColorLevel) (value : Fin 101) : ColorLevel :=
  match thresholds.find? (fun t => value.1 <= t.upperBound.1) with
  | some t => t.color
  | none => defaultColor

/-- Build a string by repeating one character `n` times. -/
private def repeatChar (c : Char) (n : Nat) : String :=
  String.ofList (List.replicate n c)

/-- Format the percentage label to a fixed width so multiple bars align vertically. -/
private def formatPercentage (value : Fin 101) : String :=
  let s := toString value.1 ++ "%"
  let pad := if s.length < 4 then repeatChar ' ' (4 - s.length) else ""
  pad ++ s

end Progressbar

open Progressbar in
/-- Render a progress bar as a styled document.
The bar body and the percentage label use the same resolved color so the visual
state and the numeric value tell a consistent story. -/
def progressBar (config : ProgressBarConfig := {}) (value : Fin 101) : Doc Style :=
  let filledCount := ((value.1 * config.width) / 100).min config.width
  let emptyCount := config.width - filledCount

  let color := resolveColor config.thresholds config.defaultColor value
  let barStyle : Style := { fg := some color }
  let filledDoc := Doc.text (repeatChar config.filled filledCount) |>.ann barStyle
  let emptyDoc := Doc.text (repeatChar config.empty emptyCount)
  let barDoc := filledDoc ++ emptyDoc

  let barDoc := match config.brackets with
    | some (l, r) => Doc.text (toString l) ++ barDoc ++ Doc.text (toString r)
    | none => barDoc

  let barDoc := if config.showPercentage then
      barDoc ++ (Doc.text (" " ++ formatPercentage value) |>.ann barStyle)
    else
      barDoc
  barDoc

/-- Convenience wrapper around `progressBar` with the default configuration except for width. -/
def simpleProgressBar (width : Nat := 20) (value : Fin 101) : Doc Style :=
  progressBar { width := width } value

end leansi
