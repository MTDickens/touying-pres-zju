# touying-pres-zju 浙江大学 touying 演示模板

Zhejiang University presentation theme for Touying.

```typ
#import "theme.typ": *

#let s = register(aspect-ratio: "16-9")
#let s = (s.methods.numbering)(self: s, section: "1.", "1.1")
#let s = (s.methods.info)(
  self: s,
  title: [Typst template for Zhejiang University],
  subtitle: [Continuously Improving...],
  author: [MTDickens],
  date: datetime.today(),
  institution: [School of Computer Science and Technology, ZJU],
  logo: image("../../assets/img/zju_logo_side.svg", width: 50%),
  head-logo: image("../../assets/img/zju_logo_side.svg",width: 20%),
  github: ""
)
#let s = (s.methods.colors)(
  self: s, 
  primary: rgb("#004098"), 
  secondary: rgb("#004098")
)

#let (init, slides) = utils.methods(s)
#let (slide, empty-slide, title-slide, outline-slide, new-section-slide, ending-slide, focus-slide,matrix-slide) = utils.slides(s)

#show: codly-init.with()
#show: init
#show: slides.with()

#outline-slide()

= 第一章：样式

== 想分列显示？
```

## 省流版

`content/example/main.typ`是渲染的入口

## Change log

### 0.2.0 (2024-12-03)

- 修改文件组织结构
- 添加接口便于更换资源文件
