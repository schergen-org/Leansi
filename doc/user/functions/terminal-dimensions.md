# Terminal Dimensions

## Purpose

`getTerminalDimensions` provides best-effort access to the current terminal size. It is useful when your output should adapt to the available width.

## API Shape

```lean
getTerminalDimensions : IO (Option (Nat × Nat))
```

The returned pair is `(rows, cols)`.

## Behavior

The function tries several strategies:

1. Use the `LINES` and `COLUMNS` environment variables when both are present.
2. On Unix-like systems, run `stty size < /dev/tty`.
3. On Windows, query PowerShell for `$Host.UI.RawUI.WindowSize`.

It returns `none` if the terminal size cannot be detected, for example when no real TTY is attached.

## Parameters

`getTerminalDimensions` takes no parameters.

## Example Usage

```lean
import leansi

open leansi
open leansi.Doc

def main : IO Unit := do
  let dims ← getTerminalDimensions
  let msg :=
    match dims with
    | some (rows, cols) =>
        (Doc.text s!"{rows}" |> bright_green) ++
        Doc.text " rows, " ++
        (Doc.text s!"{cols}" |> bright_blue) ++
        Doc.text " cols"
    | none =>
        Doc.text "No terminal dimensions available" |> bright_red
  println msg
```

## Notes

- The library does not assume that dimension detection always succeeds.
- `Layout.fitToTerminal` is the higher-level convenience API when you only need terminal-aware alignment.

## Related Pages

- [Layout.fitToTerminal](layout-fit-to-terminal.md)
- [Alignment](alignment.md)

