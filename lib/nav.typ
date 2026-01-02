// 1. 定义导航项枚举
#let HOME = (name: [Home], url: "#")
#let Nav = (
  PUBS: (name: [Publications], url: "#publications"),
  TEACHING: (name: [Teaching], url: "#teaching"),
  CV: (name: [CV], url: "/cv.html"),
)

#let nav-bar(name, current: HOME.name) = {
  html.nav(class: "navbar-container", [
    #html.div(class: "navbar-content", [
      
      // 1. 左侧姓名 (纯文本)
      #html.div(class: "navbar-logo", [#strong(name)])
      
      // 右侧组合容器
      #html.div(class: "navbar-right", [
        
        // 2. Home 链接，现在用 div 包裹，并指向 index.html
        #html.div(class: "nav-home-wrapper", [
          // #link("/index.html" + HOME.url, HOME.name)
          #html.a(href: "/index.html" + HOME.url, class: "active", HOME.name)
        ])

        // 3. 手机端开关 (Checkbox Hack)
        #html.input(type: "checkbox", id: "nav-toggle", class: "nav-toggle")
        #html.elem("label", attrs: ("for": "nav-toggle", class: "nav-toggle-label"), [
          #html.span[] 
        ])
        
        // 4. 可折叠的菜单列表
        #html.div(class: "navbar-menu", [
          #for (_, value) in Nav {
            link("/index.html" + value.url, value.name)
          }
        ])
      ])
    ])
  ])
}
