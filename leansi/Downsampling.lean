import Leansi.Style

namespace leansi

-- rgb -> ansi256 downsampling
-- From https://github.com/Qix-/color-convert/blob/3f0e0d4e92e235796ccb17f6e85c72094a651f49/conversions.js
def trueColorToAnsi256 (r g b : Nat) : Nat :=
-- We use the extended greyscale palette here, with the exception of
-- black and white. normal palette only has 4 greyscale shades.
  if r == g && g == b then
    if r < 8 then 16
    else if r > 248 then 231
    else (r - 8) / 247 * 24 + 232
  else
    let r' := r * 5 / 255
    let g' := g * 5 / 255
    let b' := b * 5 / 255
    16 + (36 * r') + (6 * g') + b'

-- hardcoded ANSI16 palette for downsampling. Colors may not be accurate for every terminal
def ansi16Palette : List (Nat × (Nat × Nat × Nat)) :=
[
  (30, ⟨0,0,0⟩),
  (31, ⟨128,0,0⟩),
  (32, ⟨0,128,0⟩),
  (33, ⟨128,128,0⟩),
  (34, ⟨0,0,128⟩),
  (35, ⟨128,0,128⟩),
  (36, ⟨0,128,128⟩),
  (37, ⟨192,192,192⟩),
  (90, ⟨128,128,128⟩),
  (91, ⟨255,0,0⟩),
  (92, ⟨0,255,0⟩),
  (93, ⟨255,255,0⟩),
  (94, ⟨0,0,255⟩),
  (95, ⟨255,0,255⟩),
  (96, ⟨0,255,255⟩),
  (97, ⟨255,255,255⟩)
]

-- Get squared distance between two RGB colors
def sqDist (a b : Nat × Nat × Nat) : Nat :=
  let dx := if a.1 >= b.1 then a.1 - b.1 else b.1 - a.1
  let dy := if a.2.1 >= b.2.1 then a.2.1 - b.2.1 else b.2.1 - a.2.1
  let dz := if a.2.2 >= b.2.2 then a.2.2 - b.2.2 else b.2.2 - a.2.2
  dx^2 + dy^2 + dz^2

-- Find closest ANSI16 color to given RGB color
def trueColorToAnsi16 (r g b : Nat) : Nat :=
  let distances := ansi16Palette.map (fun (_, rgb) => sqDist rgb (r, g, b))
  let min := distances.min?.getD 0
  let idx := distances.idxOf? min
  match idx with
  | some i => ansi16Palette[i]! |>.1
  | none => 30

-- ansi256 -> ansi16 downsampling
def ansi256ToAnsi16 (n : Nat) : Nat :=
  if n < 16 then
    match n with
    | 0  => 30
    | 1  => 31
    | 2  => 32
    | 3  => 33
    | 4  => 34
    | 5  => 35
    | 6  => 36
    | 7  => 37
    | 8  => 90
    | 9  => 91
    | 10 => 92
    | 11 => 93
    | 12 => 94
    | 13 => 95
    | 14 => 96
    | _  => 97
  else if n < 232 then
    -- 6×6×6 cube
    let n' := n - 16
    let r := n' / 36
    let g := (n' / 6) % 6
    let b := n' % 6
    let scale x := x * 51
    trueColorToAnsi16 (scale r) (scale g) (scale b)
  else
    -- grayscale
    let v := (n - 232) * 10 + 8
    trueColorToAnsi16 v v v

end leansi
