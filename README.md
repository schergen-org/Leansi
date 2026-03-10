[![Lean Action CI](https://github.com/schergen-org/Leansi/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/schergen-org/Leansi/actions/workflows/lean_action_ci.yml)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
<div align="center">
<pre>
    __                                   _
   / /   ___   ____ _   ____    _____   (_)
  / /   / _ \ / __ `/  / __ \  / ___/  / /
 / /___/  __// /_/ /  / / / / (__  )  / /
/_____/\___/ \__,_/  /_/ /_/ /____/  /_/
</pre>
</div>

<h1 align="center">Leansi</h1>
<p align="center">A Lean 4 library for readable terminal output.</p><br>

<p align="center">
    <img width="700" alt="Leansi-Examples" src="https://github.com/user-attachments/assets/1d140ecf-855a-4cac-b8e6-dc8cbcdb2a76" />
</p>

`Leansi` is a Lean 4 library for building terminal output from structured documents. It provides composable styling, color fallback (ANSI16/ANSI256/RGB), alignment, table-like layouts, terminal capability detection, and progress bars for CLI applications.

## Installation

This repository is pinned to:

```text
leanprover/lean4:v4.28.0
```

To build the library in this repository:

```bash
lake build
```

To use `Leansi` from another Lean project, add it as a Lake dependency in `lakefile.toml`:

```toml
[[require]]
name = "leansi"
git = "git@github.com:schergen-org/Leansi.git"
```

Then build your project as usual:

```bash
lake build
```

The repository also contains an optional showcase executable:

```bash
lake exe example
```

## Quick start

The public entrypoint is the root module:

```lean
import leansi

open leansi
open leansi.Doc

def main : IO Unit := do
  let msg : Doc Style := Doc.text "Leansi demo" |> bold |> bright_cyan
  println msg
```

## Core concepts

### 1) Build text docs

`Doc ann` is the core document type. It keeps text structure separate from annotations so layout and rendering can happen later.

Use `Doc.text`, `Doc.empty`, and `++` to build documents:

```lean
let a := Doc.text "Hello"
let b := Doc.text " world"
let line : Doc Style := a ++ b
println line
```

### 2) Style text

Style combinators live in the `leansi.Doc` namespace and operate on `Doc Style` values.

```lean
let styled :=
  (Doc.text "bold" |> bold) ++ Doc.text ", " ++
  (Doc.text "underline" |> underline) ++ Doc.text ", " ++
  (Doc.text "italic" |> italic)

println styled
```

Available style attributes include:
- `bold`
- `dim`
- `italic`
- `underline`
- `blink`
- `reverse`
- `hidden`
- `strikethrough`

Available color APIs include:
- ANSI16 foreground/background helpers such as `bright_red`, `cyan`, `bg_blue`
- ANSI256 via `fg_ansi_256 n` and `bg_ansi_256 n`
- RGB via `fg_rgb r g b` and `bg_rgb r g b`

```lean
println (Doc.text "RGB" |> fg_rgb 100 150 200)
println (Doc.text "ANSI256" |> fg_ansi_256 54 |> bg_ansi_256 200)
```

### 3) Render or print docs

For direct terminal output, use:
- `println : Doc Style -> IO Unit`
- `print : Doc Style -> IO Unit`

These functions automatically detect terminal color support before rendering.

If you want a plain `String` instead of immediate IO, use the lower-level render API:
- `Doc.render` ignores annotations
- `Doc.renderWithStyle` renders a styled document with an explicit `ColorSupport`
- `render` is a convenience wrapper for `Doc Unit`

### 4) Auto-detect terminal color support

`detectColorSupport` inspects common environment variables and caches the result.

Current detection behavior:
- `NO_COLOR` disables colors entirely
- `TERM=dumb` disables colors entirely
- `COLORTERM=truecolor` or `COLORTERM=24bit` enables truecolor
- `TERM` containing `256color` enables ANSI256
- any other non-empty `TERM` falls back to ANSI16

```lean
let support ← detectColorSupport
println (Doc.text s!"Detected color support: {support}" |> bright_cyan)
```

If the terminal supports fewer colors than requested, Leansi downscales automatically:
- truecolor -> ansi256 or ansi16
- ansi256 -> ansi16
- any color -> none when colors are disabled

### 5) Align text

Use `alignDoc` with `Alignment.left`, `Alignment.right`, `Alignment.center`, or `Alignment.full`.

```lean
let p := Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
println (alignDoc 40 Alignment.left p)
println (alignDoc 40 Alignment.center p)
println (alignDoc 40 Alignment.right p)
println (alignDoc 40 Alignment.full p)
```

`Alignment.full` performs simple space redistribution for terminal-friendly justification.

### 6) Build layouts

`Layout` provides composition helpers for CLI UIs:
- `Layout.hcat` for horizontal concatenation
- `Layout.hcatSep` for horizontal concatenation with gaps
- `Layout.vcat` for vertical stacking
- `Layout.columns` for fixed-width, table-like output

```lean
let row :=
  Layout.columns [12, 18, 10] 2
    [ Doc.text "Package" |> bold
    , Doc.text "Component" |> bold
    , Doc.text "State" |> bold
    ]
    [Alignment.left, Alignment.center, Alignment.right]

println row
```

`Layout.columns` also handles overflow:
- `hideOverflow = true` clips cell content to column width
- `hideOverflow = false` wraps cell content into multiple lines
- `useMinRows = true` truncates the final output to the shortest column
- `useMinRows = false` keeps all rows up to the tallest column

### 7) Fit output to terminal width

Use `getTerminalDimensions` directly or `Layout.fitToTerminal` when you want terminal-aware alignment.

```lean
let banner ← Layout.fitToTerminal Alignment.center (Doc.text "Simple Layout Demo" |> bold)
println banner
```

`getTerminalDimensions` is best-effort:
- it first checks `LINES` and `COLUMNS`
- on Linux/macOS it falls back to `stty size < /dev/tty`
- on Windows it queries PowerShell
- it can return `none` when no real TTY is attached, for example in CI or some IDE runs

### 8) Progress bars

Leansi includes a ready-to-use progress bar widget:
- `progressBar`
- `simpleProgressBar`
- `ProgressBarConfig`
- `ProgressThreshold`

```lean
let customConfig : ProgressBarConfig := {
  width := 22
  filled := '▓'
  empty := '·'
  brackets := none
  thresholds := [
    { upperBound := 50, color := ColorLevel.truecolor (255, 100, 100) },
    { upperBound := 100, color := ColorLevel.truecolor (100, 255, 100) }
  ]
}

println (Doc.text "Upload: " ++ progressBar customConfig 65)
```

## Feature overview

1. Structured `Doc` trees instead of raw string concatenation.
2. Composable style helpers in `leansi.Doc`.
3. ANSI16, ANSI256, and truecolor color requests.
4. Automatic color fallback based on terminal support.
5. Runtime terminal capability detection with caching.
6. Alignment helpers for left, right, center, and full justification.
7. Table-like column layout with wrapping or clipping.
8. Best-effort terminal dimension detection.
9. Progress bar widgets with configurable thresholds and visuals.
10. Low-level rendering APIs for non-IO use cases.

## Included example

`Example.lean` demonstrates:
- color support and downsampling
- the available style combinators
- left/center/right/full alignment
- terminal color and dimension detection
- layout composition with `Layout.vcat` and `Layout.columns`
- default and customized progress bars

Run it with:

```bash
lake exe example
```
