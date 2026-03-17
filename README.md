[![Wiki](https://img.shields.io/badge/wiki-GitHub-blue.svg)](https://github.com/schergen-org/Leansi/wiki)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![GitHub Release](https://img.shields.io/github/v/release/schergen-org/Leansi)](https://github.com/schergen-org/lfetch/releases/tag/v0.1.0)
[![Lean Action CI](https://github.com/schergen-org/Leansi/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/schergen-org/Leansi/actions/workflows/lean_action_ci.yml)

> [!NOTE]  
> This library was created as part of the “Funktionale Programmierung in Lean” module as an examination requirement at the University of Applied Sciences Mittelhessen.

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
    <img width="700"  alt="Leansi-Examples" src="https://github.com/user-attachments/assets/bf8e4a39-8493-4e38-aa09-5f36849ff422" />
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

## Wiki
Extended documentation, design notes, and additional examples are maintained in the GitHub Wiki.

- [Leansi Wiki (GitHub)](https://github.com/schergen-org/Leansi/wiki)

## LLM Textfile
For LLM-based tools, this repository provides a machine-oriented reference file:

- [llms.txt](llms.txt)

It summarizes the public API, recommended usage patterns, and behavior rules (for example, color support detection and style composition) so assistants can generate correct Lean snippets.

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
10. Boxed docs with optional titles and configurable border styles.
11. Tree widgets for hierarchical output (`├─`, `└─`) with manual ASCII "fallback".
12. Low-level rendering APIs for non-IO use cases.
