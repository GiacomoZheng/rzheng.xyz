#import "@preview/clickworthy-resume:1.1.0": *

// Contract
#let email = "renpeng.zheng@nottingham.ac.uk"
// #let github = ""
// #let linkedin = ""
#let url = "https://rzheng.xyz"
#let orcid = "0009-0005-0309-8458"

// configuration
#show: resume.with(
  author: "Renpeng Zheng",
  role: "",
  location: "",
  contacts: (
    [#link("mailto:" + email)[#email]],
    [#link(url)[#url]],
    [ORCID: #link("https://orcid.org/" + orcid)[#orcid]],
  ),
  summary: "",
  theme-color: rgb("#26428b"),
  font: "New Computer Modern",
  font-size: 11pt,
  lang: "en",
  margin: (
    top: 1cm,
    bottom: 0cm,
    left: 1cm,
    right: 1cm,
  ),
)

#import "render.typ": render-pdf-bib, render-talks
#let works = "./works.yml"
#let talks = "./talks.yml"



= Research Interests

Algebraic geometry: K-stability, birational geometry, toric and spherical varieties.

Complex analytic geometry: Archimedean and non-Archimedean pluripotential theory.

// I am working on birational geometry and complex geometry, mainly focusing on K-stability. I am also interested in geometric shapes encoded by combinatorics, especially toric and spherical varieties.

= Education

#let edu(institution: "", date: "", degrees: (), location: "", extra: "") = {
  pad(
    bottom: -0em,
    grid(
      columns: (auto, 1fr),
      align(left)[
        #strong[#institution] \
        #for degree in degrees [ #emph[#degree] \ ]
        #if extra != "" [ #extra ]
      ],
      align(right)[#emph[
        #if location != "" [ #location ] \ #if date != "" [ #date ] 
      ]],
    ),
  )
}

#let time(y1, m1, y2, m2) = (
  datetime(year: y1, month: m1, day: 01).display("[month repr:short] [year]")
    + [ -- ]
    + datetime(year: y2, month: m2, day: 01).display("[month repr:short] [year]")
)

#edu(
  institution: [University of Nottingham],
  location: [Nottingham, United Kingdom],
  degrees: (
    [(Expected) PhD in Pure Mathematics],
  ),
  date: time(2024, 02, 2027, 06),
  extra: [Advisors: Hamid Abban and Johannes Hofscheier],
)

#edu(
  institution: [Imperial College London],
  location: [London, United Kingdom],
  degrees: (
    [MSc in Pure Mathematics],
  ),
  date: time(2021, 10, 2022, 10),
  extra: [Supervisor: Jonathan Lai],
)

#edu(
  institution: [The Chinese University of Hong Kong, Shenzhen],
  location: [Shenzhen, China],
  degrees: (
    [BSc in Mathematics and Applied Mathematics],
  ),
  date: time(2017, 09, 2021, 05),
)

// = Employment
// #exp()

= Publications / Preprints

#show bibliography: none
#bibliography(works, style: "apa")
#render-pdf-bib(yaml(works))

= Visits
- Visited Antonio Trusiani (Apr 2026) at "#emph[Università degli Studi di Roma Tor Vergata (UniRoma2)]", Italy, for one month.

= Invited Presentations
#render-talks(yaml(talks))

= Teaching at University of Nottingham
- Core Mathematics (Full Year 2024--25) --- Demonstration (Teaching Assistant).
- Real Analysis (Spring 2024--25) --- Marking.
- Real Analysis (Autumn 2025--26) --- Marking.

= Service and Outreach
- Co-organized a small study group on non-Archimdean geometry at Nottingham (May 2025 -- March 2026).
- Referee for EpiGA and reviewer for zbMATH.
- Writing mathematical popularization articles on a WeChat public account (a Chinese social media platform) in Chinese, currently 4500+ subscribers.

== Languages and IT Skills
- Chinese (native), English (fluent), French and Italian (learning).
- Proficient in LaTeX, Typst, Rust, Python, and Java.