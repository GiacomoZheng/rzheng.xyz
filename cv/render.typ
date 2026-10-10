
#let to-list = authors => if type(authors) == array { authors } else { (authors,) }

// ============================================
// --- bib ---
#let other-authors(authors, exclude: "Renpeng Zheng") = {
  let authors = to-list(authors).filter(name => not name == exclude)

  if authors.len() == 0 {
    [] // 如果全被过滤了，返回空
  } else if authors.len() == 1 {
    authors.at(0)
  } else {
    authors.slice(0, -1).join(", ") + ", and " + authors.last()
  }
}

#let create-pdf-bib-content(details) = [
  #emph(details.title) (#if "date" in details {
    details.date
  } else {
    [in preparation]
  })#{
    let other-authors-str = other-authors(details.author)
    if not other-authors-str == [] {
      [, with #other-authors-str]
    }
    if "journal" in details {
      [, at #strong(details.journal)]
      if "doi" in details {
        [, DOI: #details.doi]
      } else {
        [ (to appear)]
      }
    } else if "arxiv" in details {
      [, arXiv:#details.arxiv]
    }
    [. \ ]

  }
]

#let render-pdf-bib(refs) = {
  grid(
    columns: (auto, 1fr),
    column-gutter: 15pt,
    row-gutter: 8pt,
    align: top,
    ..refs.pairs().map(((key, details)) => {
      // 1. 计算逻辑
      // let final-label = 
      let bib-content = create-pdf-bib-content(details)

      // 2. 返回渲染内容
      (strong([[#details.label]]), text(hyphenate: true, bib-content))
    }).flatten()
  )
}

// ============================================
// --- talks ---
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
    - "#emph(details.title)" (#parse-date(details.date)), #strong(details.event), #(details.institution), #{details.location}.
  ]}
}