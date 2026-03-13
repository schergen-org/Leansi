# Leansi Wiki Source

Leansi is a Lean 4 library for building terminal output from structured documents instead of raw strings. It combines document composition, styling, alignment, layout helpers, terminal capability detection, and ready-made widgets such as boxes, trees, and progress bars.

This `/doc` directory is organized as source material for a future GitHub Wiki. It is split into two parts:

- [User documentation](user/index.md): how to use the library to improve terminal output in CLI programs.
- [Implementation-oriented documentation](internal/index.md): how the library is structured internally, including helpers and rendering details that matter for the university submission.

## Recommended Reading Order

1. [User overview](user/index.md)
2. [How to use these docs](user/how-to-use-the-docs.md)
3. [Doc](user/functions/doc.md)
4. [Doc styling](user/functions/doc-styling.md)
5. [Alignment](user/functions/alignment.md)
6. [Layout primitives](user/functions/layout-primitives.md)
7. [Layout.columns](user/functions/layout-columns.md)
8. [Box](user/functions/box.md)
9. [Tree](user/functions/tree.md)
10. [Progress bars](user/functions/progressbar.md)
11. [Rendering](user/functions/rendering.md)

## Coverage

The user section documents all public, user-relevant functionality exported by the repository, including:

- structured documents via `Doc`
- document-level styling helpers in `leansi.Doc`
- low-level style values and style combination
- rendering and printing
- terminal color support and terminal dimension detection
- alignment and layout helpers
- `Layout.columns` and `Layout.vcat`
- `box`
- `tree` and `forest`
- `progressBar` and `simpleProgressBar`

Public helpers that are mainly implementation support rather than intended end-user entry points are documented in the internal section instead of receiving standalone user pages.

