#import "vendor/touying-pres-zju/theme.typ": *

#let s = register(aspect-ratio: "16-9")
#let s = (s.methods.numbering)(self: s, section: "1.", "1.1")
#let s = (s.methods.info)(
  self: s,
  title: [基于符号化想象空间的大模型"以图思考"推理方法研究],
  // subtitle: [Continuously Improving...],
  author: [简一畅],
  advisor: [丁尧相],
  // date: datetime.today(),
  date: "2026-06-05",
  institution: [计算机科学与技术学院],
  logo: image("./imgs/zju_logo_side.svg", width: 40%),
  head-logo: image("./imgs/zju_logo_side.svg",width: 13%),
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

// 建议总时长：8-10 分钟；正文控制在 12 页左右，每页约 35-50 秒。重点讲“问题—方法—结果—结论”，公式只讲直觉，不展开推导。

= 第一章：绪论

== 研究背景：视觉规划中的感知瓶颈
// 讲 45 秒。内容：从 VLM 在视觉规划中的潜力切入，马上指出核心瓶颈不是规划器不够强，而是复杂原始视觉输入超出 VLM 单步感知能力；再说明 TWI 能把感知拆成局部步骤，但通用 TWI 在规划任务中仍不稳定。
// 图表建议：放一张自制动机图“复杂视觉输入 -> 错误/不完整符号化想象空间 -> 规划失败 -> 局部揭示修正”，也可以裁剪论文图 2.1 上方的规划流水线作为 teaser。

== 相关工作与研究定位
// 讲 35 秒。内容：三类相关工作各一句：VLM 规划主要改进计划生成/反馈修正；Thinking with Images 主要提供视觉中间表示；归纳学习主要从经验中获得可复用符号知识。最后落到本文定位：为规划充分性构建符号化想象空间，并用可复用视觉模式降低接地成本。
// 图表建议：不建议放复杂图；做一张三列表格“VLM 规划 / TWI / 归纳学习”，最后一列用高亮框写“本文：PI-TWI”。

== 研究目标与创新点
// 讲 50 秒。内容：用 3 个贡献收束绪论：1）将 TWI 形式化为规划充分的符号化想象空间构建；2）提出模式推断，用已知视觉模式补全或重排序局部变量；3）提出模式归纳，用在线归纳学习自动构建模式库。
// 图表建议：放论文图 2.1 的整体框架缩略图，但这里只讲“总览”，不要提前讲细节；方法章节再展开。

= 第二章：方法

== PI-TWI 方法概览
// 讲 50 秒。内容：围绕图 2.1 从上到下讲两条线：推断线是“当前世界 -> 内部世界模型 -> 规划器询问 -> 揭示/补全/重排序 -> 最终方案”；学习线是“回放缓冲区 -> VLM 模式提议 -> 随机掩码训练数据 -> 重加权 -> 模式库”。
// 图表建议：放论文图 2.1 全图。这是全场最重要的方法图，建议占半页以上，并用动画/标注依次突出“规划流水线、模式学习、PI-TWI 推断”。

== 将"以图思考"形式化为规划充分的符号化想象空间构建
// 讲 45 秒。内容：只解释直觉：视觉变量是可检查的最小单元；揭示算子把局部图像接地成符号事实；符号化想象空间由直接揭示事实和模式补全事实组成；充分性检查器判断当前信息是否足够让真实规划器给出正确计划。
// 图表建议：放一张自制简化流程图“图像 I -> 揭示 R(I,u) -> 符号事实 -> Mt -> 规划器 Π / 检查器 C”，公式最多只保留 Mt = KR ⊕ KI 和 C(Mt)。

== 作为门控混合专家的模式推断
// 讲 45 秒。内容：把视觉模式讲成“可复用的局部规律专家”：适用性判断该模式能不能用，门控判断上下文是否匹配，权重表示可靠性。重点讲两个用途：高置信度时直接补全未知事实；候选很多时按任务相关性重排序优先揭示。
// 图表建议：放论文图 3.3 下半部分的“重排序 & 揭示”和“补全”区域，或者自画“多个模式专家 -> 加权投票 -> 补全/排序”的小图。

== 用于构建模式库的在线归纳学习
// 讲 50 秒。内容：讲清楚模式从哪里来：历史最终符号化想象空间进入回放缓冲区；VLM 从样例中提议候选宏模式；随机掩码生成自监督训练数据；系统根据恢复遮蔽事实的效果重加权模式；整个过程在线重复。
// 图表建议：放论文图 3.3 上半部分，重点标出“回放缓冲区、VLM 提议的模式、掩码样本、模式库权重”。也可以把图 2.1 下方“模式学习”局部作为更简洁版本。

== 实现细节：三个任务如何接入同一框架
// 讲 45 秒。内容：用三列说明三个环境的差异即可，不要展开所有超参数。FrozenLake：LazySP 最短路径，4x4 宏模式；Crafter：按成就依赖做长程资源获取与合成；CubeBench：主动揭示 54 个魔方面颜色并交给 Kociemba 求解器。
// 图表建议：做三列图。FrozenLake 放论文图 3.1；Crafter 放论文图 2.2；CubeBench 放一张魔方输入示例或“54 faces -> solver”的自制小图。

= 第三章：实验与结果分析

== 实验设置与基线
// 讲 45 秒。内容：先说实验回答四个问题：是否存在感知瓶颈、形式化是否缓解瓶颈、模式推断是否降成本、模式归纳是否学到可泛化模式。再介绍三个基准任务、三个基础模型、四类基线/消融，以及两个核心指标：接地/规划准确率和 token 成本。
// 图表建议：放一张紧凑实验设置表，不要直接放论文大段文字。表中列“FrozenLake / Crafter / CubeBench”“VLM 直接输出 / 原生 TWI / 无推断 / 无重加权 / PI-TWI”“准确率 / token”。

== 准确率比较
// 讲 50 秒。内容：围绕论文表 3.1 讲结论，不逐格念数。直接输出在 Crafter、CubeBench 上规划准确率经常为 0；原生 TWI 只在部分小规模视觉任务上改善且模型间不稳定；PI-TWI 在三个任务和三个模型上稳定提升，Crafter 与 CubeBench 中规划准确率达到 100%。
// 图表建议：放论文表 3.1 的精简版，建议只保留“规划准确率”列，必要时用脚注补充接地准确率；高亮 PI-TWI 列。

== 效率比较
// 讲 55 秒。内容：围绕论文表 3.2 和图 3.2 讲 token 与揭示次数下降。FrozenLake 用不到 10% 的准确率损失换来约 40.77% 总 token 降低；Crafter 总 token 降到无推断消融的 63.44%；CubeBench 接近主动揭示理论下限。再强调无重加权会明显增加 token，说明在线归纳学习有必要。
// 图表建议：左侧放论文表 3.2 的精简版，右侧放论文图 3.2 主动揭示次数曲线；用一个箭头标注“学习越进行，模式库越有用”。

== 定性结果与分布外泛化
// 讲 45 秒。内容：用定性图说明模式确实是“被提出、被筛选、被用于推断”的。再讲 OOD：在 64x64 Crafter 学到的模式和权重零样本迁移到 128x128 地图，主动揭示次数从 2349.63 降到 1570.45。
// 图表建议：主图放论文图 3.3；FrozenLake 和 CubeBench 的图 3.4、图 3.5 可放成备选/附录，不建议正讲时都展开。

= 第四章：结论与展望

== 总结、局限性与未来工作
// 讲 45 秒。内容：总结三句话：1）PI-TWI 通过构建规划充分的符号化想象空间缓解 VLM 感知瓶颈；2）模式推断在准确率与效率之间提供更好权衡；3）模式归纳让模式库可从经验中在线形成。局限性：当前是确定性视觉规划基准，变量类型集合和边界框预先给定。未来工作：扩展到真实/随机环境，协同使用补全与重排序。
// 图表建议：不必放复杂图；放三条贡献 + 两条局限/展望的总结卡片，或复用论文图 2.1 的小缩略图作为回扣。

// = 第一章：样式

// == 想分列显示？

// // #slide[
// //   第一列
// // ][
// //   第二列
// // ]

// #slide(composer: (1fr,1fr, auto))[
//   #Colorful[GOOGLE].
//   `void fn`
// ][
//   *Second column.第二列*
// ][
//   #figure(
//     image("./imgs/brand-rust.svg", width: 30%),
//     caption: [Rust logo],
//   )
// ]

// == 表格
// //表格内容设置在main.typ中


// #let a = table.cell(
//   fill: green.lighten(60%),
// )[A]
// #let b = table.cell(
//   fill: aqua.lighten(60%),
// )[B]

// #table(
//   columns: 4,
//   [], [Exam 1], [Exam 2], [Exam 3],

//   [John], [], a, [],
//   [Mary], [], a, a,
//   [Robert], b, a, b,
// )

// = 第二章：小组件

// == 时间轴，很简单

// //timeliney: https://typst.app/universe/package/timeliney
// #timeliney.timeline(
//   show-grid: true,
//   {
//     import timeliney: *
      
//     headerline(group(([*2023*], 4)), group(([*2024*], 4)))
//     headerline(
//       group(..range(4).map(n => strong("Q" + str(n + 1)))),
//       group(..range(4).map(n => strong("Q" + str(n + 1)))),
//     )
  
//     taskgroup(title: [*Research*], {
//       task("Research the market", (0, 2), style: (stroke: 2pt + gray))
//       task("Conduct user surveys", (1, 3), style: (stroke: 2pt + gray))
//     })

//     taskgroup(title: [*Development*], {
//       task("Create mock-ups", (2, 3), style: (stroke: 2pt + gray))
//       task("Develop application", (3, 5), style: (stroke: 2pt + gray))
//       task("QA", (3.5, 6), style: (stroke: 2pt + gray))
//     })

//     taskgroup(title: [*Marketing*], {
//       task("Press demos", (3.5, 7.5), style: (stroke: 2pt + gray))
//       task("Social media advertising", (6, 7.5), style: (stroke: 2pt + gray))
//     })

//     milestone(
//       at: 3.75,
//       style: (stroke: (dash: "dashed")),
//       align(center, [
//         *Conference demo*\
//         Dec 2023
//       ])
//     )

//     milestone(
//       at: 6.5,
//       style: (stroke: (dash: "dashed")),
//       align(center, [
//         *App store launch*\
//         Aug 2024
//       ])
//     )
//   }
// )

// == 代码块，很优雅

// #slide[
// ```typc
// pub fn main() {
//     println!("Hello, world!");
// }
// ```
// ][
//   //codly: https://typst.app/universe/package/codly
// ```rust
// pub fn main() {
//     println!("Hello, world!");
// }
// ```
// ]

// == 用节点和箭头绘制图表

// #slide[
//   #set text(size: .5em,)

// ```typc
// #diagram(cell-size: 15mm, $
//   G edge(f, ->) edge("d", pi, ->>) & im(f) \
//   G slash ker(f) edge("ur", tilde(f), "hook-->")
// $)
// ```
// ][
//   #align(center,{
//   diagram(cell-size: 15mm, $
//     G edge(f, ->) edge("d", pi, ->>) & im(f) \
//     G slash ker(f) edge("ur", tilde(f), "hook-->")
//   $)
//   })
// ]

// #slide[
// #set text(size: .5em,)

// ```typc
// #import fletcher.shapes: diamond
// #set text(font: "Comic Neue", weight: 600)

// #diagram(
//   node-stroke: 1pt,
//   edge-stroke: 1pt,
//   node((0,0), [Start], corner-radius: 2pt, extrude: (0, 3)),
//   edge("-|>"),
//   node((0,1), align(center)[
//     Hey, wait,\ this flowchart\ is a trap!
//   ], shape: diamond),
//   edge("d,r,u,l", "-|>", [Yes], label-pos: 0.1)
// )
// ```
// ][
//   #align(center,{
// import fletcher.shapes: diamond
// set text(font: "Times New Roman", weight: 600)

// diagram(
//   node-stroke: 1pt,
//   edge-stroke: 1pt,
//   node((0,0), [Start], corner-radius: 2pt, extrude: (0, 3)),
//   edge("-|>"),
//   node((0,1), align(center)[
//     Hey, wait,\ this flowchart\ is a trap!
//   ], shape: diamond),
//   edge("d,r,u,l", "-|>", [Yes], label-pos: 0.1)
// )
//   })
// ]

// #slide[
//   #set text(size: .5em,)

// ```typc
// #set text(10pt)
// #diagram(
//   node-stroke: .1em,
//   node-fill: gradient.radial(blue.lighten(80%), blue, center: (30%, 20%), radius: 80%),
//   spacing: 4em,
//   edge((-1,0), "r", "-|>", `open(path)`, label-pos: 0, label-side: center),
//   node((0,0), `reading`, radius: 2em),
//   edge(`read()`, "-|>"),
//   node((1,0), `eof`, radius: 2em),
//   edge(`close()`, "-|>"),
//   node((2,0), `closed`, radius: 2em, extrude: (-2.5, 0)),
//   edge((0,0), (0,0), `read()`, "--|>", bend: 130deg),
//   edge((0,0), (2,0), `close()`, "-|>", bend: -40deg),
// )
// ```
// ][
  
//   #align(center,{
// set text(10pt)
// diagram(
//   node-stroke: .1em,
//   node-fill: gradient.radial(blue.lighten(80%), blue, center: (30%, 20%), radius: 80%),
//   spacing: 4em,
//   edge((-1,0), "r", "-|>", `open(path)`, label-pos: 0, label-side: center),
//   node((0,0), `reading`, radius: 2em),
//   edge(`read()`, "-|>"),
//   node((1,0), `eof`, radius: 2em),
//   edge(`close()`, "-|>"),
//   node((2,0), `closed`, radius: 2em, extrude: (-2.5, 0)),
//   edge((0,0), (0,0), `read()`, "--|>", bend: 130deg),
//   edge((0,0), (2,0), `close()`, "-|>", bend: -40deg),
// )
//   })
// ]

// #slide[
//   #set text(size: .5em)

// ```typc
// #diagram(cell-size: 15mm, $
//   G edge(f, ->) edge("d", pi, ->>) & im(f) \
//   G slash ker(f) edge("ur", tilde(f), "hook-->")
// $)
// ```
// ][
//   #align(center,{
//   diagram(cell-size: 15mm, $
//     G edge(f, ->) edge("d", pi, ->>) & im(f) \
//     G slash ker(f) edge("ur", tilde(f), "hook-->")
//   $)
//   })
// ]

// == 展示框，很有趣

// #slide[
//   #set text(size: .5em)

// ```typc
// #showybox(
//   [Hello world!]
// )
// ```
// ```typc
// showybox(
//   frame: (
//     dash: "dashed",
//     border-color: red.darken(40%)
//   ),
//   body-style: (
//     align: center
//   ),
//   sep: (
//     dash: "dashed"
//   ),
//   shadow: (
// 	  offset: (x: 2pt, y: 3pt),
//     color: yellow.lighten(70%)
//   ),
//   [This is an important message!],
//   [Be careful outside. There are dangerous bananas!]
// )
// ```

// ][
//   #align(center,{

//   showybox(
//   [Hello world!]
//   )

// showybox(
//   frame: (
//     dash: "dashed",
//     border-color: red.darken(40%)
//   ),
//   body-style: (
//     align: center
//   ),
//   sep: (
//     dash: "dashed"
//   ),
//   shadow: (
// 	  offset: (x: 2pt, y: 3pt),
//     color: yellow.lighten(70%)
//   ),
//   [This is an important message!],
//   [Be careful outside. There are dangerous bananas!]
// )

//   })
// ]

// == 提示框

// #slide[
//   #set text(size: .5em)
// ```typc
// #info[ This is the info clue ... ]
// #tip(title: "Best tip ever")[Check out this cool package]
// ```
// ][
//   #align(center,{
// info[ This is the info clue ... ]
// tip(title: "Best tip ever")[Check out this cool package]
//   })
// ]

// == 类obsidian

// #info[This is information]

// #success[I'm making a note here: huge success]

// #check[This is checked!]

// #warning[First warning...]

// #note[My incredibly useful note]

// #question[Question... (truncated)

// #example[An example make things interesting]

// #quote[To be or not to be]

// #callout(
//   title: "Callout",
//   fill: blue,
//   title-color: white,
//   body-color: black,
//   icon: none)[123]

// #let mycallout = callout.with(title: "My callout")//TODO:放到config中去

// #mycallout[Hey this is my custom callout!]

// = 第三章：页面

// // == focus-slide

// // #focus-slide[
// //   聚焦页
// // ]

// // == matrix-slide

// // #matrix-slide[
// //   left
// // ][
// //   middle
// // ][
// //   right
// // ]

// // #matrix-slide(columns: 1)[
// //   top
// // ][
// //   bottom
// // ]

// // #matrix-slide(columns: (1fr, 2fr, 1fr), ..(lorem(8),) * 9)

// == demo页

// #BlueBox(title: "你好")[bubu]

== 致谢
// 讲 10-15 秒。内容：感谢导师、评委老师和课题组；不要展开个人致谢正文，把时间留给提问。
// 图表建议：保留当前 ending-slide 即可，不需要额外图。

#ending-slide[
  #align(center + horizon)[
  #set text(size: 3em, weight: "bold", s.colors.primary)

  谢谢！

  THANKS!
]
]