#import "lib/nav.typ": nav-bar
#import "lib/bib.typ": render-web-bib, other-authors, my-cite
#import "lib/tools.typ": aclinks, r, avatar, overlay, checkbox, render-talks, render-people

#let name = "Zheng, Renpeng"
#let talks-data = yaml("res/talks.yml")
#let works-data = yaml("res/works.yml")
#let people-data = yaml("res/people.yml")
#set document(title: name)

#show bibliography: none
#bibliography("res/works.yml", style: "apa")
#show cite: it => my-cite(works-data, str(it.key))

#let main() = {
  html.main([
    #html.header(class: "intro", {
      html.div(class: "intro-words", {
        par[PhD Student]
        par[University of Nottingham]
        par[Renpeng.Zheng \<at\> Nottingham.ac.uk]
        par[Supervised by Hamid Abban and Johannes Hofscheier]
        aclinks()
      })
      r[郑|仁|鹏][zhèng|rén|péng]
      avatar()
    })

    // Show people (e.g., coauthors) as <a>
    #let pattern = regex(people-data.keys().sorted(key: k => k.len()).rev().join("|"))
    #show pattern: it => {
      let details = people-data.at(it.text)
      let display-name = if details.name.is_cjk { smallcaps(details.name.family) + " " + details.name.given } else {details.name.given + " " + smallcaps(details.name.family)}
      // html.a(class: "tooltip-link", href: details.url, display-name)
      html.elem("a", attrs: (href: details.url, class: "tooltip-link", tooltip-target: "#" + it.text.replace(" ", "") + "-tooltip-content"), display-name)
    }

    I am working on birational and complex algebraic geometry, mainly focusing on K-stability. I am also interested in geometric shapes encoded by combinatorics, especially toric and spherical varieties. 

    My newest paper is @sphcomp, where we find a special ℚ-divisor of a polarised spherical variety.

    #html.section(id: "education", [ = Education
      - 2027: (Expected) PhD in Pure Mathematics (supervised by Hamid Abban and Johannes Hofscheier), #strong[University of Nottingham], UK
      - 2022: MSc in Pure Mathematics (supervised by Jonathan Lai), #strong[Imperial College London], UK
      - 2021: BSc in Mathematics and Applied Mathematics, #strong[the Chinese University of Hong Kong], Shenzhen, China
    ])
    
    #html.div(id: "calendar-container", class: "no-print", [])

    #html.section(id: "research", [ = Research
      #html.header(class: "heading-toggle", [ 
        == Publications / Preprints
        #checkbox("abstracts", [Abstracts])
      ])
        #render-web-bib(works-data, "abstracts-toggle")

      == Academic Visits
        - Visit Antonio Trusiani (Apr 2026) at "#emph[Università degli Studi di Roma Tor Vergata (UniRoma2)]", Italy, for one month. // working on [JTZ].
        
      == Invited Presentations
        #render-talks(talks-data)
    ])

    #html.div(class: "no-print", [ == Posters / Interactive Media
        #html.div(id: "poster-container", class: "no-print", [])
      ])
    
    #html.section(id: "teaching", [ = Teaching
      == University of Nottingham (Teaching Affiliate & Demonstrator)
      === 2024-2025
        - MATH1101 Core Mathematics (Full Year UK) --- Demonstration.
        - MATH2102 Real Analysis (Spring UK) --- Marking.
      === 2025-2026
        - MATH2102 Real Analysis (Autumn UK) --- Marking.
    ])
    
    // #html.section(id: "activities", [ = Activities
    //   - TODO
    // ])
  ])
}

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
      "/assets/main.css",
      "/assets/nav.css",
      "/assets/tooltips.css",
      "/assets/bib.css",
      "/assets/google.css",
    )
    html.link(rel: "stylesheet", href: "/assets/print.css", media: "print")
    add_js_mod(
      "/assets/cite.js", 
      "/assets/components/nav.js",
      "/assets/components/bib.js",
    )
  })
}

#let footer() = html.footer(class: "no-print",
  [© 2025-#datetime.today().year() 郑仁鹏]
)

// ---------------------------------------------------
// main:
#html.html(lang: "en", [
  #head()
  #html.body({
    overlay("menu")
    nav-bar(name)

    main()

    footer()
    html.script(src: "/assets/init.js")
    render-people(people-data, works-data)
  })
])