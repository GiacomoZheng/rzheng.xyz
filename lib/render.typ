// --- 辅助函数 1：格式化作者姓名 ---
#let format-authors(authors) = {
  let raw-authors = if type(authors) == array { authors } else { (authors,) }
  let processed = raw-authors.map(a => {
    if a.contains(",") {
      let parts = a.split(",").map(it => it.trim())
      parts.at(1) + " " + parts.at(0)
    } else { a }
  })
  
  if processed.len() == 1 {
    processed.at(0)
  } else {
    processed.slice(0, -1).join(", ") + ", and " + processed.last()
  }
}

#let get-last-name(a) = {
    if a.contains(",") { a.split(",").at(0).trim() } 
    else { a.split(" ").last() }
  }

// --- 辅助函数 2：重构 Label 生成逻辑 ---
#let generate-label(key, authors, date) = {
  let raw-authors = if type(authors) == array { authors } else { (authors,) }
  let year-short = str(date).slice(2, 4)
  
  let last-names = raw-authors.map(a => get-last-name(a))

  let label-text = if last-names.len() == 1 {
    last-names.at(0) // 单作者全姓
  } else if last-names.len() <= 5 {
    last-names.map(n => n.at(0)).join("") // 2-5人首字母
  } else {
    last-names.slice(0, 5).map(n => n.at(0)).join("") + "+" // 超过5人加+
  }
  "[" + label-text + year-short + "]"
}

// --- 辅助函数 3：构造内容区 (处理期刊/arXiv等) ---
#let create-bib-content(details) = {
  let author-str = format-authors(details.author)
  
  [
    #author-str. 
    “#details.title.” 
    #if "parent" in details {
      [In: ] + html.em(details.parent.title) + [ ]
      if "volume" in details {
        let vol = str(details.volume)
        if "issue" in details { vol + "." + str(details.issue) } else { vol }
        [ ]
      }
    }
    (#details.date)#if "page-range" in details { [, pp. #details.page-range] }.
    
    #if "serial-number" in details and "arxiv" in details.serial-number {
      let eprint = details.serial-number.arxiv
      [ arXiv: ]
      html.a(href: "https://arxiv.org/abs/" + eprint, target: "_blank", eprint)
      if "primary-class" in details { [ [#details.primary-class].] } else { [.] }
    }
  ]
}

// --- 主渲染函数 ---
#let render-bib(refs) = {
  
  for (key, details) in refs {
    // 内部调用逻辑
    let final-label = generate-label(key, details.author, details.date)
    let bib-content = create-bib-content(details)
    
    html.div(class: "bib-entry", id: key, [
      #html.span(class: "bib-label", final-label)#html.div(class: "bib-content", bib-content)
    ])
  }
}

#let my-cite(refs, key) = {
  if key in refs {
    let details = refs.at(key)
    let label = generate-label(key, details.author, details.date)
    
    let first-author = if type(details.author) == array { details.author.at(0) } else { details.author }
    let preview-author = get-last-name(first-author)
    let et-al = if type(details.author) == array and details.author.len() > 1 { " et al." } else { "" }
    
    // 构造悬浮窗内部内容 (这部分可以用简化语法，因为没有事件)
    let tooltip-inner = (
      html.b(preview-author + et-al),
      " (" + str(details.date) + ")",
      html.br(),
      html.i(details.title)
    ).join()
    
    // 核心：外层容器必须使用 html.elem 配合 attrs
    html.elem("a", attrs: (
      href: "#" + key, 
      class: "citation-link",
      onclick: "handleCiteClick(event, this)" 
    ), (
      label,
      // 内部 span 也必须用 html.elem 才能带上跳转 onclick
      html.elem("span", attrs: (
        class: "cite-tooltip", 
        onclick: "location.hash='" + key + "'; event.stopPropagation();"
      ), tooltip-inner)
    ).join())
  } else {
    html.elem("span", attrs: (style: "color: red;"), "[" + key + "?]")
  }
}