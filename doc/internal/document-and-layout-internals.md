# Document And Layout Internals

## Purpose

This page explains the lower-level document and layout helpers that power alignment, wrapping, boxes, trees, and columns.

## Document Operations

### API Shape

```lean
concatDocs : Doc ann → Doc ann → Doc ann
docVisualLength : Doc ann → Nat
coalesceText : Doc ann → Doc ann
plainText : Doc ann → String
takeDoc : Nat → Doc ann → Doc ann
dropDoc : Nat → Doc ann → Doc ann
appendLineLists : List (Doc ann) → List (Doc ann) → List (Doc ann)
splitDocLines : Doc ann → List (Doc ann)
```

### Behavior

- `concatDocs` removes neutral `Doc.empty` nodes while concatenating.
- `docVisualLength` measures visible width while ignoring annotations.
- `coalesceText` merges adjacent text nodes so later layout steps operate on more logical text fragments.
- `plainText` strips all annotations and extracts the visible string.
- `takeDoc` keeps the first `n` visible characters while preserving surviving annotations.
- `dropDoc` removes the first `n` visible characters while preserving the remaining annotation structure.
- `appendLineLists` merges line lists from concatenated documents without inventing extra line breaks.
- `splitDocLines` splits a document on `\n` while preserving annotations around each resulting line.

### Why These Helpers Matter

These functions make it possible to manipulate styled documents structurally instead of flattening everything into strings too early.

That matters because Leansi needs to:

- wrap and clip content without losing styles
- compute widths independently from ANSI escape sequences
- keep line-based layout compatible with nested annotations

## Alignment Internals

### API Shape

```lean
justifyFull : String → Nat → String
```

### Behavior

`justifyFull` implements the spacing redistribution used by `Alignment.full`.

The algorithm:

1. splits the line into words
2. computes the total visible width of the words
3. computes how many spaces are needed to hit the target width
4. distributes those spaces across the gaps, giving early gaps one extra space when needed

This is intentionally simple and optimized for terminal output, not for typographic quality.

## Column Layout Internals

### API Shape

```lean
Layout.handleDocOverflow : Nat → Bool → Doc ann → List (Doc ann)
Layout.columns' : List Nat → Nat → List (Doc ann) → List Alignment → Doc ann
```

### Behavior

`Layout.handleDocOverflow`:

- splits the document into logical lines
- checks each line against the allowed width
- either keeps it, clips it, or wraps it into chunks

`Layout.columns'`:

- aligns one already-prepared row of cells
- pads each cell to its configured width
- concatenates the row with the requested gap

The public `Layout.columns` function builds on top of these helpers:

1. preprocess each column with `handleDocOverflow`
2. compute the number of output rows
3. assemble each visual row with `columns'`
4. stack all rows with `Layout.vcat`

## Notes

- The public API exposes these helpers, but they are best understood as infrastructure.
- `box` and `tree` both depend on the same line-oriented representation built from `splitDocLines` and `Layout.vcat`.

