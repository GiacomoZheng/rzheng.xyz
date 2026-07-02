// ruby
#let r(base-content, annot-content) = {
  // 将输入转换为字符串并按 "|" 分割
  let bases = base-content.text.split("|")
  let annots = annot-content.text.split("|")
  
  // 确保两边数量一致，如果不一致则取最小个数，防止报错
  let pairs = bases.zip(annots)
  
  // 遍历每一对，生成 HTML 结构
  for (b, a) in pairs {
    html.ruby[
      #b#html.rp[（]
      #html.rt(a)
      #html.rp[）]
    ]
  }
}


// checkbox hack
#let overlay(name) = {
  html.input(type: "checkbox", id: name + "-toggle", class: "overlay-toggle hidden")
  html.elem("label", attrs: ("for": name + "-toggle", id: name + "-overlay", class: "overlay"), html.span())

}

// normal checkbox
#let checkbox(name, label) = {
  html.div(class: "no-print", style: "display: flex; align-items: center;",[
    #html.elem("label", attrs: ("for": name + "-toggle", id: name + "-toggle-label"), label)
    #html.input(type: "checkbox", id: name + "-toggle")
  ])
}


// date
#let parse-date(yyyy-mm-dd) = {
  // 确保输入是字符串
  let d = str(yyyy-mm-dd)
  
  // 提取各个部分并转换为整数
  let year = int(d.slice(0, 4))
  let month = int(d.slice(5, 7))
  let day = int(d.slice(8, 10))
  
  // 构造并返回标准的 datetime 对象
  datetime(year: year, month: month, day: day).display("[month repr:short] [year]")
}


// academic-links
#let aclinks() = {
  html.div(class: "academic-links", {
      // html.i(class: "ai ai-google-scholar-square")
      link("https://arxiv.org/a/zheng_r_3.html", html.div(class: "ai my-arxiv-square", html.img(id: "arxiv-logo", class: "square", src: "assets/arxiv.svg")))
      link("https://cv.hal.science/zheng-renpeng", html.i(class: "ai ai-hal-square", html.span(id: "hal-bg", class: "square")))
      link("https://orcid.org/0009-0005-0309-8458", html.i(class: "ai ai-orcid-square"))
      link("https://zbmath.org/authors/zheng.renpeng", html.div(class: "ai my-zbmath-square", html.img(id: "zbmath-logo", class: "square", src: "assets/zbmath.svg")))
      // link("", html.i(class: "fa fa-github-square", style: "color: #24292E;"))
  })
}