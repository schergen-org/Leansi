# Progress Bars

## Purpose

Leansi includes a ready-made progress bar widget for terminal status displays.

## API Shape

```lean
structure ProgressThreshold where
  upperBound : Fin 101
  color : ColorLevel

structure ProgressBarConfig where
  width : Nat := 20
  filled : Char := '█'
  empty : Char := '░'
  thresholds : List ProgressThreshold := ...
  defaultColor : ColorLevel := ...
  showPercentage : Bool := true
  brackets : Option (Char × Char) := some ('[', ']')

progressBar : ProgressBarConfig → Fin 101 → Doc Style
simpleProgressBar : Nat → Fin 101 → Doc Style
```

## Behavior

`progressBar` renders a bar whose filled section depends on the given percentage value.

Behavior details:

- the filled width is computed from `value` and `config.width`
- the bar color is chosen from the first threshold whose `upperBound` is at least the current value
- if no threshold matches, `defaultColor` is used
- the percentage label uses the same resolved color as the filled section
- brackets are optional

The input value is `Fin 101`, so valid values are `0` through `100`.

## Parameters and Configuration

`ProgressThreshold`:

- `upperBound`: maximum percentage covered by this threshold
- `color`: color for values up to that bound

`ProgressBarConfig`:

- `width`: number of fill characters inside the bar
- `filled`: character for completed progress
- `empty`: character for the remaining part
- `thresholds`: ordered color rules
- `defaultColor`: fallback color
- `showPercentage`: whether to append a textual percentage
- `brackets`: optional surrounding bracket characters

## Example Usage

Default configuration:

```lean
def cpu : Doc Style :=
  Doc.text "CPU: " ++ progressBar {} 73
```

Custom configuration:

```lean
def customConfig : ProgressBarConfig := {
  width := 22
  filled := '▓'
  empty := '·'
  brackets := none
  thresholds := [
    { upperBound := 50, color := ColorLevel.truecolor (255, 100, 100) },
    { upperBound := 100, color := ColorLevel.truecolor (100, 255, 100) }
  ]
}

def upload : Doc Style :=
  Doc.text "Upload: " ++ progressBar customConfig 65
```

Simple wrapper:

```lean
def small : Doc Style :=
  simpleProgressBar 10 40
```

## Notes

- The thresholds should be ordered from low to high `upperBound`.
- Because colors are expressed as `ColorLevel`, the normal color fallback rules still apply.
- `simpleProgressBar` is a convenience wrapper when only the width should change.

## Related Pages

- [Style](style.md)
- [Rendering](rendering.md)

