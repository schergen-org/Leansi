# box

## Purpose

`box` draws a border around a document and can add an optional title, padding, custom border characters, and border styling.

## API Shape

```lean
structure BoxChars where
  topLeft : Char
  topRight : Char
  bottomLeft : Char
  bottomRight : Char
  horizontal : Char
  vertical : Char

asciiBoxChars : BoxChars
roundedBoxChars : BoxChars

structure BoxConfig where
  chars : BoxChars := {}
  borderStyle : Style := {}
  title : Option (Doc Style) := none
  titleAlignment : Alignment := Alignment.center
  paddingX : Nat := 1
  paddingY : Nat := 0
  minInnerWidth : Nat := 0
  maxWidth : Nat := 9999
  textOverflow : Bool := false

box : Doc Style → BoxConfig → Doc Style
```

## Behavior

`box content cfg` wraps the content in a border.

Important behaviors:

- the content can contain multiple lines
- `paddingX` and `paddingY` insert space between content and border
- an optional `title` is embedded into the top border
- `titleAlignment` controls whether the title sits left, center, or right
- `maxWidth` limits the inner content width
- `textOverflow = false` wraps overlong content
- `textOverflow = true` truncates overlong content

The border characters themselves are styled with `borderStyle`. The content keeps its own styling.

## Parameters and Configuration

`BoxChars` defines the six characters used for the border.

Presets:

- `asciiBoxChars`: plain ASCII borders
- `roundedBoxChars`: rounded Unicode corners

`BoxConfig`:

- `chars`: border character set
- `borderStyle`: style for border glyphs only
- `title`: optional title document
- `titleAlignment`: title placement inside the top border
- `paddingX`: horizontal inner padding
- `paddingY`: vertical inner padding
- `minInnerWidth`: minimum content width inside the box
- `maxWidth`: maximum width the content area may use
- `textOverflow`: truncate instead of wrap when width is exceeded

## Example Usage

Centered title with padding:

```lean
def panel : Doc Style :=
  box
    (Layout.vcat
      [ Doc.text "Leansi can draw boxes around docs."
      , Doc.text "Title placement is configurable."
      ])
    {
      title := some (Doc.text "Unicode Box" |> bright_cyan |> bold)
      borderStyle := Style.fg_rgb 120 190 255
      titleAlignment := Alignment.center
      paddingX := 2
      paddingY := 1
    }
```

ASCII fallback:

```lean
def retro : Doc Style :=
  box
    (Doc.text "ASCII fallback works as well.")
    {
      title := some (Doc.text "ASCII")
      chars := asciiBoxChars
      titleAlignment := Alignment.left
    }
```

Rounded style:

```lean
def rounded : Doc Style :=
  box
    (Doc.text "Rounded corners are available too.")
    {
      title := some (Doc.text "Rounded")
      chars := roundedBoxChars
      titleAlignment := Alignment.right
    }
```

## Notes

- Titles count toward the required width of the top border.
- `box` can be nested inside another `box`.
- Content wrapping uses the same overflow machinery that also powers `Layout.columns`.

## Related Pages

- [Layout primitives](layout-primitives.md)
- [Layout.columns](layout-columns.md)
- [Alignment](alignment.md)

