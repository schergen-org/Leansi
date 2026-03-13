# Terminal Color Support

## Purpose

Leansi can detect how much color the current terminal supports and automatically downgrade richer colors when necessary.

## API Shape

```lean
inductive ColorSupport
| none
| ansi16
| ansi256
| truecolor

detectColorSupport : IO ColorSupport
```

`ColorSupport` also has a `ToString` instance.

## Behavior

`detectColorSupport` checks common environment variables and caches the result for later calls.

Detection order:

1. `NO_COLOR` disables color entirely.
2. `TERM=dumb` disables color entirely.
3. `COLORTERM=truecolor` or `COLORTERM=24bit` enables truecolor.
4. `TERM` containing `256color` enables ANSI 256.
5. Any other non-empty `TERM` becomes ANSI 16.
6. If no useful information is available, Leansi uses `none`.

This result is used automatically by `print` and `println`.

## Parameters

`detectColorSupport` takes no parameters.

## Example Usage

```lean
import leansi

open leansi
open leansi.Doc

def main : IO Unit := do
  let support ← detectColorSupport
  println ((Doc.text "Detected support: ") ++ (Doc.text s!"{support}" |> bright_cyan))
```

## Notes

- The detection result is cached, which avoids repeated environment probing during repeated renders.
- Users normally do not need to call this directly unless they want to display diagnostic information or make output decisions themselves.
- Richer requested colors are downsampled automatically during rendering.

## Related Pages

- [Rendering](rendering.md)
- [Style](style.md)

