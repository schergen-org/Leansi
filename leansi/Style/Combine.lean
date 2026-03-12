import leansi.Style.Types

namespace leansi
namespace Style

/-- Combine two styles in the same way nested annotations behave.
Newer colors override older ones, while boolean attributes accumulate so that an
outer `bold` is not lost when an inner annotation changes only the color. -/
def combine (s1 s2 : Style) : Style := {
  foreground := s2.foreground <|> s1.foreground
  background := s2.background <|> s1.background
  isBold := s1.isBold || s2.isBold
  isDim := s1.isDim || s2.isDim
  isUnderline := s1.isUnderline || s2.isUnderline
  isItalic := s1.isItalic || s2.isItalic
  isBlink := s1.isBlink || s2.isBlink
  isReverse := s1.isReverse || s2.isReverse
  isHidden := s1.isHidden || s2.isHidden
  isStrikethrough := s1.isStrikethrough || s2.isStrikethrough
}

end Style
end leansi
