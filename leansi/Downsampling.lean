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

end leansi
