#import "tools.typ": minify-css, to-list

// --- 格式化作者姓名 ---
#let other-authors(authors, exclude: "Renpeng Zheng") = {
  let authors = to-list(authors)

  if authors.len() == 0 {
    [] // 如果全被过滤了，返回空
  } else if authors.len() == 1 {
    authors.at(0)
  } else {
    authors.slice(0, -1).join(", ") + ", and " + authors.last()
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
      let yymm = int(float(details.arxiv))
      [, #link("https://arxiv.org/abs/" + details.arxiv, [arXiv:#yymm])]
    }
    if "bib" in details {
      [, #box(html.button(popovertarget: key + "-bib-dialog", [bib]))]
    }
    [. \ ]
    if "abstract" in details {
      html.details(name: key, open: false, class: "abstract-details", {
        html.summary(smallcaps([Abstract]))
        // + try to simply it
        // 等interpolate-size: allow-keywords;吧
        html.div(class: "details-wrapper",
          par(details.abstract)
        )
      })
    }
    if "bib" in details {
      html.dialog(class: "bib-dialog", id: key + "-bib-dialog", popover: auto, tabindex: -1, autofocus: true, {
        html.button([Copy to clipboard])
        html.pre(raw(lang: "bibtex", details.bib))
      })
    }
  }
]

#let get-last-name(a) = {
  if a.contains(",") { a.split(",").at(0).trim() } else { a.split(" ").last() }
}

#let create-tooltip-content(details) = [
    #let preview-authors = {
      let authors = to-list(details.author)
      if authors.len() <= 3 {
        // 情况 1：1-3 个作者，全部列出姓氏，用逗号分隔
        authors.map(get-last-name).join(", ")
      } else {
        // 情况 2：超过 3 个作者，列出前三个姓氏 + et al.
        authors.slice(0, 3).map(get-last-name).join(", ") + " et al."
      }
    }

    #par[#strong(preview-authors) (#details.date)]
    #par[#emph(details.title)]
  ]


#let render-web-bib(refs, toggle-id) = {
  // ! 重写为一个巨大的表
  // 感觉似乎不大可能，毕竟我需要兼顾手机端
  // html.div(class: "bib-list", {
  html.elem("bib-list", attrs: ("toggle-id": toggle-id), {
    for (key, details) in refs.pairs().sorted(key: it => -float(it.at(1).arxiv)) {
      html.div(class: "bib-entry", id: key, [
        #html.span(class: "bib-label", [ [#details.label] ])#html.div(class: "bib-content", create-web-bib-content(key, details))#html.div(class: "tooltip-content hidden", create-tooltip-content(details))
      ])
    }
  })
}
// ============================================


#let my-cite(refs, keys) = {
  let keys = if type(keys) == str { (keys,) } else { keys }
  for key in keys {
    if key in refs {
      let details = refs.at(key)

      html.elem("a", attrs: (href: "#" + key, class: "tooltip-link", tooltip-target: "#" + key + " .tooltip-content"), [ [#details.label] ])
      // ! 目前typst编译的html.elem会被识别成块，强行切断<p>
      // html.elem("tooltip-link", attrs: ("href": "#" + key), [ [#details.label] ])
      
    } else {
      html.span(style: "color: red;", "[" + key + "?]")
    }
  }
}
