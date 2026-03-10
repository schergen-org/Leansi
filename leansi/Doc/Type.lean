import leansi.Style.Types

namespace leansi

inductive Doc (ann : Type) where
| empty : Doc ann
| text : String → Doc ann
| concat : Doc ann → Doc ann → Doc ann
| ann : ann → Doc ann → Doc ann
deriving Repr, Inhabited, BEq

instance {ann : Type} : Append (Doc ann) where
  append := Doc.concat

end leansi
