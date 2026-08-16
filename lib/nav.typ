#import "tools.typ": minify-css

// 定义导航项枚举
#let HOME = (name: "Home", url: "#")
#let Nav = (
  PUBS: (name: "Research", url: "#research"),
  TEAC: (name: "Teaching", url: "#teaching"),
)

#let nav-link(id: "", href, text) = {
  html.elem("a", attrs: (id: id, href: href, class: "nav-link", data-text: text), [])
}
#let icon = {
  html.style(
    media: "screen and (max-width: 768px)",
    minify-css(read("nav/menu-icon.css"))
  )
  html.div(id: "menu-icon", {
    html.span(class: "line")
    html.span(class: "line")
    html.span(class: "line")
    html.span(class: "line")
  })
}

// main function
#let nav-bar(name) = {
  html.elem("dyn-bar", html.nav({
    html.div(id: "nav-logo", strong(name))
    html.elem("active-links", attrs: (id: "nav-right"), {
      nav-link(id: "nav-home", HOME.url, HOME.name)
      
      html.elem("label", attrs: ("for": "menu-toggle", class: "menu-toggle-label"), icon)
      html.div(id: "nav-menu", [ // 移动端可折叠的菜单列表
        #for (_, item) in Nav { nav-link(id: "nav-" + item.name, item.url, item.name) }
      ])
    })
  }))
}
