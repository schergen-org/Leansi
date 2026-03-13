# Style

## Purpose

`Style` is the low-level styling type used inside `Doc Style`. This page is for users who want more control than the convenience helpers in `leansi.Doc`.

## API Shape

Core types:

```lean
inductive ColorLevel where
| none
| ansi16 : Nat → ColorLevel
| ansi256 : Nat → ColorLevel
| truecolor : Nat × Nat × Nat → ColorLevel

structure Style where
  foreground : Option ColorLevel := none
  background : Option ColorLevel := none
  isBold : Bool := false
  isDim : Bool := false
  isUnderline : Bool := false
  isItalic : Bool := false
  isBlink : Bool := false
  isReverse : Bool := false
  isHidden : Bool := false
  isStrikethrough : Bool := false
```

ANSI 16 code table:

```lean
structure Ansi16Color where
  ...

def ansi16Color : Ansi16Color
```

Low-level builders in namespace `Style`:

```lean
Style.bold Style.underline Style.italic Style.dim
Style.blink Style.reverse Style.hidden Style.strikethrough : Style → Style

Style.fg_ansi_16 Style.bg_ansi_16 : Nat → Style → Style
Style.fg_ansi_256 Style.bg_ansi_256 : Nat → Style → Style
Style.fg_rgb Style.bg_rgb : Nat → Nat → Nat → Style → Style

Style.combine : Style → Style → Style
```

The `Style` namespace also exposes the same named ANSI 16 foreground and background convenience functions as `leansi.Doc`, for example:

```lean
Style.red Style.bright_green Style.bg_blue Style.bg_bright_white : Style → Style
Style.grey Style.gray Style.bg_grey Style.bg_gray : Style → Style
```

## Behavior

- `ColorLevel` stores requested color fidelity independently from terminal support.
- `Style` stores foreground, background, and boolean text attributes.
- `Style.combine older newer` merges nested styles:
  - newer colors override older colors
  - boolean attributes accumulate with logical OR

This is the same rule used when nested document annotations are rendered.

## Parameters and Configuration

- `foreground` and `background` are optional, so a style can change one without touching the other.
- `ColorLevel.none` explicitly means “no color”.
- `ansi16Color` gives named numeric SGR codes such as `ansi16Color.red`.

## Example Usage

Manual style construction:

```lean
import leansi

open leansi

def emphasis : Style :=
  Style.bold (Style.fg_rgb 120 200 255)

def msg : Doc Style :=
  Doc.ann emphasis (Doc.text "manual style")
```

Explicit combination:

```lean
def base : Style := Style.bold
def accent : Style := Style.fg_ansi_256 208
def combined : Style := Style.combine base accent
```

## Notes

- Most users should prefer the higher-level helpers from `leansi.Doc`.
- Manual style construction is useful when styles come from configuration values or program logic.
- `Style.combine` is especially useful when you want to mirror Leansi’s nested-style behavior outside the renderer.

## Related Pages

- [Doc styling](doc-styling.md)
- [Rendering](rendering.md)
- [Terminal color support](color-support.md)
