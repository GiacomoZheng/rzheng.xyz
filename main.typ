// .. { "export": "output/index.html", "features": ["html"] }
#html.script(
  src: "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js",
  async: true
)
// 强制让公式以 MathML 形式输出并包裹在 div 中
#let math(it) = html.span[\\\( #it \\\)]
#let equation(it) = html.div(class: "mathml-eq", [\\\[ #it \\\]])

// -----------------------------------------
#import "lib/render.typ": render-bib, my-cite
#import "lib/nav.typ": nav-bar
#import "lib/ruby.typ": r

#let name = "Zheng, Renpeng"
#let works = "res/works.yml"
#set document(title: name)

#show bibliography: none
#bibliography(works, style: "apa")
#show cite: it => my-cite(yaml(works), str(it.key))

#let add_css(href) = html.link(rel: "stylesheet", href: href)
#let add_js_mod(src) = html.script(src: src, type: "module")

// 外部样式
#add_css("/assets/style.css")
#add_css("/assets/nav.css")
#add_css("/assets/cite.css")
#add_css("/assets/bib.css")
#add_css("/assets/calendar.css")
#add_css("/assets/print.css")
#add_js_mod("/assets/cite.js")
#add_js_mod("/assets/active.js")
#add_js_mod("/assets/global-clicks.js")
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
      #html.img(src: "assets/avatar.png")
    ])
  ])

  I am working on birational and complex algebraic geometry, mainly focusing on K-stability. I am also interested in geometric shapes encoded by combinatorics, especially toric and spherical varieties. 

  My newest preprint is @KQSVCD, where we find a special ℚ-divisor of a polarised spherical variety.

  = Education
    - 2027: (Expected) PhD in Pure Mathematics (supervised by Hamid Abban and Johannes Hofscheier), University of Nottingham, UK
    - 2022: MSc in Pure Mathematics (supervised by Jonathan Lai), Imperial College London, UK
    - 2021: BSc in Mathematics and Applied Mathematics, the Chinese University of Hong Kong, Shenzhen, China
  
  #html.div(id: "calendar-container", class: "no-print", [])
  #html.script(src: "/assets/calendar.js")

  #html.div(id: "research", [
    = Research
    == Publications / Preprints
      #render-bib(yaml(works))
    // == Selected Talks
  ])
  
  #html.div(id: "teaching", [
    = Teaching and Marking
    == University of Nottingham (Teaching Affiliate and Demonstrator)
    === 2024-2025
      - MATH1101 Core Mathematics (Full Year UK) - Demonstration
      - MATH2102 Real Analysis (Spring UK) - Marking
    === 2025-2026
      - MATH2102 Real Analysis (Autumn UK) - Marking
  ])

])
