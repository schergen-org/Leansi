import leansi.Doc
import leansi.Render.Doc
import leansi.Terminal

namespace leansi

def println (d : Doc Style) : IO Unit := do
  let level ← detectColorSupport
  IO.println (d.renderWithStyle id level)

def print (d : Doc Style) : IO Unit := do
  let level ← detectColorSupport
  IO.print (d.renderWithStyle id level)

end leansi
