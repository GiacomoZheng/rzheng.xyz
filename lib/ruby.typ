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