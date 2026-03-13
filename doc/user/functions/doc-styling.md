# Doc Styling

## Purpose

The `leansi.Doc` namespace provides the main end-user styling API. These functions attach `Style` annotations to `Doc Style` values without forcing you to build `Style` structures manually.

## API Shape

Text attributes:

```lean
bold underline italic dim blink reverse hidden strikethrough :
  Doc Style → Doc Style
```

ANSI 16 foreground colors:

```lean
black red green yellow blue magenta cyan white :
  Doc Style → Doc Style

bright_black bright_red bright_green bright_yellow
bright_blue bright_magenta bright_cyan bright_white :
  Doc Style → Doc Style

grey gray : Doc Style → Doc Style
```

ANSI 16 background colors:

```lean
bg_black bg_red bg_green bg_yellow bg_blue bg_magenta bg_cyan bg_white :
  Doc Style → Doc Style

bg_bright_black bg_bright_red bg_bright_green bg_bright_yellow
bg_bright_blue bg_bright_magenta bg_bright_cyan bg_bright_white :
  Doc Style → Doc Style

bg_grey bg_gray : Doc Style → Doc Style
```

Richer color requests:

```lean
fg_ansi_256 : Nat → Doc Style → Style → Doc Style
bg_ansi_256 : Nat → Doc Style → Style → Doc Style
fg_rgb : Nat → Nat → Nat → Doc Style → Style → Doc Style
bg_rgb : Nat → Nat → Nat → Doc Style → Style → Doc Style
```

## Behavior

Each helper wraps the document in an annotation. Multiple helpers can be chained with `|>`:

```lean
Doc.text "warning" |> bold |> bright_yellow
```

The color helpers only request colors. The actual terminal output still depends on terminal capabilities:

- truecolor may be downsampled to ANSI 256 or ANSI 16
- ANSI 256 may be downsampled to ANSI 16
- all colors are removed when color support is disabled

## Parameters and Configuration

For `fg_ansi_256`, `bg_ansi_256`, `fg_rgb`, and `bg_rgb`:

- color or RGB components specify the requested color
- the `Doc Style` argument is the document to style
- the optional trailing `Style` parameter lets you merge the new color into an existing base style

In typical code, you can ignore the trailing style argument:

```lean
Doc.text "accent" |> fg_rgb 120 180 255
```

## Example Usage

```lean
import leansi

open leansi
open leansi.Doc

def demo : Doc Style :=
  (Doc.text "bold" |> bold) ++ Doc.text ", " ++
  (Doc.text "underline" |> underline) ++ Doc.text ", " ++
  (Doc.text "rgb" |> fg_rgb 100 150 220) ++ Doc.text ", " ++
  (Doc.text "background" |> bg_bright_blue)
```

## Notes

- `grey` and `gray` are aliases of `bright_black`.
- `bg_grey` and `bg_gray` are aliases of `bg_bright_black`.
- These helpers are the most convenient API for normal CLI code.
- If you need to construct styles manually or combine styles explicitly, see [Style](style.md).

## Related Pages

- [Doc](doc.md)
- [Style](style.md)
- [Rendering](rendering.md)
- [Terminal color support](color-support.md)

