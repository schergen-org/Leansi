# Layout Primitives

## Purpose

The `Layout` namespace contains the basic combinators for arranging documents horizontally and vertically before rendering.

## API Shape

```lean
Layout.lineBreak : Doc ann
Layout.spaces : Nat → Doc ann
Layout.hcat : List (Doc ann) → Doc ann
Layout.hcatSep : Nat → List (Doc ann) → Doc ann
Layout.vcat : List (Doc ann) → Doc ann
```

## Behavior

- `Layout.lineBreak` is a single newline document.
- `Layout.spaces n` produces a document containing `n` spaces.
- `Layout.hcat docs` concatenates documents without a separator.
- `Layout.hcatSep gap docs` inserts `gap` spaces between adjacent documents.
- `Layout.vcat docs` inserts a line break between adjacent documents.

These are the core building blocks behind larger layouts and widgets.

## Parameters

- `gap` in `Layout.hcatSep` is the number of spaces between entries.
- `docs` is the list of documents to combine.
- `n` in `Layout.spaces` is the number of spaces to generate.

## Example Usage

```lean
import leansi

open leansi
open leansi.Doc

def row : Doc Style :=
  Layout.hcatSep 2
    [ Doc.text "name" |> bold
    , Doc.text "status" |> bold
    , Doc.text "ok" |> bright_green
    ]

def block : Doc Style :=
  Layout.vcat
    [ Doc.text "line 1"
    , Doc.text "line 2"
    , Layout.hcat [Doc.text "line ", Doc.text "3"]
    ]
```

## Notes

- `Layout.vcat` is the simplest way to build multi-line terminal output.
- `Layout.hcatSep` is often enough for small inline layouts.
- For fixed-width table-like output, use [Layout.columns](layout-columns.md).

## Related Pages

- [Alignment](alignment.md)
- [Layout.columns](layout-columns.md)
- [Box](box.md)
- [Tree](tree.md)

