#import "lib/nav.typ": nav-bar
#import "lib/bib.typ": render-web-bib, my-cite
#import "lib/tools.typ": r, overlay, parse-date, aclinks

#let name = "Zheng, Renpeng"
#let works = "res/works.yml"
#let talks = "res/talks.yml"
#set document(title: name)

#show bibliography: none
#bibliography(works, style: "apa")
#show cite: it => my-cite(yaml(works), str(it.key))

// I am still using the inject
#let add_css(..hrefs) = hrefs.pos().map(h => html.link(rel: "stylesheet", href: h)).join()
#let add_js_mod(..srcs) = srcs.pos().map(s => html.script(src: s, type: "module")).join()
#let head() = {
  html.head({
    // html.meta(charset: "utf-8")
    add_css(
      // TODO
    )
    add_js_mod(
      "/assets/cite.js", 
      "/assets/active.js",
      "/assets/nav.js"
    )
  })
}

#let main-card() = html.div(class: "main-card", [
  #html.div(class: "intro-row", [
    #html.div(class: "intro-words", [
      #html.p[PhD Student]
      #html.p[University of Nottingham]
      #html.p[Renpeng.Zheng \<at\> Nottingham.ac.uk]
      #html.p[Supervised by Hamid Abban and Johannes Hofscheier]
      #aclinks()
    ])
    #html.div(class: "intro-ruby", [
      #r[郑|仁|鹏][zhèng|rén|péng]
    ])
		#html.div(class: "avatar-frame", [
      #html.img(src: "assets/avatar.png")
    ])
  ])

  I am working on birational and complex algebraic geometry, mainly focusing on K-stability. I am also interested in geometric shapes encoded by combinatorics, especially toric and spherical varieties. 

  

  My newest paper is @KQSVCD, where we find a special ℚ-divisor of a polarised spherical variety.

  #html.div(id: "education", [ = Education
    - 2027: (Expected) PhD in Pure Mathematics (supervised by Hamid Abban and Johannes Hofscheier), University of Nottingham, UK
    - 2022: MSc in Pure Mathematics (supervised by Jonathan Lai), Imperial College London, UK
    - 2021: BSc in Mathematics and Applied Mathematics, The Chinese University of Hong Kong, Shenzhen, China
  ])
  
  #html.div(id: "calendar-container", class: "no-print", [])
  #html.script(src: "/assets/calendar.js")

  #html.div(id: "research", [ = Research
    == Publications / Preprints
      #render-web-bib(yaml(works))
    == Conferences / Seminars
      #for (_, details) in yaml(talks).pairs().sorted(key: it => it.details.date) {
        [
          - *#parse-date(details.date)*, at #details.event, #emph(details.institution), #{details.location}. Presenting #cite(label(..details.refs)).
        ]
      }
    // == Posters / Interactive Media
  ])
  
  #html.div(id: "teaching", [
    = Teaching and Marking
    == University of Nottingham (Teaching Affiliate and Demonstrator)
    === 2024-2025
      - MATH1101 Core Mathematics (Full Year UK) - Demonstration.
      - MATH2102 Real Analysis (Spring UK) - Marking.
    === 2025-2026
      - MATH2102 Real Analysis (Autumn UK) - Marking.
  ])
])

#let footer() = html.footer[
  © 2025-#datetime.today().year() 郑仁鹏
]


// ---------------------------------------------------
// main:
#{
  overlay("menu")
  nav-bar(name)

  overlay("tooltip")
  main-card()

  footer()
}
// #html.html({
//   head()
//   html.body({
//     overlay("menu")
//     nav-bar(name)

//     overlay("tooltip")
//     main-card()

//     footer()
//   })
// })