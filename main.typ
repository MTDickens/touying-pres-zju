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

// 建议总时长：8-10 分钟；正文控制在 12 页左右，每页约 35-50 秒。重点讲“问题—方法—结果—结论”，公式只讲直觉，不展开推导。

= 第一章：绪论

== 研究背景：视觉规划中的感知瓶颈
// 讲 45 秒。内容：从 VLM 在视觉规划中的潜力切入，马上指出核心瓶颈不是规划器不够强，而是复杂原始视觉输入超出 VLM 单步感知能力；再说明"以图思考"能把感知拆成局部步骤，但通用"以图思考"在规划任务中仍不稳定。
// 图表建议：放一张自制动机图“复杂视觉输入 -> 错误/不完整符号化想象空间 -> 规划失败 -> 局部揭示修正”，也可以裁剪论文图 2.1 上方的规划流水线作为 teaser。

#slide(composer: (1.2fr, 1.38fr))[
  - 虽然#text(green)[VLM 在视觉规划任务中，展示出巨大潜力]；但是，#text(red)[当前 VLM 在以原始视觉输入为基础的规划领域仍会遇到困难。即，尤其是在复杂任务中，VLM 存在严重的视觉感知瓶颈。]
  - 虽然#text(green)["以图思考"这一新型范式，一定程度上缓解了上述的视觉感知瓶颈]；但是，#text(red)[即使当前 VLM 已经接受了较充分的通用"以图思考"能力训练，它们在规划领域中的感知障碍仍然存在]
][
  #include "tables/main-baseline-1.typ"
]

== 研究目标
// 讲 50 秒。内容：用 3 个贡献收束绪论：1）将 TWI 形式化为规划充分的符号化想象空间构建；2）提出模式推断，用已知视觉模式补全或重排序局部变量；3）提出模式归纳，用在线归纳学习自动构建模式库。
// 图表建议：放论文图 2.1 的整体框架缩略图，但这里只讲“总览”，不要提前讲细节；方法章节再展开。

#slide(composer: (1.2fr, 1.38fr))[
  #text(0.8em)[
    该工作的定位是一个初步的概念验证研究，旨在验证以下观点：

    1. 将面向规划的"以图思考"形式化为逐步构建并反思精确内部符号化想象空间的工具，可以使 VLM 有效突破规划中的感知瓶颈
    2. 视觉模式可以作为可复用且可组合的工具，显著降低构建内部符号化想象空间的成本
    3. 关键视觉模式可以由 VLM 基于在线归纳学习框架自主构建

    该工作将上述方法组织为 #text(green)[模式归纳"以图思考"]（Pattern-Induced Thinking with Images, PI-TWI），并在三个具有挑战性的视觉规划任务 #smallcaps("FrozenLake")、#smallcaps("Crafter") 和 #smallcaps("CubeBench") 上进行评估。
  ]][
  #include "tables/main-baseline-1.typ"
]

= 第二章：相关工作及研究定位
// 讲 35 秒。内容：三类相关工作各一句：VLM 规划主要改进计划生成/反馈修正；Thinking with Images 主要提供视觉中间表示；归纳学习主要从经验中获得可复用符号知识。最后落到该工作定位：为规划充分性构建符号化想象空间，并用可复用视觉模式降低接地成本。
// 图表建议：不建议放复杂图；做一张三列表格“VLM 规划 / 以图思考 / 归纳学习”，最后一列用高亮框写“该工作：PI-TWI”。

== 基于 VLM 的规划

- PaLM-E: 初步将视觉观测和语言指令整合起来，以支持序列机器人操作中的高层规划
- ReplanVLM: 引入闭环视觉反馈，从而能够检测执行失败并相应修正规划
- Reflective Planning: 通过想象未来世界状态这一方式，改进长程操作规划

先前工作大多#text(gray)[同时研究感知和规划]。而我们的工作基于*真实规划器已知*的前提，主要研究规划任务中的*感知问题*。

== "以图思考" (TWI)

- V-Star, etc: 调用视觉裁剪工具动态获取证据
- ViperGPT, etc: 使用视觉草稿纸
- MVoT, etc: 直接在视觉模态中模拟未来状态

我们的工作建立在"以图思考"这一视角之上，但是主要关注"以图思考"在规划问题上的应用（即面向规划的"以图规划"）。

同时，与先前的面向规划"以图思考"不同，我们的工作将*此过程形式化为面向规划器充分性的符号化想象空间构建过程*。即，算法必须决定图片的哪些部分与规划相关，以及判断当前符号化想象空间是否已经足以让真实规划器进行规划。

== 面向知识获取的归纳学习

- #sym.alpha ILP: 传统可微归纳逻辑编程方法
- ShapeLib, FactoredScenes, PoE-World: 利用 VLM 生成符号提议
  - PoE-World: 将程序视为组合式专家，用于表示符号化想象空间中的转移规则

我们的工作利用 VLM *同时进行感知和生成符号模式提议*。同时，为了抑制错误的归纳结果，受混合专家模型 (Mixture-of-Experts, MoE) 和掩码自编码器 (Masked Autoencoder, MAE)的启发，我们的工作*利用随机遮蔽的历史轨迹作为训练数据*，借助基于梯度的优化方式*调整不同专家的权重*，降低错误或者无关专家的权重。

= 第三章：方法

== PI-TWI 方法概览
// 讲 50 秒。内容：围绕图 2.1 从上到下讲两条线：推断线是“当前世界 -> 内部世界模型 -> 规划器询问 -> 揭示/补全/重排序 -> 最终方案”；学习线是“回放缓冲区 -> VLM 模式提议 -> 随机掩码训练数据 -> 重加权 -> 模式库”。
// 图表建议：放论文图 2.1 全图。这是全场最重要的方法图，建议占半页以上，并用动画/标注依次突出“规划流水线、模式学习、PI-TWI 推断”。
#slide(composer: (1.2fr, 1.38fr))[
  #text(0.8em)[
    - 为突破 VLMs 在视觉规划中的感知限制，该工作将"以图思考"定义为一种从视觉证据中构建"规划充分"的符号化想象空间的方法 (2.1)
    - 为降低符号化想象空间构建成本，该工作引入一种新的"以图思考"策略——模式推断，从而使 VLMs 能够在规划任务中主动识别已知视觉模式，并直接推断局部符号化想象空间结构 (2.2)
    - 为通过学习获得这些可组合且可复用的模式，该工作提出模式归纳。这是一种从经验中在线构建模式库的归纳学习方法 (2.3)
  ]
][
  #figure(
    image("./figure/pipeline_cn.pdf", width: 110%),
    caption: [#smallcaps("PI-TWI") 方法概览 (以 #smallcaps("Crafter") 为例)],
  )
]


== 将"以图思考"形式化为规划充分的符号化想象空间构建
// 讲 45 秒。内容：只解释直觉：视觉变量是可检查的最小单元；揭示算子把局部图像接地成符号事实；符号化想象空间由直接揭示事实和模式补全事实组成；充分性检查器判断当前信息是否足够让真实规划器给出正确计划。
// 图表建议：放一张自制简化流程图“图像 I -> 揭示 R(I,u) -> 符号事实 -> Mt -> 规划器 Π / 检查器 C”，公式最多只保留 Mt = KR ⊕ KI 和 C(Mt)。

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
// 讲 45 秒。内容：把视觉模式讲成“可复用的局部规律专家”：适用性判断该模式能不能用，门控判断上下文是否匹配，权重表示可靠性。重点讲两个用途：高置信度时直接补全未知事实；候选很多时按任务相关性重排序优先揭示。
// 图表建议：放论文图 3.3 下半部分的“重排序 & 揭示”和“补全”区域，或者自画“多个模式专家 -> 加权投票 -> 补全/排序”的小图。

#slide(composer: (1.2fr, 1.38fr))[
  #text(0.7em)[
    - *符号模式*是一种可组合、可复用且满足条件时激活的规律，可用于预测目标视觉变量的值。
    - 该工作将每个模式视为一个门控专家
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
// 讲 50 秒。内容：讲清楚模式从哪里来：历史最终符号化想象空间进入回放缓冲区；VLM 从样例中提议候选宏模式；随机掩码生成自监督训练数据；系统根据恢复遮蔽事实的效果重加权模式；整个过程在线重复。
// 图表建议：放论文图 3.3 上半部分，重点标出“回放缓冲区、VLM 提议的模式、掩码样本、模式库权重”。也可以把图 2.1 下方“模式学习”局部作为更简洁版本。

#slide(composer: (1.2fr, 1.38fr))[
  #text(0.7em)[
    - *归纳学习*：利用具有通用归纳能力的 VLM，对历史轨迹进行归纳
    - *权重训练*
      - 生成训练数据：受掩码自编码器的启发，该工作通过随机遮蔽历史轨迹中的已知视觉变量，为自监督学习构建训练数据。
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

// == 实现细节：三个任务如何接入同一框架
// // 讲 45 秒。内容：用三列说明三个环境的差异即可，不要展开所有超参数。FrozenLake：LazySP 最短路径，4x4 宏模式；Crafter：按成就依赖做长程资源获取与合成；CubeBench：主动揭示 54 个魔方面颜色并交给 Kociemba 求解器。
// // 图表建议：做三列图。FrozenLake 放论文图 3.1；Crafter 放论文图 2.2；CubeBench 放一张魔方输入示例或“54 faces -> solver”的自制小图。
// #slide(composer: (1fr, 1fr, 1fr))[
//   #figure(
//     image("./figure/qualitative_craft_cn.pdf", width: 50%),
//   )
// ]
// #slide(composer: (1fr, 1fr, 1fr))[
//   #figure(
//     image("./figure/qualitative_frozenlake_cn.pdf", width: 50%),
//   )
// ]
// #slide(composer: (1fr, 1fr, 1fr))[
//   #figure(
//     image("./figure/qualitative_cube_cn.pdf", width: 50%),
//   )
// ]

= 第四章：实验与结果分析

== 实验设置
// 讲 45 秒。内容：先说实验回答四个问题：是否存在感知瓶颈、形式化是否缓解瓶颈、模式推断是否降成本、模式归纳是否学到可泛化模式。再介绍三个基准任务、三个基础模型、四类基线/消融，以及两个核心指标：接地/规划准确率和 token 成本。
// 图表建议：放一张紧凑实验设置表，不要直接放论文大段文字。表中列“FrozenLake / Crafter / CubeBench”“VLM 直接输出 / 原生 TWI / 无推断 / 无重加权 / PI-TWI”“准确率 / token”。



#slide(composer: (1fr, 1fr))[
  === #smallcaps("FrozenLake")
  #text(0.9em)[
    智能体观察一个渲染网格世界，并必须从起点到终点找到一条不坠入坑洞的最短安全路径。该工作将地图生成过程改成由基于 6 个模式的随机生成。每个视觉变量是一个网格单元，其值为单元类型
  ]
  #include "./figure/patterns/pattern_fig.typ"
][
  #figure(image("figure/frozenlake-1.png", width: 80%))
]
#slide(composer: (1fr, 1fr))[
  === #smallcaps("Crafter")
  #text(0.9em)[
    #smallcaps("Crafter") 原本是一个随机生存环境。该工作将其改造为一个确定性的视觉资源获取和合成任务：PI-TWI 智能体获得任务规格，并必须接地足够多的地图信息，以规划一系列可行的导航、收集和合成动作。每个视觉变量是一个网格单元，其值为对应的地形、物体或资源类型。
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
  - 效率：该工作使用*总 token 消耗*作为效率代理指标，其中包括*感知 token* 和*提议 token*。总 token 和感知 token 在所有回合上取平均，提议 token 在所有提议上取平均。
  - 准确性：*规划准确率*和*接地准确率*。

== 准确率比较
// 讲 50 秒。内容：围绕论文表 3.1 讲结论，不逐格念数。直接输出在 Crafter、CubeBench 上规划准确率经常为 0；原生 TWI 只在部分小规模视觉任务上改善且模型间不稳定；PI-TWI 在三个任务和三个模型上稳定提升，Crafter 与 CubeBench 中规划准确率达到 100%。
// 图表建议：放论文表 3.1 的精简版，建议只保留“规划准确率”列，必要时用脚注补充接地准确率；高亮 PI-TWI 列。
// 讲 55 秒。内容：围绕论文表 3.2 和图 3.2 讲 token 与揭示次数下降。FrozenLake 用不到 10% 的准确率损失换来约 40.77% 总 token 降低；Crafter 总 token 降到无推断消融的 63.44%；CubeBench 接近主动揭示理论下限。再强调无重加权会明显增加 token，说明在线归纳学习有必要。
// 图表建议：左侧放论文表 3.2 的精简版，右侧放论文图 3.2 主动揭示次数曲线；用一个箭头标注“学习越进行，模式库越有用”。

#slide(composer: (1.2fr, 1.38fr))[
  - 直接使用 VLM 输出会导致较差表现，#text(red)[在#smallcaps("CubeBench") 和 #smallcaps("Crafter") 等视觉复杂或规模较大的环境中表现为规划准确率为零]
  - 原生"以图思考"能够#text(green)[改善部分环境-模型组合的表现]
    - #text(red)[主要集中在 CubeBench 这类视觉复杂的小规模任务上，无法可靠扩展到 Crafter 这样的大规模环境]
    - #text(red)[其有效性在不同模型之间并不稳定]
  - PI-TWI #text(green)[在所有评估任务和模型上都稳定提升了接地准确率和感知准确率]
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
]

== 分布外泛化
// 讲 45 秒。内容：用定性图说明模式确实是“被提出、被筛选、被用于推断”的。再讲 OOD：在 64x64 Crafter 学到的模式和权重零样本迁移到 128x128 地图，主动揭示次数从 2349.63 降到 1570.45。
// 图表建议：主图放论文图 3.3；FrozenLake 和 CubeBench 的图 3.4、图 3.5 可放成备选/附录，不建议正讲时都展开。

- 同一类但是不同规模的实验之间，虽然共用同样的模式，但是不一定共用同样的权重。
- 该工作希望测试：在较小地图上完成训练后，模式及其权重能否零样本泛化到更大的地图。这意味着不仅模式固定，权重也固定，并且不会在更大地图上进行任何训练。
- 具体地：该工作将 Crafter 在 64x64 地图上学习到的模式和权重测试到更大的 128x128 地图上。结果表明，模式及其权重*具有较强的分布外泛化能力*。主动揭示次数从 2349.63 下降到 1570.45，说明该方法具有有效性。

= 第五章：结论与展望

== 总结
// 讲 45 秒。内容：总结三句话：1）PI-TWI 通过构建规划充分的符号化想象空间缓解 VLM 感知瓶颈；2）模式推断在准确率与效率之间提供更好权衡；3）模式归纳让模式库可从经验中在线形成。局限性：当前是确定性视觉规划基准，变量类型集合和边界框预先给定。未来工作：扩展到真实/随机环境，协同使用补全与重排序。
// 图表建议：不必放复杂图；放三条贡献 + 两条局限/展望的总结卡片，或复用论文图 2.1 的小缩略图作为回扣。


之前的实验证明了以下三点：

1. 将面向规划的"以图思考"形式化为逐步构建并反思精确内部符号化想象空间的工具，可以使 VLM 有效突破规划中的感知瓶颈
2. 视觉模式可以作为可复用且可组合的工具，显著降低构建内部符号化想象空间的成本
3. 关键视觉模式可以由 VLM 基于在线归纳学习框架自主构建

== 局限性和未来工作

#slide[
  === 局限性

  #text(0.7em)[
    - 作为一项概念验证研究，该工作*聚焦于确定性视觉规划任务，而非真实世界或随机环境*
    - 该工作还假设了*可能的视觉变量类型集合以及每个视觉变量的边界框均已提前给定*
      - 从这个意义上说，该工作中的方法只解决了更广义"以图思考"效率问题中的一部分：当每次揭示操作都返回正确视觉信息且符号接口已经指定时，如何降低接地成本。
  ]

  === 未来工作

  #text(0.7em)[
    未来工作可以将 PI-TWI 扩展到真实世界和随机环境，并协同使用补全与重排序。

    具体地：

    - 补全将继续降低高确定性结构规律的接地成本，例如重复的模式
    - 对于噪声更大、非确定性的规律，重排序将作为可解释的启发式方法，用于优先探索和规划，而不将不确定事实直接写入符号化想象空间。

    这种两种方法使 PI-TWI 能够利用多样环境模式，同时保持对不确定性的鲁棒性。
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
// 讲 10-15 秒。内容：感谢导师、评委老师和课题组；不要展开个人致谢正文，把时间留给提问。
// 图表建议：保留当前 ending-slide 即可，不需要额外图。

#ending-slide[
  #align(center + horizon)[
    #set text(size: 3em, weight: "bold", s.colors.primary)

    谢谢！

    // THANKS!
  ]
]
