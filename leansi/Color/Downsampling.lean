import leansi.Style.Types

namespace leansi

/-- Approximate a truecolor RGB value with the closest ANSI 256 palette entry.
Greyscale values use the dedicated greyscale ramp, while other colors are mapped
onto the 6x6x6 ANSI color cube. -/
-- Inspired by https://github.com/Qix-/color-convert/blob/3f0e0d4e92e235796ccb17f6e85c72094a651f49/conversions.js
def trueColorToAnsi256 (r g b : Nat) : Nat :=
  if r == g && g == b then
    if r < 8 then 16
    else if r > 248 then 231
    else (r - 8) / 247 * 24 + 232
  else
    let r' := r * 5 / 255
    let g' := g * 5 / 255
    let b' := b * 5 / 255
    16 + (36 * r') + (6 * g') + b'

/-- Representative RGB values for the ANSI 16 palette.
These are used as reference points when reducing richer colors to ANSI 16.
Colors may not be accurate for every terminal. -/
def ansi16Palette : List (Nat × (Nat × Nat × Nat)) :=
[
  (ansi16Color.black, ⟨0,0,0⟩),
  (ansi16Color.red, ⟨128,0,0⟩),
  (ansi16Color.green, ⟨0,128,0⟩),
  (ansi16Color.yellow, ⟨128,128,0⟩),
  (ansi16Color.blue, ⟨0,0,128⟩),
  (ansi16Color.magenta, ⟨128,0,128⟩),
  (ansi16Color.cyan, ⟨0,128,128⟩),
  (ansi16Color.white, ⟨192,192,192⟩),
  (ansi16Color.bright_black, ⟨128,128,128⟩),
  (ansi16Color.bright_red, ⟨255,0,0⟩),
  (ansi16Color.bright_green, ⟨0,255,0⟩),
  (ansi16Color.bright_yellow, ⟨255,255,0⟩),
  (ansi16Color.bright_blue, ⟨0,0,255⟩),
  (ansi16Color.bright_magenta, ⟨255,0,255⟩),
  (ansi16Color.bright_cyan, ⟨0,255,255⟩),
  (ansi16Color.bright_white, ⟨255,255,255⟩)
]

/-- Squared distance in RGB space.
The square root is unnecessary because only the relative ordering of distances matters. -/
def sqDist (a b : Nat × Nat × Nat) : Nat :=
  let dx := if a.1 >= b.1 then a.1 - b.1 else b.1 - a.1
  let dy := if a.2.1 >= b.2.1 then a.2.1 - b.2.1 else b.2.1 - a.2.1
  let dz := if a.2.2 >= b.2.2 then a.2.2 - b.2.2 else b.2.2 - a.2.2
  dx^2 + dy^2 + dz^2

/-- Approximate a truecolor RGB value by the nearest ANSI 16 color.
This is a simple nearest-neighbour search over the reference palette above. -/
def trueColorToAnsi16 (r g b : Nat) : Nat :=
  let distances := ansi16Palette.map (fun (_, rgb) => sqDist rgb (r, g, b))
  let min := distances.min?.getD 0
  let idx := distances.idxOf? min
  match idx with
  | some i => ansi16Palette[i]! |>.1
  | none => 30

/-- Convert an ANSI 256 index to the nearest ANSI 16 color.
Entries from the ANSI 256 color cube and greyscale ramp are first reconstructed
as RGB values and then mapped with `trueColorToAnsi16`. -/
def ansi256ToAnsi16 (n : Nat) : Nat :=
  if n < 16 then
    match n with
    | 0  => ansi16Color.black
    | 1  => ansi16Color.red
    | 2  => ansi16Color.green
    | 3  => ansi16Color.yellow
    | 4  => ansi16Color.blue
    | 5  => ansi16Color.magenta
    | 6  => ansi16Color.cyan
    | 7  => ansi16Color.white
    | 8  => ansi16Color.bright_black
    | 9  => ansi16Color.bright_red
    | 10 => ansi16Color.bright_green
    | 11 => ansi16Color.bright_yellow
    | 12 => ansi16Color.bright_blue
    | 13 => ansi16Color.bright_magenta
    | 14 => ansi16Color.bright_cyan
    | _  => ansi16Color.bright_white
  else if n < 232 then
    let n' := n - 16
    let r := n' / 36
    let g := (n' / 6) % 6
    let b := n' % 6
    let scale x := x * 51
    trueColorToAnsi16 (scale r) (scale g) (scale b)
  else
    let v := (n - 232) * 10 + 8
    trueColorToAnsi16 v v v

end leansi
