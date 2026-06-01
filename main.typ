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
  head-logo: image("./imgs/zju_logo_side.svg", width: 13%),
  github: "",
)
#let s = (s.methods.colors)(
  self: s,
  primary: rgb("#004098"),
  secondary: rgb("#004098"),
)

#let (init, slides) = utils.methods(s)
#let (
  slide,
  empty-slide,
  title-slide,
  outline-slide,
  new-section-slide,
  ending-slide,
  focus-slide,
  matrix-slide,
) = utils.slides(s)

#show: codly-init.with()
#show: init
#show: slides.with()

#outline-slide()

= 第一章：绪论

== 研究背景：视觉规划中的感知瓶颈

#slide(composer: (1.2fr, 1.38fr))[
  - 虽然#text(green)[VLM 在视觉规划任务中，展示出巨大潜力]；但是，#text(red)[当前 VLM 在以原始视觉输入为基础的规划领域仍会遇到困难。即，尤其是在复杂任务中，VLM 存在严重的视觉感知瓶颈。]
  - 虽然#text(green)["以图思考"这一新型范式，一定程度上缓解了上述的视觉感知瓶颈]；但是，#text(red)[即使当前 VLM 已经接受了较充分的通用"以图思考"能力训练，它们在规划领域中的感知障碍仍然存在]
][
  #include "tables/main-baseline-1.typ"
]

== 研究目标

#slide(composer: (1.2fr, 1.38fr))[
  #text(0.8em)[
    本工作的定位是一个初步的概念验证研究，旨在验证以下观点：

    1. 将面向规划的"以图思考"形式化为逐步构建并反思精确内部符号化想象空间的工具，可以使 VLM 有效突破规划中的感知瓶颈
    2. 视觉模式可以作为可复用且可组合的工具，显著降低构建内部符号化想象空间的成本
    3. 关键视觉模式可以由 VLM 基于在线归纳学习框架自主构建

    本工作将上述方法组织为 #text(green)[模式归纳"以图思考"]（Pattern-Induced Thinking with Images, PI-TWI），并在三个具有挑战性的视觉规划任务 #smallcaps("FrozenLake")、#smallcaps("Crafter") 和 #smallcaps("CubeBench") 上进行评估。
  ]][
  #include "tables/main-baseline-1.typ"
]

= 第二章：相关工作及研究定位

== 基于 VLM 的规划

- PaLM-E: 初步将视觉观测和语言指令整合起来，以支持序列机器人操作中的高层规划
- ReplanVLM: 引入闭环视觉反馈，从而能够检测执行失败并相应修正规划
- Reflective Planning: 通过想象未来世界状态这一方式，改进长程操作规划

先前工作大多#text(gray)[同时研究感知和规划]。而本工作基于*真实规划器已知*的前提，主要研究规划任务中的*感知问题*。

== "以图思考" (TWI)

- V-Star, etc: 调用视觉裁剪工具动态获取证据
- ViperGPT, etc: 使用视觉草稿纸
- MVoT, etc: 直接在视觉模态中模拟未来状态

本工作建立在"以图思考"这一视角之上，但是主要关注"以图思考"在规划问题上的应用（即面向规划的"以图规划"）。

同时，与先前的面向规划"以图思考"不同，本工作将*此过程形式化为面向规划器充分性的符号化想象空间构建过程*。即，算法必须决定图片的哪些部分与规划相关，以及判断当前符号化想象空间是否已经足以让真实规划器进行规划。

== 面向知识获取的归纳学习

- #sym.alpha ILP: 传统可微归纳逻辑编程方法
- ShapeLib, FactoredScenes, PoE-World: 利用 VLM 生成符号提议
  - PoE-World: 将程序视为组合式专家，用于表示符号化想象空间中的转移规则

本工作利用 VLM *同时进行感知和生成符号模式提议*。同时，为了抑制错误的归纳结果，受混合专家模型 (Mixture-of-Experts, MoE) 和掩码自编码器 (Masked Autoencoder, MAE)的启发，本工作*利用随机遮蔽的历史轨迹作为训练数据*，借助基于梯度的优化方式*调整不同专家的权重*，降低错误或者无关专家的权重。

= 第三章：方法

== PI-TWI 方法概览
#slide(composer: (1.2fr, 1.38fr))[
  #text(0.8em)[
    1. 为突破 VLMs 在视觉规划中的感知限制，本工作将"以图思考"定义为一种从视觉证据中构建"规划充分"的符号化想象空间的方法
    2. 为降低符号化想象空间构建成本，本工作引入一种新的"以图思考"策略——模式推断，从而使 VLMs 能够在规划任务中主动识别已知视觉模式，并直接推断局部符号化想象空间结构
    3. 为通过学习获得这些可组合且可复用的模式，本工作提出模式归纳。这是一种从经验中在线构建模式库的归纳学习方法
  ]
][
  #figure(
    image("./figure/pipeline_cn.pdf", width: 110%),
    caption: [#smallcaps("PI-TWI") 方法概览 (以 #smallcaps("Crafter") 为例)],
  )
]


== 将"以图思考"形式化为规划充分的符号化想象空间构建

#slide(composer: (1.2fr, 1.38fr))[
  #text(0.7em)[
    - *视觉变量*是可单独检查的最小单元
      - 如：右图 #smallcaps("Crafter") 环境的一个网格单元
    - 一次感知操作中，*揭示算子*首先剪裁一个视觉变量对应的图像区域，然后通过 VLM 将该区域接地为符号事实
      - 如：原本未知的红框，在这里被揭示算子接地成了"石块"这一符号事实
    - *符号化想象空间*由*直接揭示事实*和*模式补全事实*组成
      - *直接揭示事实*：由揭示算子直接揭示，需要昂贵的 VLM 调用进行感知
      - *模式补全事实*：通过模式推断进行补全，无需昂贵的 VLM 调用进行感知
    - *充分性检查器*判断当前信息是否足够让真实规划器给出正确计划
  ]
][
  #figure(
    image("./figure/qualitative_craft_cn.pdf", width: 110%),
    caption: [#smallcaps("Crafter") 中模式推断与模式归纳过程的定性示意],
  )
]

== 作为门控混合专家的模式推断

#slide(composer: (1.2fr, 1.38fr))[
  #text(0.7em)[
    - *符号模式*是一种可组合、可复用且满足条件时激活的规律，可用于预测目标视觉变量的值。
    - 本工作将每个模式视为一个门控专家
      - 门控机制决定*一个（门控）专家是否会在某个视觉变量处激活*
    - 对于任意未揭露的视觉变量，每一个在该处激活的专家，会预测一个视觉变量的值的概率分布
      - 受混合专家模型的启发，每一个门控专家有一个权重。从而，视觉变量值的概率分布，为所有活跃专家的加权平均。
    - 一个未知的视觉变量值的概率分布，有两个作用
      - *补全*：若最大概率大于置信度阈值，则通过*模式推断进行补全，无需昂贵的 VLM 调用进行感知*
      - *重排序*：帮助决定下一步应优先揭示哪个变量，从而*将感知调用投入到更可能帮助规划器的变量*上
  ]
][
  #figure(
    image("./figure/qualitative_craft_cn.pdf", width: 110%),
    // caption: [#smallcaps("Crafter") 中模式推断与模式归纳过程的定性示意],
  )
  // #figure(
  //   image("./figure/qualitative_frozenlake_cn.pdf", width: 70%),
  //   // caption: [#smallcaps("Crafter") 中模式推断与模式归纳过程的定性示意],
  // )
]

== 用于构建模式库的在线归纳学习

#slide(composer: (1.2fr, 1.38fr))[
  #text(0.7em)[
    - *归纳学习*：利用具有通用归纳能力的 VLM，对历史轨迹进行归纳
    - *权重训练*
      - 生成训练数据：受掩码自编码器的启发，本工作通过随机遮蔽历史轨迹中的已知视觉变量，为自监督学习构建训练数据。
      - 基于梯度优化：对训练数据中被遮蔽的视觉变量进行概率推断，以最大似然估计为优化目标，进行基于梯度优化
  ]
][
  #figure(
    image("./figure/qualitative_craft_cn.pdf", width: 110%),
    // caption: [#smallcaps("Crafter") 中模式推断与模式归纳过程的定性示意],
  )
  // #figure(
  //   image("./figure/qualitative_frozenlake_cn.pdf", width: 70%),
  //   // caption: [#smallcaps("Crafter") 中模式推断与模式归纳过程的定性示意],
  // )
]

= 第四章：实验与结果分析

== 实验设置



#slide(composer: (1fr, 1fr))[
  === #smallcaps("FrozenLake")
  #text(0.9em)[
    智能体观察一个渲染网格世界，并必须从起点到终点找到一条不坠入坑洞的最短安全路径。本工作将地图生成过程改成由基于 6 个手工设计的模式的随机生成。每个视觉变量是一个网格单元，其值为单元类型
  ]
  #include "./figure/patterns/pattern_fig.typ"
][
  #figure(image("figure/frozenlake-1.png", width: 80%))
]
#slide(composer: (1fr, 1fr))[
  === #smallcaps("Crafter")
  #text(0.9em)[
    #smallcaps("Crafter") 原本是一个随机生存环境。本工作将其改造为一个确定性的视觉资源获取和合成任务：PI-TWI 智能体获得任务规格，并必须接地足够多的地图信息，以规划一系列可行的导航、收集和合成动作。每个视觉变量是一个网格单元，其值为对应的地形、物体或资源类型。
  ]
][
  #figure(image("figure/crafter-1.png", width: 80%))
]
#slide(composer: (1fr, 1fr))[
  === #smallcaps("CubeBench")
  #text(0.9em)[
    将魔方状态接地评估为一个结构化视觉规划问题。每个实例渲染一个魔方状态；智能体必须重建足够的符号化的魔方小面信息，以供下游魔方规划器或求解器使用。每个视觉变量是一个小面，其值为六种颜色之一。
  ]
][
  #figure(image("figure/cubebench-1.png", width: 80%))
]

== 基线、消融实验和指标设置

- 基线
  - VLM 直接输出：要求 VLM 一次性将渲染图像直接转写为符号化想象空间
  - 原生"以图思考"：如结合代码解释器的 GPT-5.4, Qwen Agent
- 消融实验
  - 无推断：禁用基于模式的补全和重排序。规划器只能使用直接揭示的事实。
  - 无重加权：禁用模式权重的在线优化。该消融用于测试是否有必要利用回放缓冲区中的历史轨迹训练权重。
- 指标
  - 效率：本工作使用*总 token 消耗*作为效率代理指标，其中包括*感知 token* 和*提议 token*。总 token 和感知 token 在所有回合上取平均，提议 token 在所有提议上取平均。
  - 准确性：*规划准确率*和*接地准确率*。

== 准确率比较

#slide(composer: (1.2fr, 1.38fr))[
  - 直接使用 VLM 输出会导致较差表现，#text(red)[在#smallcaps("CubeBench") 和 #smallcaps("Crafter") 等视觉复杂或规模较大的环境中表现为规划准确率为零]
  - 原生"以图思考"能够#text(green)[改善部分环境-模型组合的表现]
    - #text(red)[主要集中在 CubeBench 这类视觉复杂的小规模任务上，无法可靠扩展到 Crafter 这样的大规模环境]
    - #text(red)[其有效性在不同模型之间并不稳定]
  - PI-TWI #text(green)[在所有评估任务和模型上都稳定提升了接地准确率和规划准确率]
][
  #include "tables/main-baseline-2.typ"
]

== 效率比较

#slide(composer: (1.2fr, 1.38fr))[
  *从总 token 消耗来看，PI-TWI 在所有任务中都显著优于其他设置*

  具体地：

  #text(0.8em)[
    - #smallcaps("FrozenLake")：以不到 10% 的准确率下降为代价，实现了 40.77% 的总 token 消耗降低
    - #smallcaps("Crafter")：借助重排序，总 token 消耗降低到了"无推断"消融的 63.44%
    - #smallcaps("CubeBench")：考虑到"仅角块模式补全"的理论下限（4.05k），从 5.02k 降至 4.74k 达到了最大可能降低幅度的约 42.86%
  ]
][
  #include "tables/main-ablation.typ"
  #include "figure/reveal_count_charts/reveal_count_charts.typ"
]

== 分布外泛化

- 同一类但是不同规模的实验之间，虽然共用同样的模式，但是不一定共用同样的权重。
- 本工作希望测试：在较小地图上完成训练后，模式及其权重能否零样本泛化到更大的地图。这意味着不仅模式固定，权重也固定，并且不会在更大地图上进行任何训练。
- 具体地：本工作将 Crafter 在 64x64 地图上学习到的模式和权重测试到更大的 128x128 地图上。结果表明，模式及其权重*具有较强的分布外泛化能力*。主动揭示次数从 2349.63 下降到 1570.45，说明该方法具有有效性。

= 第五章：结论与展望

== 总结


之前的实验证明了以下三点：

1. 将面向规划的"以图思考"形式化为逐步构建并反思精确内部符号化想象空间的工具，可以使 VLM 有效突破规划中的感知瓶颈
2. 视觉模式可以作为可复用且可组合的工具，显著降低构建内部符号化想象空间的成本
3. 关键视觉模式可以由 VLM 基于在线归纳学习框架自主构建

== 局限性和未来工作

#slide[
  === 局限性

  #text(0.7em)[
    - 作为一项概念验证研究，本工作*聚焦于确定性视觉规划任务，而非真实世界或随机环境*
    - 本工作还假设了*可能的视觉变量类型集合以及每个视觉变量的边界框均已提前给定*
      - 从这个意义上说，本工作中的方法只解决了更广义"以图思考"效率问题中的一部分：当每次揭示操作都返回正确视觉信息且符号接口已经指定时，如何降低接地成本。
  ]

  === 未来工作

  #text(0.7em)[
    未来工作可以将 PI-TWI 扩展到真实世界和随机环境，并协同使用补全与重排序。

    具体地：

    - 补全将继续降低高确定性结构规律的接地成本，例如重复的模式
    - 对于噪声更大、非确定性的规律，重排序将作为可解释的启发式方法，用于优先探索和规划，而不将不确定事实直接写入符号化想象空间。

    这两种方法使 PI-TWI 能够利用多样环境模式，同时保持对不确定性的鲁棒性。
  ]
]
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

#ending-slide[
  #align(center + horizon)[
    #set text(size: 3em, weight: "bold", s.colors.primary)

    谢谢！

    // THANKS!
  ]
]
