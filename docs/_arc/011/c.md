---
number: '011'
problem: C
---
first, last を含む単語を頂点とするグラフを作成し, 違う文字が1文字の単語間同士を辺でつなぐ.

このグラフを first から始めて幅優先探索で first からの距離を計算する.

last の距離が無限大であれば到達できない.

そうでないときは, last から始めて今いる頂点から距離が-1になる頂点に渡り歩いていく.
