import leansi.Doc.Type
import leansi.Render.Doc
import leansi.Terminal.ColorSupport

namespace leansi

/-- Print a styled document followed by a newline, adapting colors to the current terminal. -/
def println (d : Doc Style) : IO Unit := do
  let level ← detectColorSupport
  IO.println (d.renderWithStyle id level)

/-- Print a styled document without appending a newline. -/
def print (d : Doc Style) : IO Unit := do
  let level ← detectColorSupport
  IO.print (d.renderWithStyle id level)

end leansi
