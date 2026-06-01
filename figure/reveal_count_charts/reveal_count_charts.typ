#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 2pt,
    image("frozenlake_sigma_2.0_mean.pdf", width: 100%),
    image("crafter_sigma_2.0_mean.pdf", width: 100%),
    image("cube_sigma_2.0_mean.pdf", width: 100%),
  ),
  caption: [
    效率实验中的主动揭示次数比较（高斯平滑，$sigma=2.0$）。
  ],
) <fig:reveal_count_charts>
