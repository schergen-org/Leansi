import leansi.Style.Types

namespace leansi

/-- `Doc ann` is the central document tree of the library.
It stores text structure separately from annotations so layout can inspect the
content first and rendering can interpret `ann` later. -/
inductive Doc (ann : Type) where
| empty : Doc ann
| text : String → Doc ann
| concat : Doc ann → Doc ann → Doc ann
| ann : ann → Doc ann → Doc ann
deriving Repr, Inhabited, BEq

/-- Appending documents builds a larger document tree instead of flattening
immediately to text. This keeps information available for later layout and
styling passes. -/
instance {ann : Type} : Append (Doc ann) where
  append := Doc.concat

end leansi
