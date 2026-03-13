# Color And Rendering Pipeline

## Purpose

This page describes how Leansi turns annotated documents into ANSI-colored terminal output.

## Step 1: Detect Terminal Capability

### API Shape

```lean
containsSub : String → String → Bool
detectColorSupport' : IO ColorSupport
detectColorSupport : IO ColorSupport
```

### Behavior

- `containsSub` is a small helper used by capability detection.
- `detectColorSupport'` performs the actual environment inspection.
- `detectColorSupport` adds caching through an `IO.Ref`.

The cached wrapper is what the rest of the library uses.

## Step 2: Downsample Requested Colors

### API Shape

```lean
trueColorToAnsi256 : Nat → Nat → Nat → Nat
ansi16Palette : List (Nat × (Nat × Nat × Nat))
sqDist : (Nat × Nat × Nat) → (Nat × Nat × Nat) → Nat
trueColorToAnsi16 : Nat → Nat → Nat → Nat
ansi256ToAnsi16 : Nat → Nat
convertColorLevel : ColorSupport → ColorLevel → ColorLevel
```

### Behavior

- truecolor values are kept as RGB when the terminal supports them
- otherwise they are reduced to ANSI 256 or ANSI 16
- ANSI 256 values can be reduced further to ANSI 16
- if the terminal supports no color, color requests become `ColorLevel.none`

The dedicated downsampling functions operate on numeric color values. `convertColorLevel` is the public bridge from requested `ColorLevel` to terminal-supported `ColorLevel`.

## Step 3: Encode ANSI Sequences

### API Shape

```lean
esc : String
reset : String
getColorCodes : Style → List String
styleToSgr : Style → List String
sgrSequence : List String → String
styleToAnsi : Style → String
```

### Behavior

- `getColorCodes` extracts foreground and background SGR fragments
- `styleToSgr` adds boolean style attributes such as bold and underline
- `sgrSequence` wraps the SGR codes in the ANSI escape prefix
- `styleToAnsi` is the final style-to-prefix conversion
- `reset` terminates a styled region

## Step 4: Render Documents

### API Shape

```lean
renderStyled : ColorSupport → Style → String → String
Doc.render : Doc ann → String
Doc.renderWithStyle : (ann → Style) → ColorSupport → Doc ann → String
render : Doc Unit → String
print : Doc Style → IO Unit
println : Doc Style → IO Unit
```

### Behavior

`Doc.renderWithStyle` recursively traverses the document tree:

- text nodes become plain strings
- concatenation joins the rendered pieces
- annotation nodes are converted to `Style` and passed through `renderStyled`

`renderStyled` is responsible for:

1. adapting colors to the terminal support level
2. building the ANSI prefix
3. wrapping the rendered text in the prefix and trailing reset code

`print` and `println` then combine this renderer with `detectColorSupport`.

## Notes

- `Doc.render` is the annotation-free baseline and is useful for testing.
- Because rendering is tree-based, Leansi can keep structured information until the final stage.
- The current renderer applies each annotation directly around its subtree. It does not try to minimize emitted escape sequences.

