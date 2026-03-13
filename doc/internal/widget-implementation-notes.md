# Widget Implementation Notes

## Purpose

This page summarizes how the built-in widgets are assembled internally.

## Progress Bars

### Public Structures

```lean
ProgressThreshold
ProgressBarConfig
progressBar
simpleProgressBar
```

### Internal Strategy

The progress bar implementation is structurally simple:

1. compute `filledCount` from `value` and `width`
2. compute `emptyCount` as the remaining width
3. resolve the active color from the threshold list
4. build a styled filled segment and an unstyled empty segment
5. optionally add brackets
6. optionally append an aligned percentage label

The local helper namespace `Progressbar` contains two private helpers:

- threshold resolution
- fixed-width percentage formatting

## Boxes

### Public Structures

```lean
BoxChars
asciiBoxChars
roundedBoxChars
BoxConfig
box
```

### Internal Strategy

The box widget is line-based:

1. derive content lines with `Layout.handleDocOverflow`
2. compute the widest content line
3. enlarge the width if needed for `minInnerWidth` or the title
4. build the top border, optional padding rows, content rows, and bottom border
5. combine them with `Layout.vcat`

Important design choices:

- border glyphs are styled separately from the content
- titles are embedded into the top border rather than rendered above the box
- wrapping and truncation are delegated to the shared layout machinery

## Trees

### Public Structures

```lean
TreeChars
asciiTreeChars
Tree
Tree.leaf
Tree.branch
TreeConfig
tree
forest
```

### Internal Strategy

Tree rendering is implemented with recursive line generation:

1. accumulate prefix state for ancestor levels
2. choose `tee` or `elbow` depending on whether the current node is the last sibling
3. split the label into lines
4. prefix the first label line differently from continuation lines
5. recurse into children with updated ancestor state

The implementation tracks ancestor levels as a `List Bool` where each entry says whether that level still has following siblings. This directly determines whether to emit `vertical` or `empty` prefix segments.

`forest` is the sibling-list version of the same rendering logic.

## Notes

- All three widgets build plain `Doc Style` values. They do not render directly.
- This design keeps widgets composable with `Layout.columns`, `Layout.vcat`, and the rest of the document pipeline.

