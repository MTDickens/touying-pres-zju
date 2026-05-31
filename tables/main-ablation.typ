#figure(
  text(size: 9pt)[
    #table(
      columns: (auto, auto) + (1fr,) * 5,
      align: (center, left) + (center,) * 5,
      inset: (x: 1.5pt, y: 1.3pt),
      stroke: none,

      table.hline(stroke: 0.6pt),
      [*环境*],
      [*方法*],
      [*接地准确率 ↑*],
      [*规划准确率 ↑*],
      [*提议 token ↓*],
      [*感知 token ↓*],
      [*总 token ↓*],
      table.hline(stroke: 0.4pt),

      table.cell(rowspan: 3)[#smallcaps[FrozenLake]],
      [PI-TWI], [97.19], [90.78], [*463.7/267.8*], [*3.10k/158.1*], [*3.19k/208.9*],
      [无推断], [*100.00*], [*100.00*], [--], [5.46k/278.4], [5.46k/278.4],
      [无重加权], [*100.00*], [*100.00*], [471.1/268.2], [5.46k/278.4], [5.55k/329.4],
      table.hline(stroke: 0.4pt),

      table.cell(rowspan: 3)[#smallcaps[Crafter]],
      [PI-TWI], [*100.00*], [*100.00*], [*2.73k/208.8*], [*141.9k/3.86k*], [*142.4k/3.90k*],
      [无推断], [*100.00*], [*100.00*], [--], [224.5k/6.10k], [224.5k/6.10k],
      [无重加权], [*100.00*], [*100.00*], [*2.73k/208.8*], [180.2k/4.90k], [180.8k/4.94k],
      table.hline(stroke: 0.4pt),

      table.cell(rowspan: 3)[#smallcaps[CubeBench]],
      [PI-TWI], [*100.00*], [*100.00*], [*1.56k/499.3*], [*4.31k/244.9*], [*4.45k/289.9*],
      [无推断], [*100.00*], [*100.00*], [--], [4.75k/270.0], [4.75k/270.0],
      [无重加权], [*100.00*], [*100.00*], [1.56k/500.1], [4.75k/270.0], [4.89k/315.0],
      table.hline(stroke: 0.6pt),
    )
  ],
  caption: [使用 GPT-5.4 进行效率比较。准确率以百分比报告；token 成本以输入/输出 token 数报告，其中 $k$ 表示千。],
) <tab:pitwi_ablation>