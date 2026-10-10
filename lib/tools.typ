

// into list
#let to-list = authors => if type(authors) == array { authors } else { (authors,) }

// inline css
#let minify-css(css-code) = {
  css-code.replace(regex("(?s)/\*.*?\*/"), "") // 1. 清除 /* 注释 */
    .replace(regex("\s+"), " ")          // 2. 多个换行/空格合并为一个空格
    .replace(regex("\s*([{}:;,])\s*"), m => m.captures.at(0)) // 3. 清除符号 ( { } : ; , ) 两边的空格
    .trim()
}

// ruby
#let r(base-content, annot-content) = {
  let bases = base-content.text.split("|")
  let annots = annot-content.text.split("|")
  let pairs = bases.zip(annots)
  
  html.div({ // 需要包起来
    html.style(minify-css(read("/res/css/ruby.css")))
    for (b, a) in pairs {
      html.ruby[
        #b#html.rp[（]
        #html.rt(a)
        #html.rp[）]
      ]
    }
  })
}

// avatar
#let avatar() = {
  html.style(minify-css(read("/res/css/avatar.css")))
  html.div(class: "avatar-frame", html.img(src: "/assets/avatar.webp"))
}

// checkbox hack
#let overlay(name) = {
  html.input(type: "checkbox", id: name + "-toggle", class: "overlay-toggle hidden")
  html.elem("label", attrs: ("for": name + "-toggle", id: name + "-overlay", class: "overlay"), html.span())

}

// normal checkbox
#let checkbox(name, label) = {
  html.div(class: "checkbox-container no-print",[
    #html.elem("label", attrs: ("for": name + "-toggle", id: name + "-toggle-label"), label)
    #html.input(type: "checkbox", id: name + "-toggle")
  ])
}

// talks
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
#let render-talks(talks) = {
  for (_, details) in talks.pairs().sorted(key: it => it.at(1).date).rev() {[
    - "#emph(details.title)" (#parse-date(details.date)), #strong(details.event), #(details.institution), #{details.location}. #if details.refs != none [On #cite(label(..details.refs)).]
  ]}
}

// people
#let render-people(people, refs) = {
  for (full-name, details) in people.pairs() {
    let key = full-name.replace(" ", "")
    html.div(id: key + "-tooltip-content", class: "hidden", [
      #par(strong(full-name))
      #let keys = refs.pairs().filter(((_, work)) => {full-name in to-list(work.author)}).map(((k, _)) => k)
      #let count = keys.len()
      #par(if count == 0 [
        No cooperation yet.
      ] else [
        #count collaboration#if count > 1 [s].
      ])
    ])
  }
}

// academic-links
#let aclinks() = {
  html.div(class: "academic-links", {
      // html.i(class: "ai ai-google-scholar-square")
      link("https://arxiv.org/a/zheng_r_3.html", html.div(class: "ai my-arxiv-square", html.img(id: "arxiv-logo", class: "square", src: "assets/aclinks/arxiv.svg")))
      link("https://cv.hal.science/zheng-renpeng", html.i(class: "ai ai-hal-square", html.span(id: "hal-bg", class: "square")))
      link("https://orcid.org/0009-0005-0309-8458", html.i(class: "ai ai-orcid-square"))
      link("https://zbmath.org/authors/zheng.renpeng", html.div(class: "ai my-zbmath-square", html.img(id: "zbmath-logo", class: "square", src: "assets/aclinks/zbmath.svg")))
      // link("", html.i(class: "fa fa-github-square", style: "color: #24292E;"))
  })
}