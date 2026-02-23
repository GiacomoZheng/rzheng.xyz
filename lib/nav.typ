// 定义导航项枚举
#let HOME = (name: [Home], url: "/index.html#", type: "anchor")
#let Nav = (
  PUBS: (name: [Research], url: "/index.html#research", type: "anchor"),
  TEAC: (name: [Teaching],     url: "/index.html#teaching",     type: "anchor"),
  CV:   (name: [CV],           url: "/cv.html",                 type: "external"), 
)
#let icon = {
  html.span(class: "menu-icon", [
    #html.span(class: "line")#html.span(class: "line")#html.span(class: "bottom-lines", [#html.span(class: "line", id: "bottom-l-line")#html.span(class: "line", id: "bottom-r-line")])
  ])
}

#let nav-bar(name) = {
  html.nav(class: "nav-container", [
    // 手机端开关 (Checkbox Hack)，不可见
    #html.input(type: "checkbox", id: "nav-toggle", class: "nav-toggle hidden")
    // 遮罩层，用于消除收起菜单
    #html.elem("label", attrs: ("for": "nav-toggle", class: "menu-overlay"), html.span())

    #html.div(class: "nav-content glass", [
      #html.div(class: "nav-logo", strong(name))
      #html.div(id: "nav-right", [
        // 2. Home 链接，现在用 div 包裹，并指向 index.html
        #html.div(class: "nav-home-wrapper", [
          #html.elem("a", attrs: (
              href: HOME.url,
              "data-type": HOME.type, // 将具体类型传给 JS
              target: "_self" ,
              rel: "",
              class: "nav-link"
            ), HOME.name)
        ])
        
        #html.elem("label", attrs: ("for": "nav-toggle", class: "nav-toggle-label"), icon)
       
        // 4. 可折叠的菜单列表
        #html.div(class: "nav-menu", [
          #for (_, item) in Nav {
            let t = item.at("type", default: "anchor");
            let is-new-tab = (t == "external")
            html.elem("a", attrs: (
              href: item.url,
              "data-type": t, // 将具体类型传给 JS
              target: if is-new-tab { "_blank" } else { "_self" },
              rel: if is-new-tab { "noopener noreferrer" } else { "" },
              class: "nav-link"
            ), item.name)
          }
        ])
      ])
    ])
  ])
}
