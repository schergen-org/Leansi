# Layout.fitToTerminal

## Purpose

`Layout.fitToTerminal` aligns a document to the current terminal width when that width can be detected.

## API Shape

```lean
Layout.fitToTerminal : Alignment → Doc ann → IO (Doc ann)
```

## Behavior

The function calls `getTerminalDimensions` internally:

- if terminal dimensions are available, it aligns the document to the detected column count
- if dimension detection fails, it returns the original document unchanged

This makes it safe to use in scripts that may run in real terminals, CI, or redirected output.

## Parameters

- `alignment`: the alignment strategy to apply
- `doc`: the document to align

## Example Usage

```lean
import leansi

open leansi
open leansi.Doc

def main : IO Unit := do
  let banner ← Layout.fitToTerminal Alignment.center (Doc.text "Leansi" |> bold |> bright_red)
  println banner
```

## Notes

- `Layout.fitToTerminal` only performs alignment. It does not wrap, clip, or build columns by itself.
- When you already know the width you want, use `alignDoc` directly instead.

## Related Pages

- [Terminal dimensions](terminal-dimensions.md)
- [Alignment](alignment.md)

