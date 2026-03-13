# How To Use These Docs

## Purpose

This page explains how the wiki is organized and where to start depending on what you want from Leansi.

## Recommended Paths

If you are new to the library:

1. Read [Doc](functions/doc.md) to understand the document model.
2. Read [Doc styling](functions/doc-styling.md) for the high-level styling helpers used in most code.
3. Read [Rendering](functions/rendering.md) to turn documents into output.
4. Read [Alignment](functions/alignment.md), [Layout primitives](functions/layout-primitives.md), and [Layout.columns](functions/layout-columns.md) for terminal layouts.
5. Read the widget pages for [box](functions/box.md), [tree](functions/tree.md), and [progressBar](functions/progressbar.md).

If you only want a quick start:

```lean
import leansi

open leansi
open leansi.Doc

def main : IO Unit := do
  let msg : Doc Style :=
    Layout.columns [10, 20] 2
      [ Doc.text "status" |> bold
      , Doc.text "ready" |> bright_green
      ]
  println msg
```

If you need lower-level control:

- [Style](functions/style.md) documents `Style`, `ColorLevel`, and manual style construction.
- [Rendering](functions/rendering.md) documents `Doc.renderWithStyle`.
- [Internal documentation](../internal/index.md) explains the implementation pipeline in more detail.

## Scope

These pages focus on the public API that helps users improve terminal output. Internal helper functions are documented separately unless they are needed to explain visible behavior.

## Practical Reading Advice

- Use the user pages when writing application code.
- Use the internal pages when you need to understand behavior such as wrapping, color fallback, or widget assembly.
- Use [Example.lean](../../Example.lean) as inspiration, but not as the complete API reference. The wiki covers functionality that the example does not use directly.
