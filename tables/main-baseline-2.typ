#figure(
  text(size: 9pt)[
    #table(
      columns: (auto, 1.7fr) + (1fr,) * 6,
      align: (center, left) + (center,) * 6,
      inset: (x: 1.5pt, y: 1.3pt),
      stroke: none,
      table.hline(stroke: 0.6pt),
      table.cell(rowspan: 2)[*环境*],
      table.cell(rowspan: 2)[*模型*],
      table.cell(colspan: 2)[*VLM 直接输出*],
      table.cell(colspan: 2)[*原生"以图思考"*],
      table.cell(colspan: 2)[*PI-TWI*],
      table.hline(start: 2, stroke: 0.4pt),
      [*接地准确率*], [*规划准确率*], [*接地准确率*], [*规划准确率*], [*接地准确率*], [*规划准确率*],
      table.hline(stroke: 0.4pt),

      table.cell(rowspan: 3)[#smallcaps[FrozenLake]],
      [GPT-5.4], [92.88], [85.00], [92.46], [85.00], [*97.19*], [*90.78*],
      [Gemini 3.1 Pro], [93.87], [87.50], [93.66], [85.00], [*97.15*], [*94.00*],
      [#text(0.7em)[Qwen3 VL 235B A22B]], [54.92], [17.50], [45.78], [17.50], [*95.35*], [*82.78*],
      table.hline(stroke: 0.4pt),

      table.cell(rowspan: 3)[#smallcaps[Crafter]],
      [GPT-5.4], [46.39], [0.00], [44.28], [0.00], [*100.00*], [*100.00*],
      [Gemini 3.1 Pro], [26.71], [0.00], [48.78], [41.67], [*100.00*], [*100.00*],
      [#text(0.7em)[Qwen3 VL 235B A22B]], [0.00], [0.00], [22.08], [0.00], [*100.00*], [*100.00*],
      table.hline(stroke: 0.4pt),

      table.cell(rowspan: 3)[#smallcaps[CubeBench]],
      [GPT-5.4], [25.73], [0.00], [98.83], [96.00], [*100.00*], [*100.00*],
      [Gemini 3.1 Pro], [18.65], [0.00], [91.44], [71.00], [*100.00*], [*100.00*],
      [#text(0.7em)[Qwen3 VL 235B A22B]], [16.00], [0.00], [17.08], [0.00], [*100.00*], [*100.00*],
      table.hline(stroke: 0.6pt),
    )
  ],
  caption: [与基线方法的准确率比较。接地准确率和规划准确率均以百分比报告。实验使用三个代表性基础模型：GPT-5.4、Gemini 3.1 Pro 和 Qwen3 VL 235B A22B。],
) <tab:pitwi_baseline>
