// tools
#let nav-link(href, text) = {
  html.elem("a", attrs: (href: href, class: "nav-link", data-text: text), [])
}

// 定义导航项枚举
#let HOME = (name: "Home", url: "#")
#let Nav = (
  PUBS: (name: "Research", url: "#research"),
  TEAC: (name: "Teaching", url: "#teaching"),
)
#let icon = {
  html.span(id: "menu-icon", [
    #html.span(class: "line")#html.span(class: "line")#html.span(class: "bottom-lines", [#html.span(class: "line", id: "bottom-l-line")#html.span(class: "line", id: "bottom-r-line")])
  ])
}

#let nav-bar(name) = {
  html.nav(html.div(id: "nav-content", [
    #html.div(id: "nav-logo", strong(name))
    #html.div(id: "nav-right", [
      // 2. Home 链接，现在用 div 包裹，并指向 #
      #html.div(class: "nav-home-wrapper", 
        nav-link(HOME.url, HOME.name)
      )
      
      #html.elem("label", attrs: ("for": "menu-toggle", class: "menu-toggle-label"), icon)
      
      // 4. 可折叠的菜单列表
      #html.div(id: "nav-menu", [
        #for (_, item) in Nav {
          nav-link(item.url, item.name)
        }
      ])
    ])
  ]))
}
