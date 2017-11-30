---
number: '041'
problem: C
---
右向きウサギの群と左向きウサギの群が向かい合っている部分に着目する. すなわち, `RR.R..LLL.L` のような状態を考える. 列にこのような部分が複数ある場合, それぞれはお互いに干渉しないので部分ごとに最大ジャンプ数を考えればいい.

まずはそれぞれの群の先頭を固定してジャンプできる回数を考える. 右向きウサギが $$ y_1, y_2, \dots $$ (ただし, $$ y_1 \gt y_2 \gt  \dots $$) の位置にいるとすると, 総ジャンプ数は

$$
\sum y_1 - i - y_i
$$

となる. 左向きウサギの総ジャンプ数も同様に計算する.

次に群同士が間のスペースを詰めるようにジャンプできる回数を考える. このときの総ジャンプ数は群のウサギの数が多い方がジャンプした方を大きくなる. そのときの総ジャンプ数は間のスペースの数を $$ s $$, 群のウサギの数を $$ r $$ とすると, $$ sr $$ となる.

なお, 左端のウサギが左向きの場合は端までジャンプすることになるが, このときは $$ x_0 = 0 $$ となるウサギを追加して考えればいい. 右端も同様である.