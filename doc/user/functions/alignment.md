# Alignment

## Purpose

Leansi can align documents to a fixed width. This is useful for banners, labels, columns, and wrapped output in terminal interfaces.

## API Shape

```lean
inductive Alignment where
| left
| right
| center
| full

alignDoc : Nat → Alignment → Doc ann → Doc ann
```

## Behavior

`alignDoc width alignment doc` adjusts the document to the requested width:

- `Alignment.left`: pad on the right
- `Alignment.right`: pad on the left
- `Alignment.center`: split padding across both sides
- `Alignment.full`: justify internal spaces so the line fills the full width

For left, right, and center alignment, Leansi preserves the document structure and only adds padding around it. Full alignment is different: it works from plain text because it needs to redistribute spaces inside the content.

## Parameters

- `width`: target visual width
- `alignment`: one of `left`, `right`, `center`, or `full`
- `doc`: the document to align

## Example Usage

```lean
import leansi

open leansi
open leansi.Doc

def paragraph : Doc Style :=
  Doc.text "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

def demo : Doc Style :=
  Layout.vcat
    [ alignDoc 40 Alignment.left paragraph
    , alignDoc 40 Alignment.center paragraph
    , alignDoc 40 Alignment.right paragraph
    , alignDoc 40 Alignment.full paragraph
    ]
```

## Notes

- Full alignment is intentionally simple and terminal-oriented, not a full typesetting algorithm.
- Alignment works with styled documents because Leansi measures visible width while ignoring annotations.
- `Layout.columns` uses `Alignment` for per-column alignment.

## Related Pages

- [Layout primitives](layout-primitives.md)
- [Layout.columns](layout-columns.md)
- [Layout.fitToTerminal](layout-fit-to-terminal.md)

