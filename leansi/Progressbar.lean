import leansi.Doc
import leansi.Style

namespace leansi

/-- A threshold that determines which color to use for a given progress value.
    The `upperBound` is the maximum value (0.0–1.0) for which this color applies.
    Thresholds should be given in ascending order of `upperBound`. -/
structure ProgressThreshold where
  /-- Upper bound (inclusive) for this threshold, e.g. 0.33 -/
  upperBound : Float
  /-- Color to use when the progress value falls within this threshold -/
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
    [ { upperBound := 0.33, color := ColorLevel.ansi16 ansi16Color.red }
    , { upperBound := 0.66, color := ColorLevel.ansi16 ansi16Color.yellow }
    , { upperBound := 1.0,  color := ColorLevel.ansi16 ansi16Color.green }
    ]
  /-- Fallback color if no threshold matches -/
  defaultColor : ColorLevel := ColorLevel.ansi16 ansi16Color.green
  /-- Whether to show a percentage label (e.g. " 40%") after the bar -/
  showPercentage : Bool := true
  /-- Optional bracket characters around the bar, e.g. `some ('[', ']')` -/
  brackets : Option (Char × Char) := some ('[', ']')
deriving Repr, Inhabited, BEq

namespace Progressbar

/-- Clamp a float to the range [0.0, 1.0]. -/
private def clamp01 (v : Float) : Float :=
  if v < 0.0 then 0.0
  else if v > 1.0 then 1.0
  else v

/-- Find the color for a given value by scanning thresholds in order. -/
private def resolveColor (thresholds : List ProgressThreshold) (defaultColor : ColorLevel) (value : Float) : ColorLevel :=
  match thresholds.find? (fun t => value <= t.upperBound) with
  | some t => t.color
  | none   => defaultColor

/-- Repeat a character `n` times to produce a string. -/
private def repeatChar (c : Char) (n : Nat) : String :=
  String.ofList (List.replicate n c)

/-- Format a percentage value as a right-aligned string, e.g. " 40%" or "100%". -/
private def formatPercentage (value : Float) : String :=
  let pct := (value * 100.0).toUInt32.toNat
  let s := toString pct ++ "%"
  -- Right-align to 4 characters (up to "100%")
  let pad := if s.length < 4 then repeatChar ' ' (4 - s.length) else ""
  pad ++ s

end Progressbar

open Progressbar in
/-- Render a progress bar as a `Doc Style`.
    `value` should be between 0.0 and 1.0 (it will be clamped). -/
def progressBar (config : ProgressBarConfig := {}) (value : Float) : Doc Style :=
  let v := clamp01 value
  let filledCount := (v * Float.ofNat config.width).toUInt32.toNat |>.min config.width
  let emptyCount  := config.width - filledCount

  let color := resolveColor config.thresholds config.defaultColor v
  let barStyle : Style := { fg := some color }

  -- Build the bar segments
  let filledDoc := Doc.text (repeatChar config.filled filledCount) |>.ann barStyle
  let emptyDoc  := Doc.text (repeatChar config.empty emptyCount)
  let barDoc    := filledDoc ++ emptyDoc

  -- Optionally wrap in brackets
  let barDoc := match config.brackets with
    | some (l, r) => Doc.text (toString l) ++ barDoc ++ Doc.text (toString r)
    | none        => barDoc

  -- Optionally append percentage label (styled with same color)
  let barDoc := if config.showPercentage then
      barDoc ++ (Doc.text (" " ++ formatPercentage v) |>.ann barStyle)
    else
      barDoc

  barDoc

/-- A simple progress bar with default configuration — just specify width and value. -/
def simpleProgressBar (width : Nat := 20) (value : Float) : Doc Style :=
  progressBar { width := width } value

end leansi
