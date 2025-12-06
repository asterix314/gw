#import "@preview/zebraw:0.6.1": zebraw
#import "@preview/fletcher:0.5.8": diagram, node, edge

#let assignment(
  title: none,
  authors: (),
  university-logo: none,
  course: none,
  figure-numbering: none,
  heading-numbering: "1.",
  enum-numbering: "1)",
  watermark: false,
  text-size: 11pt,
  body,
) = {
  set page(
    paper: "a4",
    margin: (top: 1in, right: 1in, bottom: 2cm, left: 1in),
    header: context {
      if counter(page).get().first() > 1 [
        #title
        #h(1fr)
        #counter(page).display()
      ]
    },
    footer: context {
      if counter(page).get().first() > 1 {
        align(right, course)
      }
    },
    background: if watermark {
      rotate(24deg, text(
        [*SAMPLE\ 样例*],
        size: 120pt, 
        fill: red.lighten(65%), 
        font: "Microsoft YaHei"))},
  )

  set text(text-size, 
    font: ("STIX Two Text", "DengXian"),
    weight:"medium"
  )
  show math.equation: set text(
    font: "STIX Two Math",
    weight: "medium")

  set list(indent: 8pt)
  set enum(numbering: enum-numbering)

  set heading(numbering: heading-numbering)
  show heading: set block(below: 10pt)
  
  grid(
    columns: (auto, 1fr),
    {
      emph(course)
      v(-0.4em)
      strong(text(2em, title))
      linebreak()
      v(0.5em)

      for author in authors [
        #set text(font: "Noto Sans")
        #text(fill: gray)[▌]#smallcaps(author.name) (#author.student-no) |
        #link("mailto:" + author.email) \
      ]
      if authors != () {
        v(0.5em)
      }
    },
    align(
      right,
      if university-logo != none {
        box(height: 3em, university-logo)
      },
    ),
  )

  set par(justify: true)
  set figure(numbering: figure-numbering)
  show figure: align.with(center)
  show figure.caption: pad.with(x: 10%)
  show figure.caption: set text(9pt, 
    style: "italic", 
    weight: "regular"
  )
  
  show raw: zebraw.with(
    numbering-separator: true,
    background-color: silver.transparentize(80%),
    highlight-color: silver.transparentize(20%),
  )

  body
}


#let sol(content) = {
  set text(font: "Fira Sans", style: "italic", weight: "light")
  show math.equation: set text(font: "Fira Math", fill: luma(40%))
  show raw: set text(
    font: ("Fira Code Retina", "LXGW WenKai Mono"),
    fill: luma(30%))
  set table.hline(stroke: .5pt)
  set table.vline(stroke: .5pt)

  text(font: "Noto Emoji", [✏️]) + h(6pt) + content + h(1fr) + $qed$
}
