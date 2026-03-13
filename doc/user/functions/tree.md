# tree

## Purpose

Leansi can render hierarchical terminal output with branch connectors such as `├─` and `└─`.

## API Shape

```lean
structure TreeChars where
  tee : String := "├─ "
  elbow : String := "└─ "
  vertical : String := "│  "
  empty : String := "   "

asciiTreeChars : TreeChars

structure Tree where
  label : Doc Style
  children : List Tree := []

Tree.leaf : Doc Style → Tree
Tree.branch : Doc Style → List Tree → Tree

structure TreeConfig where
  chars : TreeChars := {}
  connectorStyle : Style := {}
  showRoot : Bool := true

tree : Tree → TreeConfig → Doc Style
forest : List Tree → TreeConfig → Doc Style
```

## Behavior

- `Tree.leaf` creates a node without children.
- `Tree.branch` creates a node with children.
- `tree root cfg` renders a single tree.
- `forest roots cfg` renders multiple top-level trees as one forest.

Connector behavior:

- non-final siblings use `tee`
- final siblings use `elbow`
- ancestor levels with remaining siblings use `vertical`
- levels without continuation use `empty`

Multi-line labels are supported. Continuation lines are aligned under the first label line rather than under the connector.

If `showRoot = false`, the root node is treated as an invisible container and only its children are rendered.

## Parameters and Configuration

`TreeChars`:

- `tee`: connector for non-final siblings
- `elbow`: connector for final siblings
- `vertical`: vertical continuation for ancestor levels
- `empty`: blank prefix for ancestor levels without continuation

`TreeConfig`:

- `chars`: connector glyph set
- `connectorStyle`: style for connector segments only
- `showRoot`: whether to draw the root label

## Example Usage

```lean
import leansi

open leansi
open leansi.Doc

def projectTree : Tree :=
  Tree.branch (Doc.text "leansi" |> bright_cyan |> bold)
    [ Tree.branch (Doc.text "Doc")
        [ Tree.leaf (Doc.text "Type.lean")
        , Tree.leaf (Doc.text "DocOps.lean")
        ]
    , Tree.leaf (Doc.text "README.md" |> bright_yellow)
    ]

def unicodeTree : Doc Style :=
  tree projectTree { connectorStyle := Style.fg_rgb 150 180 255 }

def asciiTree : Doc Style :=
  tree projectTree { chars := asciiTreeChars }
```

Forest rendering:

```lean
def multiple : Doc Style :=
  forest
    [ Tree.leaf (Doc.text "one")
    , Tree.branch (Doc.text "two") [Tree.leaf (Doc.text "child")]
    ]
```

## Notes

- Unicode connectors are the default.
- `asciiTreeChars` is useful for environments where Unicode line drawing is not desired.
- `showRoot := false` is convenient when your data model naturally has an invisible container root.

## Related Pages

- [Layout primitives](layout-primitives.md)
- [Style](style.md)

