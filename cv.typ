// .. {"export": "output/cv.pdf"}
#import "@preview/gloat:0.1.0": *

#let dark_mode = sys.inputs.at("theme", default: "light") == "dark"
#let bg_color = if dark_mode { rgb("#1b222c") } else { white }
#let text_color = if dark_mode { rgb("#e7e9ee") } else { black }
#set page(
  fill: bg_color,
  foreground: if dark_mode {
    place(top + center, dy: 10pt)[
      #rect(
        stroke: 0.8pt + red,    // 红色边框，粗细为 0.8pt
        radius: 2pt,           // 圆角（如果不想要圆角设为 0pt）
        inset: 4pt,            // 文字距离边框的间距
        // fill: rgb("#1b222c").lighten(10%),
        link("https://rzheng.xyz/cv.pdf")[
          #set text(fill: text_color, size: 11pt, weight: "bold")
          For Preview Only. Click to Get the Print Version (White Background)
        ]
      )
    ]
  } else { none }
)
#set text(fill: text_color)

#show: cv.with(
  author: "Renpeng Zheng",
  // address: "Address here",
  contacts: (
    [#link("mailto:renpeng.zheng@nottingham.ac.uk")[renpeng.zheng\@nottingham.ac.uk]],
    [ORCID iD: #link("https://orcid.org/0009-0005-0309-8458")[0009-0005-0309-8458]],
  ),
  updated: datetime.today(),
)

= Education

#edu(
  institution: "University of Nottingham",
	location: "Nottingham, United Kingdom",
  degrees: (
    [(Expected) PhD in Pure Mathematics],
  ),
  date: datetime(year: 2024, month: 02, day: 01).display("[month repr:short] [year]") + " -- " +datetime(year: 2027, month: 07, day: 01).display("[month repr:short] [year]"),
	details:	"Advisors: Hamid Abban and Johannes Hofscheier",
)

#edu(
  institution: "Imperial College London",
	location: "London, United Kingdom",
  degrees: (
    [MSc in Pure Mathematics],
  ),
  date: datetime(year: 2021, month: 10, day: 01).display("[month repr:short] [year]") + " -- " +datetime(year: 2022, month: 10, day: 01).display("[month repr:short] [year]"),
	details:	"Supervisor: Jonathan Lai",
)

#edu(
  institution: "the Chinese University of Hong Kong, Shenzhen",
	location: "Shenzhen, China",
  degrees: (
    [BSc in Mathematics and Applied Mathematics],
  ),
  date: datetime(year: 2017, month: 09, day: 01).display("[month repr:short] [year]") + " -- " +datetime(year: 2021, month: 05, day: 01).display("[month repr:short] [year]"),
)

// = Employment
// #exp()

= Publications / Preprints
#import "lib/render.typ": render-bib
#let works = "res/works.yml"
#show bibliography: none
#bibliography(works, style: "apa")
#show cite: it => my-cite(yaml(works), str(it.key))
#render-bib(yaml(works))
