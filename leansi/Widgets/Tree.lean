import leansi.Doc.DocOps
import leansi.Layout.LayoutCore

namespace leansi

/-- Glyph set used to draw tree connectors. -/
structure TreeChars where
  /-- Connector used for a non-final sibling (e.g. `├─ `). -/
  tee : String := "├─ "
  /-- Connector used for the final sibling (e.g. `└─ `). -/
  elbow : String := "└─ "
  /-- Prefix segment used while ancestor levels still have pending siblings (e.g. `│  `). -/
  vertical : String := "│  "
  /-- Prefix segment used when no vertical continuation is needed (e.g. `   `). -/
  empty : String := "   "
deriving Repr, Inhabited, BEq

/-- ASCII fallback connector set for terminals where Unicode line-art is undesired. -/
def asciiTreeChars : TreeChars := {
  tee := "|- "
  elbow := "`- "
  vertical := "|  "
  empty := "   "
}

/-- A tree node whose label is rendered as a document and may have nested children. -/
structure Tree where
  /-- Text shown for this node. May contain multiple lines and styles. -/
  label : Doc Style
  /-- Child nodes rendered below this node. -/
  children : List Tree := []
deriving Repr, Inhabited, BEq

namespace Tree

/-- Construct a leaf node with no children. -/
def leaf (label : Doc Style) : Tree :=
  { label := label }

/-- Construct a branch node with an explicit list of child nodes. -/
def branch (label : Doc Style) (children : List Tree) : Tree :=
  { label := label, children := children }

end Tree

/-- Configuration for rendering tree documents. -/
structure TreeConfig where
  /-- Connector glyph set for branch lines. -/
  chars : TreeChars := {}
  /-- Style applied to connector segments (`├─`, `└─`, `│`). -/
  connectorStyle : Style := {}
  /-- Render the root label. If `false`, only the root's children are rendered as a forest. -/
  showRoot : Bool := true
deriving Repr, Inhabited, BEq

namespace TreeWidget

/-- Render a connector segment with `connectorStyle` applied. -/
private def connectorText (cfg : TreeConfig) (s : String) : Doc Style :=
  (Doc.text s).ann cfg.connectorStyle

/-- Build the accumulated prefix from ancestor levels.
Each `true` entry means the corresponding ancestor has following siblings and
therefore needs a vertical continuation marker. -/
private def ancestorPrefix (cfg : TreeConfig) (ancestorHasNext : List Bool) : Doc Style :=
  ancestorHasNext.foldl
    (fun acc hasNext =>
      acc ++ connectorText cfg (if hasNext then cfg.chars.vertical else cfg.chars.empty))
    Doc.empty

/-- Prefix each label line correctly.
The first line uses `firstPrefix`, continuation lines use `restPrefix` so
multi-line labels stay visually aligned in the tree. -/
private def prefixedLabelLines (firstPrefix restPrefix label : Doc Style) : List (Doc Style) :=
  match splitDocLines label with
  | [] => [firstPrefix]
  | first :: rest => (firstPrefix ++ first) :: rest.map (fun line => restPrefix ++ line)

/-- Render one node plus its descendants into display lines. -/
-- `renderNode` is partial because it calls itself recursively, but it is guaranteed to terminate since the tree is finite.
private partial def renderNode (cfg : TreeConfig) (ancestorHasNext : List Bool) (isLast : Bool)
    (isRoot : Bool) (node : Tree) : List (Doc Style) :=
  match node with
  | { label, children } =>
    let ancestorDoc := ancestorPrefix cfg ancestorHasNext

    let branchPrefix :=
      if isRoot then Doc.empty
      else connectorText cfg (if isLast then cfg.chars.elbow else cfg.chars.tee)

    let continuationPrefix :=
      if isRoot then ancestorDoc
      else ancestorDoc ++ connectorText cfg (if isLast then cfg.chars.empty else cfg.chars.vertical)

    let thisNodeLines := prefixedLabelLines (ancestorDoc ++ branchPrefix) continuationPrefix label

    let childAncestors :=
      if isRoot then ancestorHasNext
      else ancestorHasNext ++ [not isLast]

    let rec renderChildren : List Tree → List (Doc Style)
      | [] => []
      | child :: rest =>
        let childIsLast := rest.isEmpty
        renderNode cfg childAncestors childIsLast false child ++ renderChildren rest

    thisNodeLines ++ renderChildren children
/-- Render a sibling list using the same ancestor prefix context. -/
-- `renderForest` is partial because it calls `renderNode`, which is partial, but it is guaranteed to terminate since the tree is finite.
private partial def renderForest (cfg : TreeConfig) (ancestorHasNext : List Bool) : List Tree → List (Doc Style)
  | [] => []
  | node :: rest =>
    let isLast := rest.isEmpty
    renderNode cfg ancestorHasNext isLast false node ++ renderForest cfg ancestorHasNext rest

/-- Render a sibling list, marking every node as root-level (no branch prefix before first level). -/
-- `renderForestAsRoot` is partial because it calls `renderNode`, which is partial, but it is guaranteed to terminate since the tree is finite.
private partial def renderForestAsRoot (cfg : TreeConfig) : List Tree → List (Doc Style)
  | [] => []
  | node :: rest =>
    let isLast := rest.isEmpty
    renderNode cfg [] isLast true node ++ renderForestAsRoot cfg rest

end TreeWidget

open TreeWidget in
/-- Render one tree as a document with `├─` / `└─` style connectors.
If `showRoot = false`, the root is treated as an invisible container and only
its children are rendered. -/
def tree (root : Tree) (cfg : TreeConfig := {}) : Doc Style :=
  let lines :=
    if cfg.showRoot then
      renderNode cfg [] true true root
    else
      renderForestAsRoot cfg root.children
  Layout.vcat lines

open TreeWidget in
/-- Render multiple top-level trees as one forest document. -/
def forest (roots : List Tree) (cfg : TreeConfig := {}) : Doc Style :=
  Layout.vcat (renderForest cfg [] roots)

end leansi
