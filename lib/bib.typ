// --- 格式化作者姓名 ---
#let other-authors(authors, exclude: "Renpeng Zheng") = {
  let raw-authors = if type(authors) == array { authors } else { (authors,) }
  let processed = raw-authors.map(a => {
    if a.contains(",") {
      let parts = a.split(",").map(it => it.trim())
      parts.at(1) + " " + parts.at(0)
    } else { a }
  }).filter(name => not name == exclude)

  if processed.len() == 0 {
    [] // 如果全被过滤了，返回空
  } else if processed.len() == 1 {
    processed.at(0)
  } else {
    processed.slice(0, -1).join(", ") + ", and " + processed.last()
  }
}

// ！ 目前typst编译的table还不能处理class，所以先继续使用html.elem
#let create-web-bib-content(key, details) = [
  #emph(details.title) (#details.date)#{
    let other-authors-str = other-authors(details.author)
    if not other-authors-str == [] {
      [, with #other-authors-str]
    }
    if "journal" in details {
      [, at #strong(details.journal)]
      if "doi" in details {
        [, #link("https://doi.org/" + details.doi, [DOI])]
      } else {
        [ (to appear)]
      }
    }
    if "arxiv" in details {
      [, #link("https://arxiv.org/abs/" + details.arxiv, [arXiv])]
    }
    if "bib" in details {
      [, #box(html.button(popovertarget: key + "-bib-dialog", [bib]))]
    }
    [. \ ]
    if "abstract" in details {
      html.details(name: key, open: false, class: "abstract-details", [
        #html.summary(smallcaps([Abstract]))
        #html.div(
          class: "details-wrapper",
          html.div(class: "details-inner", details.abstract)
        )
      ])
    }
    if "bib" in details {
      html.dialog(class: "bib-dialog", id: key + "-bib-dialog", popover: auto, [
        #html.button([Copy to clipboard])
        #html.pre(raw(details.bib))
        // #align(right)[ // maybe future
        
      ])
    }
  }
]

#let render-web-bib(refs) = {
  // ! 重写为一个巨大的表
  // 感觉似乎不大可能，毕竟我需要兼顾手机端
  html.div(class: "bib-list", [
    #for (key, details) in refs.pairs().sorted(key: it => -float(it.at(1).arxiv)) {
      html.div(class: "bib-entry", id: key, [
        #html.span(class: "bib-label", [\[#details.label\]])#html.div(class: "bib-content", create-web-bib-content(key, details))
      ])
    }
  ])
}
// ============================================

#let get-last-name(a) = {
  if a.contains(",") { a.split(",").at(0).trim() } else { a.split(" ").last() }
}

#let my-cite(refs, keys) = {
  let keys = if type(keys) == str { (keys,) } else { keys }
  for key in keys {
    if key in refs {
      let details = refs.at(key)

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

      html.a(href: "#" + key, class: "cite-link", [
        \[#details.label\]
        #html.span(class: "no-print", tooltip-inner)
      ])
      
    } else {
      html.span(style: "color: red;", "[" + key + "?]")
    }
  }
}
