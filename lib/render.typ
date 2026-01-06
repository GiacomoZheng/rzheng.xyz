#let is-html = sys.inputs.at("target", default: "") == "html"

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
  if a.contains(",") { a.split(",").at(0).trim() } else { a.split(" ").last() }
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

// --- 链接包装函数
#let universal-link(url, body) = {
  // 检测是否正在导出为 HTML
  if is-html {
    html.a(href: url, target: "_blank", body)
  } else {
    // PDF 导出时使用标准链接（PDF 默认就会在新窗口打开链接，所以不需要 target）
    link(url, body)
  }
}

// --- 辅助函数 3：构造内容区 (处理期刊/arXiv等) ---
#let create-bib-content(details) = {
  let author-str = format-authors(details.author)

  [
    #author-str.
    “#details.title.”
    #if "parent" in details {
      [In: ] + emph(details.parent.title) + [ ]
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
      universal-link("https://arxiv.org/abs/" + eprint, eprint)
      if "primary-class" in details { [ [#details.primary-class].] } else { [.] }
    }
  ]
}

// --- 主渲染函数 ---
#let render-bib(refs) = {
  // ! 重写为一个巨大的表
  for (key, details) in refs {
    // 内部调用逻辑
    let final-label = generate-label(key, details.author, details.date)
    let bib-content = create-bib-content(details)

    if is-html {
      html.div(class: "bib-entry", id: key, [
        #html.span(class: "bib-label", final-label)#html.div(class: "bib-content", bib-content)
      ])
    } else {
      grid(
        columns: (90pt, 1fr),
        // 自动适应 label 长度
        column-gutter: 15pt,
        // 之前错误的参数是 column-gap
        row-gutter: 8pt,
        // 条目内部的行间距（如果有换行）
        strong(final-label), text(hyphenate: true, bib-content),
      )
    }
  }
}

#let my-cite(refs, key) = {
  if key in refs {
    let details = refs.at(key)
    let label = generate-label(key, details.author, details.date)

    let preview-authors = {
      let authors = if type(details.author) == array { details.author } else { (details.author,) }
      
      if authors.len() <= 3 {
        // 情况 1：1-3 个作者，全部列出姓氏，用逗号分隔
        authors.map(get-last-name).join(", ")
      } else {
        // 情况 2：超过 3 个作者，列出前三个姓氏 + et al.
        authors.slice(0, 3).map(get-last-name).join(", ") + " et al."
      }
    }

    // 构造悬浮窗内部内容
    let tooltip-inner = [
      #strong(preview-authors) (#details.date)\
      #emph(details.title)
    ]

    html.a(
      href: "#" + key,
      class: "citation-link",
      [
        #label
        #html.span(
          class: "cite-tooltip  no-print",
          tooltip-inner,
        )
      ]
    )
  } else {
    html.elem("span", attrs: (style: "color: red;"), "[" + key + "?]")
  }
}
