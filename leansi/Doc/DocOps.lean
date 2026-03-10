import leansi.Doc.Type
import leansi.Util

namespace leansi

/-- Concatenate two documents while removing neutral `empty` nodes.
This keeps helper code from introducing unnecessary structure into the document tree. -/
def concatDocs : Doc ann → Doc ann → Doc ann
  | Doc.empty, d => d
  | d, Doc.empty => d
  | d1, d2 => Doc.concat d1 d2

/-- Compute the visible width of a document, ignoring annotations.
Alignment and wrapping use this measure instead of the raw tree size. -/
def docVisualLength : Doc ann → Nat
  | Doc.empty => 0
  | Doc.text s => visualLength s
  | Doc.ann _ d => docVisualLength d
  | Doc.concat d1 d2 => docVisualLength d1 + docVisualLength d2

/-- Merge adjacent text fragments so alignment can work on logical lines
    instead of on each tiny concatenated text node. -/
def coalesceText : Doc ann → Doc ann
  | Doc.empty => Doc.empty
  | Doc.text s => Doc.text s
  | Doc.ann a d => Doc.ann a (coalesceText d)
  | Doc.concat d1 d2 =>
    let d1' := coalesceText d1
    let d2' := coalesceText d2
    match d1', d2' with
    | Doc.empty, d => d
    | d, Doc.empty => d
    | Doc.text s1, Doc.text s2 => Doc.text (s1 ++ s2)
    | d1'', d2'' => Doc.concat d1'' d2''

/-- Remove all annotations and recover the document's plain textual content.
This is useful for algorithms such as full justification that need access to the
words themselves rather than the original tree shape. -/
def plainText : Doc ann → String
  | Doc.empty => ""
  | Doc.text s => s
  | Doc.ann _ d => plainText d
  | Doc.concat d1 d2 => plainText d1 ++ plainText d2

/-- Keep only the first `n` visible characters of a document.
The function preserves annotation nodes whenever their remaining content is not empty,
which allows later rendering to keep styling on the surviving prefix. -/
def takeDoc (n : Nat) : Doc ann → Doc ann
  | Doc.empty => Doc.empty
  | Doc.text s => Doc.text (s.take n).toString
  | Doc.ann a d =>
    let t := takeDoc n d
    match t with
    | Doc.empty => Doc.empty
    | _ => Doc.ann a t
  | Doc.concat d1 d2 =>
    let l1 := docVisualLength d1
    if n <= l1 then
      takeDoc n d1
    else
      concatDocs (takeDoc l1 d1) (takeDoc (n - l1) d2)

/-- Drop the first `n` visible characters of a document.
Together with `takeDoc`, this lets layout code slice styled content without
flattening it into a plain string first. -/
def dropDoc (n : Nat) : Doc ann → Doc ann
  | Doc.empty => Doc.empty
  | Doc.text s => Doc.text (s.drop n).toString
  | Doc.ann a d =>
    let r := dropDoc n d
    match r with
    | Doc.empty => Doc.empty
    | _ => Doc.ann a r
  | Doc.concat d1 d2 =>
    let l1 := docVisualLength d1
    if n < l1 then
      concatDocs (dropDoc n d1) d2
    else
      dropDoc (n - l1) d2

/-- Merge two lists of split lines that originated from concatenated documents.
The last line from the left side and the first line from the right side belong to
the same logical line unless an explicit newline separated them. -/
def appendLineLists (l1 l2 : List (Doc ann)) : List (Doc ann) :=
  match l1.reverse, l2 with -- l1 gets reversed to access the last element
  | [], ys => ys
  | xs, [] => xs.reverse
  | last1 :: revInit, first2 :: tail2 =>
    let init := revInit.reverse -- reverse again to get the original order
    let merged := concatDocs last1 first2
    init ++ (merged :: tail2)

/-- Split a document into logical lines by `\n` while preserving style structure. -/
def splitDocLines : Doc ann → List (Doc ann)
  | Doc.empty => [Doc.empty]
  | Doc.text s => (s.splitOn "\n").map Doc.text
  | Doc.ann a d => (splitDocLines d).map (Doc.ann a)
  | Doc.concat d1 d2 => appendLineLists (splitDocLines d1) (splitDocLines d2)

end leansi
