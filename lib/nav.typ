// 定义导航项枚举
#let HOME = (name: [Home], url: "/index.html#")
#let Nav = (
  PUBS: (name: [Research], url: "/index.html#research"),
  TEAC: (name: [Teaching], url: "/index.html#teaching"),
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
      // 2. Home 链接，现在用 div 包裹，并指向 index.html
      #html.div(class: "nav-home-wrapper", 
        html.a(href: HOME.url , class: "nav-link", HOME.name)
      )
      
      #html.elem("label", attrs: ("for": "menu-toggle", class: "menu-toggle-label"), icon)
      
      // 4. 可折叠的菜单列表
      #html.div(class: "nav-menu", [
        #for (_, item) in Nav {
          html.a(href: item.url, class: "nav-link", item.name)
        }
      ])
    ])
  ]))
}
