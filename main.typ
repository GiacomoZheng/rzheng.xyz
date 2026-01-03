// .. { "export": "output/index.html", "features": ["html"] }
#html.script(
  src: "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js",
  async: true
)
// 强制让公式以 MathML 形式输出并包裹在 div 中
#let math(it) = html.span[\\\( #it \\\)]
#let equation(it) = html.div(class: "mathml-eq", [\\\[ #it \\\]])

// ------------------------------------------------------------
#import "lib/render.typ": render-bib, my-cite
#import "lib/nav.typ": nav-bar
#import "lib/ruby.typ": r

#let name = "Zheng, Renpeng"
#let works = "res/works.yml"
#set document(title: name)

#show bibliography: none
#bibliography(works, style: "apa")
#show cite: it => my-cite(yaml(works), str(it.key))

// 注入外部样式
#html.link(rel: "stylesheet", href: "/assets/style.css")
#html.link(rel: "stylesheet", href: "/assets/nav.css")
#html.link(rel: "stylesheet", href: "/assets/cite.css")
#html.link(rel: "stylesheet", href: "/assets/bib.css")
#html.link(rel: "stylesheet", href: "/assets/calendar.css")
#html.script(src: "/assets/cite.js")
#html.script(src: "/assets/nav.js")
// #html.link(rel: "icon", type: "image/svg+xml", href: "/assets/favicon.svg") // 改成用脚本注入了

// main
#html.div(class: "main-card", [
	#nav-bar(name)
  #html.div(class: "intro-row", [
    #html.div(class: "intro-words", [
      #html.p[PhD Student]
      #html.p[University of Nottingham]
      #html.p[Renpeng.Zheng \<at\> Nottingham.ac.uk]
      #html.p[Supervised by Hamid Abban and Johannes Hofscheier]
    ])
    #html.div(class: "intro-ruby", [
      #r[郑|仁|鹏][zhèng|rén|péng]
    ])
		#html.div(class: "avatar-frame", [
      #image("res/avatar.png")
    ])
  ])

  #html.div([
    I am working on birational and complex algebraic geometry, mainly focusing on K-stability. I am also interested in geometric shapes encoded by combinatorics, especially toric and spherical varieties. 
  ])

  #html.div([
    = Education
    #block[
      - 2027: (Expected) PhD in Pure Mathematics (supervised by Hamid Abban and Johannes Hofscheier), University of Nottingham, UK
      - 2022: MSc in Pure Mathematics (supervised by Jonathan Lai), Imperial College London, UK
      - 2021: BSc in Mathematics and Applied Mathematics, the Chinese University of Hong Kong, Shenzhen, China
    ]
  ])
  
  // #html.div(class: "calendar-container", [
  //   #html.elem("iframe", 
  //     attrs: (
  //       src: "https://calendar.google.com/calendar/embed?height=600&wkst=1&ctz=Europe%2FLondon&src=cmVucGVuZy56aGVuZy5hY0BnbWFpbC5jb20&color=%23039be5&showTitle=0&showPrint=0&showTabs=1&showCalendars=0&showNav=1&showDate=1&mode=AGENDA",
  //       class: "google-calendar",
  //       frameborder: "0",
  //       scrolling: "no"
  //     ), []
  //   )
  // ])

  #html.div(id: "publications", [
    = Publications / Preprints
    #render-bib(yaml(works))
  ])
  
  #html.div(id: "teaching", [
    = Teaching and Marking
    === University of Nottingham (Teaching Affiliate and Demonstrator)
    #block[
      - 2024-2025 \
        #block[
          - MATH1101 Core Mathematics (Full Year UK) - Demonstration
          - MATH2102 Real Analysis (Spring UK) - Marking
        ]
      - 2025-2026 \
        #block[
          - MATH2102 Real Analysis (Autumn UK) - Marking
        ]
    ]
  ])
])