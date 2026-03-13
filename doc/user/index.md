# User Documentation

This section documents Leansi from the perspective of a library user who wants to produce clearer, more readable terminal output in Lean 4.

## What Leansi Gives You

- structured documents instead of manual string concatenation
- composable text styling and color helpers
- alignment and fixed-width layout helpers
- terminal-aware rendering with automatic color fallback
- ready-to-use widgets for boxes, trees, and progress bars

## How To Read This Section

Start with the basic document model, then move to styling, layout, and widgets:

1. [How to use these docs](how-to-use-the-docs.md)
2. [Doc](functions/doc.md)
3. [Doc styling](functions/doc-styling.md)
4. [Style](functions/style.md)
5. [Alignment](functions/alignment.md)
6. [Layout primitives](functions/layout-primitives.md)
7. [Layout.columns](functions/layout-columns.md)
8. [Layout.fitToTerminal](functions/layout-fit-to-terminal.md)
9. [Terminal color support](functions/color-support.md)
10. [Terminal dimensions](functions/terminal-dimensions.md)
11. [Rendering](functions/rendering.md)
12. [Box](functions/box.md)
13. [Tree](functions/tree.md)
14. [Progress bars](functions/progressbar.md)

## Public API Covered Here

The user section covers every public feature that is directly useful when building terminal output. That includes advanced but still intentional APIs such as:

- direct `Style` construction
- `Doc.renderWithStyle` for custom annotation-to-style mapping
- `forest` in addition to `tree`

Public declarations that exist mainly to support internal implementation are covered in the internal section:

- document slicing and line splitting helpers
- ANSI encoding helpers
- color downsampling helpers
- internal layout steps such as overflow handling

