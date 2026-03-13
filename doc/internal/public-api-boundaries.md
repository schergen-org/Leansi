# Public API Boundaries

## Purpose

This page separates Leansi’s public, user-facing API from declarations that are public in Lean but mainly exist to support implementation.

## Intended User-Facing API

These declarations are the main interfaces a CLI application should use directly:

- `Doc`, especially `Doc.empty`, `Doc.text`, `Doc.ann`, and `++`
- document styling helpers in namespace `leansi.Doc`
- `Style`, `ColorLevel`, `Ansi16Color`, `ansi16Color`, and `Style.combine`
- `Doc.render`, `Doc.renderWithStyle`, `render`, `print`, `println`
- `ColorSupport` and `detectColorSupport`
- `getTerminalDimensions`
- `Alignment` and `alignDoc`
- `Layout.lineBreak`, `Layout.spaces`, `Layout.hcat`, `Layout.hcatSep`, `Layout.vcat`
- `Layout.columns`
- `Layout.fitToTerminal`
- `ProgressThreshold`, `ProgressBarConfig`, `progressBar`, `simpleProgressBar`
- `BoxChars`, `asciiBoxChars`, `roundedBoxChars`, `BoxConfig`, `box`
- `TreeChars`, `asciiTreeChars`, `Tree`, `Tree.leaf`, `Tree.branch`, `TreeConfig`, `tree`, `forest`

## Public But Mainly Internal Helpers

The repository also exports declarations that are public for practical Lean reasons but are not the primary surface for normal application code:

Document operations:

- `concatDocs`
- `docVisualLength`
- `coalesceText`
- `plainText`
- `takeDoc`
- `dropDoc`
- `appendLineLists`
- `splitDocLines`

Layout internals:

- `justifyFull`
- `Layout.handleDocOverflow`
- `Layout.columns'`

Color and ANSI helpers:

- `esc`
- `reset`
- `getColorCodes`
- `styleToSgr`
- `sgrSequence`
- `styleToAnsi`
- `convertColorLevel`
- `renderStyled`
- `containsSub`
- `detectColorSupport'`
- `trueColorToAnsi256`
- `ansi16Palette`
- `sqDist`
- `trueColorToAnsi16`
- `ansi256ToAnsi16`

Utility helpers:

- `visualLength`
- `repeatChar`
- `whiteSpaceString`

## Why They Remain Public

Leansi is a small Lean library organized by modules rather than by a heavily restricted facade. That means some helpers remain visible after import even when their main purpose is implementation support.

This is common in Lean projects because:

- it keeps modules simple
- it avoids extra wrapper layers
- it makes testing and experimentation easier

The wiki therefore documents these helpers, but it places them in the internal section to keep the user-facing section focused.

## Notes

- Private declarations such as the inner recursive functions inside the widget modules are not treated as part of the public API.
- A declaration being public in Lean does not automatically mean it should have its own end-user page.

