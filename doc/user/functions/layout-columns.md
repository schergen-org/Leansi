# Layout.columns

## Purpose

`Layout.columns` creates fixed-width, table-like terminal layouts. It is one of the central layout tools in Leansi and is heavily used in the example program.

## API Shape

```lean
Layout.columns :
  List Nat →
  Nat →
  List (Doc ann) →
  List Alignment →
  Bool →
  Bool →
  Doc ann
```

Parameters in order:

1. column widths
2. gap between columns
3. column documents
4. per-column alignments, defaulting to `Alignment.left`
5. `hideOverflow`, defaulting to `false`
6. `useMinRows`, defaulting to `false`

## Behavior

Each input document belongs to one column. Leansi first fits each document to its column width and then rebuilds the final output row by row.

Important behaviors:

- If a document is shorter than its width, it is padded according to the selected alignment.
- If a document is longer than its width:
  - with `hideOverflow = true`, content is clipped
  - with `hideOverflow = false`, content wraps into multiple visual rows
- If columns produce different row counts:
  - with `useMinRows = false`, Leansi keeps rows up to the tallest column
  - with `useMinRows = true`, Leansi truncates to the shortest column

If there are more documents than widths, the last width is reused as the default width. If there are more documents than alignments, the default is `Alignment.left`.

## Parameters

- `colWidth`: width of each column
- `gap`: spaces between columns
- `docs`: documents for the columns
- `alignments`: optional alignment per column
- `hideOverflow`: clip instead of wrap
- `useMinRows`: keep only the shared row count instead of the maximum row count

## Example Usage

Simple table row:

```lean
def row : Doc Style :=
  Layout.columns [12, 18, 10] 2
    [ Doc.text "Package" |> bold
    , Doc.text "Component" |> bold
    , Doc.text "State" |> bold
    ]
    [Alignment.left, Alignment.center, Alignment.right]
```

Wrapped cells:

```lean
def wrapped : Doc Style :=
  Layout.columns [20, 20] 3
    [ Doc.text "A very long text that will wrap into multiple lines."
    , Doc.text "Another long entry that also wraps."
    ]
    [Alignment.left, Alignment.left]
    false
    false
```

Clipped cells:

```lean
def clipped : Doc Style :=
  Layout.columns [10, 10] 2
    [ Doc.text "123456789012345"
    , Doc.text "abcdefghijklmno"
    ]
    [Alignment.left, Alignment.left]
    true
```

## Notes

- `Layout.columns` is the right choice for dashboards, status lines, and table-like CLI output.
- It uses the same alignment rules documented on [Alignment](alignment.md).
- `Layout.vcat` and `Layout.columns` work well together: use `columns` for rows and `vcat` to stack multiple rows.

## Related Pages

- [Layout primitives](layout-primitives.md)
- [Alignment](alignment.md)
- [Box](box.md)

