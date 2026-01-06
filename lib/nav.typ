// 定义导航项枚举
#let HOME = (name: [Home], url: "/index.html#", type: "anchor")
#let Nav = (
  PUBS: (name: [Research], url: "/index.html#research", type: "anchor"),
  TEAC: (name: [Teaching],     url: "/index.html#teaching",     type: "anchor"),
  CV:   (name: [CV],           url: "/cv.html",                 type: "external"), 
)

#let nav-bar(name) = {
  html.nav(class: "navbar-container", [
    #html.div(class: "navbar-content", [
      
      // 左侧姓名 (纯文本)
      #html.div(class: "navbar-logo", [#strong(name)])
      // 右侧组合容器
      #html.div(id: "navbar-right", [
        // 2. Home 链接，现在用 div 包裹，并指向 index.html
        #html.div(class: "nav-home-wrapper", [
          #html.elem("a", attrs: (
              href: HOME.url,
              "data-type": HOME.type, // 将具体类型传给 JS
              target: "_self" ,
              rel: "",
              class: "navbar-link"
            ), HOME.name)
        ])

        // 3. 手机端开关 (Checkbox Hack)
        #html.input(type: "checkbox", id: "navbar-toggle", class: "navbar-toggle")
        #html.elem("label", attrs: ("for": "navbar-toggle", class: "navbar-toggle-label"), [#html.span[]])

        // 4. 可折叠的菜单列表
        #html.div(class: "navbar-menu", [
          #for (_, item) in Nav {
            let t = item.at("type", default: "anchor");
            let is-new-tab = (t == "external")
            html.elem("a", attrs: (
              href: item.url,
              "data-type": t, // 将具体类型传给 JS
              target: if is-new-tab { "_blank" } else { "_self" },
              rel: if is-new-tab { "noopener noreferrer" } else { "" },
              class: "navbar-link"
            ), item.name)
          }
        ])
      ])
    ])
  ])
}
