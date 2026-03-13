# Doc

## Purpose

`Doc` is the core data type of Leansi. It represents terminal output as a structured document tree, which lets the library apply layout and styling before converting the result into plain text.

## API Shape

```lean
inductive Doc (ann : Type) where
| empty : Doc ann
| text : String → Doc ann
| concat : Doc ann → Doc ann → Doc ann
| ann : ann → Doc ann → Doc ann

instance : Append (Doc ann)
```

Important constructors and operators:

- `Doc.empty`
- `Doc.text`
- `Doc.concat`
- `Doc.ann`
- `++`

## Behavior

- `Doc.empty` is the neutral element for document composition.
- `Doc.text s` stores visible text.
- `Doc.concat a b` combines two documents in sequence.
- `Doc.ann x doc` attaches an annotation to a subtree.
- `a ++ b` is syntax for concatenation through the `Append` instance.

Leansi commonly uses `Doc Style`, but `Doc` is generic. That matters for advanced rendering because `Doc.renderWithStyle` can turn custom annotations into `Style` values later.

## Parameters

- `ann`: the annotation type attached to document regions

## Example Usage

```lean
import leansi

open leansi

def greeting : Doc Style :=
  Doc.text "Hello" ++ Doc.text ", world"
```

With explicit annotations:

```lean
def custom : Doc Nat :=
  Doc.ann 1 (Doc.text "tagged")
```

## Notes

- Most application code uses `Doc.text`, `Doc.empty`, and `++`.
- For styled terminal output, the usual type is `Doc Style`.
- `Doc.ann` is public and useful, but most users prefer the higher-level helpers documented on [Doc styling](doc-styling.md).
- Rendering functions for `Doc` are documented on [Rendering](rendering.md).

## Related Pages

- [Doc styling](doc-styling.md)
- [Style](style.md)
- [Rendering](rendering.md)

