#import "lib/nav.typ": nav-bar
#import "lib/bib.typ": render-web-bib, my-cite
#import "lib/tools.typ": r, overlay, checkbox, render-talks, aclinks

#let name = "Zheng, Renpeng"
#let works = "res/works.yml"
#let talks = "res/talks.yml"
#set document(title: name)

#show bibliography: none
#bibliography(works, style: "apa")
#show cite: it => my-cite(yaml(works), str(it.key))

#let main-card() = html.div(class: "main-card", [
  #html.div(class: "intro-row", {
    html.div(class: "intro-words", {
      par[PhD Student]
      par[University of Nottingham]
      par[Renpeng.Zheng \<at\> Nottingham.ac.uk]
      par[Supervised by Hamid Abban and Johannes Hofscheier]
      aclinks()
    })
    html.div(class: "intro-ruby", r[郑|仁|鹏][zhèng|rén|péng])
    html.div(class: "avatar-frame", html.img(src: "assets/avatar.webp"))
  })

  I am working on birational and complex algebraic geometry, mainly focusing on K-stability. I am also interested in geometric shapes encoded by combinatorics, especially toric and spherical varieties. 

  My newest paper is @sphcomp, where we find a special ℚ-divisor of a polarised spherical variety.

  #html.div(id: "education", [ = Education
    - 2027: (Expected) PhD in Pure Mathematics (supervised by Hamid Abban and Johannes Hofscheier), University of Nottingham, UK
    - 2022: MSc in Pure Mathematics (supervised by Jonathan Lai), Imperial College London, UK
    - 2021: BSc in Mathematics and Applied Mathematics, The Chinese University of Hong Kong, Shenzhen, China
  ])
  
  #html.div(id: "calendar-container", class: "no-print", [])

  #html.div(id: "research", [ = Research
    #html.div(class: "header-toggle", [ == Publications / Preprints
      #checkbox("abstracts", [Abstracts])
    ])
      #render-web-bib(yaml(works), "abstracts-toggle")
    == Talks in Conferences / Seminars
      #render-talks(yaml(talks))
    #html.div(class: "no-print", [ == Posters / Interactive Media
      #html.div(id: "poster-container", class: "no-print", [])
    ])
  ])
  
  #html.div(id: "teaching", [ = Teaching and Marking
    == University of Nottingham (Teaching Affiliate & Demonstrator)
    === 2024-2025
      - MATH1101 Core Mathematics (Full Year UK) --- Demonstration.
      - MATH2102 Real Analysis (Spring UK) --- Marking.
    === 2025-2026
      - MATH2102 Real Analysis (Autumn UK) --- Marking.
  ])
])


#let add_css(..hrefs) = hrefs.pos().map(h => html.link(rel: "stylesheet", href: h)).join()
#let add_js_mod(..srcs) = srcs.pos().map(s => html.script(src: s, type: "module")).join()
#let head() = {
  html.head({
    html.meta(charset: "utf-8")
    html.meta(name: "viewport", content: "width=device-width, initial-scale=1, viewport-fit=cover")
    html.title(name)
    html.link(rel: "canonical", href: "https://rzheng.xyz/")
		html.meta(name: "color-scheme", content: "light dark")
		html.meta(name: "theme-color", content: "#ffffff", media: "(prefers-color-scheme: light)")
		html.meta(name: "theme-color", content: "#1a1a1a", media: "(prefers-color-scheme: dark)")

    // + rewrite
		html.elem("link", attrs: (rel: "icon", type: "image/png", href: "/favicon-96x96.png", sizes: "96x96"))
		html.elem("link", attrs: (rel: "icon", type: "image/svg+xml", href: "/favicon.svg"))
		html.elem("link", attrs: (rel: "shortcut icon", href: "/favicon.ico"))
		html.elem("link", attrs: (rel: "manifest", href: "/site.webmanifest"))
		html.elem("link", attrs: (rel: "apple-touch-icon", sizes: "180x180", href: "/apple-touch-icon.png"))
    // there is some bug on `sizes`.

		html.meta(name: "apple-mobile-web-app-title", content: "R. Zheng")
		html.meta(name: "apple-mobile-web-app-capable", content: "yes")
		html.meta(name: "apple-mobile-web-app-status-bar-style", content: "black-translucent")

		html.meta(name: "description", content: "I am a PhD student at Nottingham, working on algebraic geometry")

    add_css(
      "/assets/style.css",
      "/assets/aclinks.css",
      "/assets/maincard.css",
      "/assets/nav.css",
      "/assets/cite.css",
      "/assets/bib.css",
      "/assets/google.css",
      "/assets/print.css",
    )
    add_js_mod(
      "/assets/cite.js", 
      "/assets/nav.js",
      "/assets/bib.js",
    )
  })
}

#let footer() = html.footer[
  © 2025-#datetime.today().year() 郑仁鹏
]

// ---------------------------------------------------
// main:
#html.html(lang: "en", [
  #head()
  #html.body({
    overlay("menu")
    nav-bar(name)

    // overlay("tooltip")
    main-card()

    footer()
    html.script(src: "/assets/google.js")
  })
])