# Rendering

## Purpose

Rendering turns a `Doc` into text, either as a `String` or as direct terminal output. This is where Leansi interprets styles and adapts colors to terminal capabilities.

## API Shape

```lean
Doc.render : Doc ann → String
Doc.renderWithStyle : (ann → Style) → ColorSupport → Doc ann → String
render : Doc Unit → String

println : Doc Style → IO Unit
print : Doc Style → IO Unit
```

## Behavior

- `Doc.render` ignores annotations completely and concatenates text.
- `Doc.renderWithStyle` converts annotations with a caller-supplied function and emits ANSI styling according to a chosen `ColorSupport`.
- `render` is a convenience wrapper for `Doc Unit`.
- `println` and `print` automatically call `detectColorSupport`, render the document, and send it to the terminal.

In normal CLI code, `println` is the standard choice:

```lean
println (Doc.text "ready" |> bold |> bright_green)
```

Use `Doc.renderWithStyle` when:

- you want a string instead of immediate terminal output
- you use a custom annotation type
- you want to force a specific color support level for testing or alternate output targets

## Parameters

For `Doc.renderWithStyle`:

- `ann → Style`: how to turn annotations into terminal styles
- `ColorSupport`: what the output terminal can display
- `Doc ann`: the document to render

For `print` and `println`:

- `Doc Style`: the styled document to output

## Example Usage

Ignoring styles:

```lean
def raw : String :=
  (Doc.text "plain" |> bright_red).render
```

Rendering with explicit support:

```lean
def asString : String :=
  (Doc.text "rgb" |> fg_rgb 120 180 255).renderWithStyle id ColorSupport.ansi16
```

Printing:

```lean
def main : IO Unit := do
  println (Doc.text "build ok" |> bold |> bright_green)
```

Custom annotation type:

```lean
inductive Mark where
| info
| danger

def markToStyle : Mark → Style
| .info => Style.fg_rgb 120 190 255
| .danger => Style.bold (Style.red)

def custom : String :=
  (Doc.ann Mark.info (Doc.text "notice")).renderWithStyle markToStyle ColorSupport.truecolor
```

## Notes

- `println` adds a trailing newline; `print` does not.
- `Doc.render` is useful for testing layout without ANSI output.
- Color adaptation is automatic in `print` and `println`.

## Related Pages

- [Doc](doc.md)
- [Style](style.md)
- [Terminal color support](color-support.md)

