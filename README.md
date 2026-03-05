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
<p align="center">A Lean4 library designed to improve the display of content on the terminal.</p><br>


<img width="700" alt="Leansi-Examples" src="https://github.com/user-attachments/assets/8315ac1f-2411-4785-a4b3-dd34f3b3e7b7" align="right" />

`Leansi` is a small Lean 4 library for prettier terminal output: configurable colors (ANSI16/ANSI256/RGB), layouting and alignment utilities, borders/boxes, and other formatting helpers for building clean, **readable CLI displays**.

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## Installation

Add `Leansi` to your `lakefile.toml` dependencies (if this repo is a dependency in your setup), then build:

```bash
lake build
```

To run the included showcase example:

```bash
lake exe example
```

## Quick start

```lean
import leansi.Doc
import leansi.Style
import leansi.Render

open leansi
open leansi.Doc

def main : IO Unit := do
  let msg := (Doc.text "Leansi demo" |> bold |> bright_cyan)
  println msg
```

## How to use Leansi

### 1) Build text docs

`Doc` is the core type. Compose text with `Doc.text`, `Doc.empty`, and `++`.

```lean
let a := Doc.text "Hello"
let b := Doc.text " world"
let line := a ++ b
println line
```

### 2) Style text (ANSI styles + colors)

Apply style combinators directly on `Doc Style` values.

```lean
let styled :=
  (Doc.text "bold" |> bold) ++ Doc.text ", " ++
  (Doc.text "underline" |> underline) ++ Doc.text ", " ++
  (Doc.text "italic" |> italic)
println styled
```

Foreground/background color options:
- ANSI16: `bright_red`, `bg_blue`, ...
- ANSI256: `fg_ansi_256 n`, `bg_ansi_256 n`
- RGB: `fg_rgb r g b`, `bg_rgb r g b`

```lean
println (Doc.text "RGB" |> fg_rgb 100 150 200)
println (Doc.text "ANSI256" |> fg_ansi_256 54 |> bg_ansi_256 200)
```

### 3) Auto-detect terminal color support

`println`/`print` in `leansi.Render` automatically call `detectColorSupport` and render with fallback.

```lean
let support ← detectColorSupport
println (Doc.text s!"Detected color support: {support}" |> bright_cyan)
```

If a terminal only supports fewer colors, Leansi downscales automatically:
- truecolor -> ansi256/ansi16
- ansi256 -> ansi16
- any color -> none (if `NO_COLOR` or `TERM=dumb`)

### 4) Align text

Use `alignDoc` with `Alignment.left`, `right`, `center`, or `full` (justified).

```lean
let p := Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
println (alignDoc 40 Alignment.left p)
println (alignDoc 40 Alignment.center p)
println (alignDoc 40 Alignment.right p)
println (alignDoc 40 Alignment.full p)
```

### 5) Build layouts (rows, columns, stacks)

`Layout` provides simple composition primitives:
- `Layout.hcat` / `Layout.hcatSep` for horizontal composition
- `Layout.vcat` for vertical stacking
- `Layout.columns` for fixed-width table-like output with per-column alignment

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
- `hideOverflow = true`: crop cell content to width
- `hideOverflow = false`: wrap into multiple lines

### 6) Fit output to real terminal width

Use `getTerminalDimensions` directly or `Layout.fitToTerminal` for terminal-aware alignment.

```lean
let banner ← Layout.fitToTerminal Alignment.center (Doc.text "Simple Layout Demo" |> bold)
println banner
```

## Feature overview (with mini how-to)

1. Styled docs with composable combinators
   Use `Doc.text`, chain style functions via `|>`, combine with `++`.
2. ANSI16, ANSI256, and truecolor (RGB)
   Pick the needed API: `bright_green`, `fg_ansi_256 123`, or `fg_rgb 12 200 80`.
3. Automatic color fallback/downsampling
   Render via `println`/`print`; Leansi maps colors to terminal capabilities automatically.
4. Runtime terminal capability detection
   Call `detectColorSupport` and branch on `none | ansi16 | ansi256 | truecolor` if needed.
5. Text alignment helpers
   Use `alignDoc width alignment doc` for `left`, `center`, `right`, or `full` justification.
6. Layout primitives for CLI UIs
   Compose with `Layout.hcatSep`, `Layout.vcat`, and `Layout.columns` for table-like output.
7. Overflow handling in columns
   Control clipping vs wrapping using `Layout.columns ... hideOverflow`.
8. Terminal dimension detection
   Call `getTerminalDimensions` (or `Layout.fitToTerminal`) to adapt output width dynamically.

## Included example

The project includes `Example.lean`, which demonstrates:
- color capability showcase
- full style showcase
- multi-alignment text rendering
- terminal color support and dimension detection
- layout composition with `Layout.vcat`, `Layout.hcatSep`, and `Layout.columns`

Run it with:

```bash
lake exe example
```
