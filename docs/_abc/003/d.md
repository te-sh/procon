---
number: '003'
problem: D
---
パターン数は囲いの位置のパターン数と囲い内での配置のパターン数の積となる.

囲いの位置のパターン数は $$ (R-X+1)(C-Y+1) $$ である.

囲い内での配置のパターン数であるが、部分点の解は $$ {}_{XY}C_{D} $$ となる.

満点の解は包除原理を使う.

まず端にデスク/サーバラックがあるかどうかを考えない配置の数を求める. これは $$ {}_{XY}C_D \cdot {}_{XY-D}C_L $$ となる.

ここから上下左右端にデスク/サーバラックがないパターン数を引く. 上下左右の端にデスク/サーバがない事象をそれぞれ $$ F_t, F_b, F_l, F_r $$ とすると, 包除原理より,

$$
\begin{align}
& \vert F_t \cup F_b \cup F_l \cup F_r \vert = \\
& \qquad \vert F_t \vert + \vert F_b \vert + \vert F_l \vert + \vert F_r \vert \\
& \qquad - (\vert F_t \cap F_b \vert + \vert F_t \cap F_l \vert + \vert F_t \cap F_r \vert + \vert F_b \cap F_l \vert + \vert F_b \cap F_l \vert + \vert F_l \cap F_r \vert) \\
& \qquad + (\vert F_t \cap F_b \cap F_l \vert + \vert F_t \cap F_b \cap F_r \vert + \vert F_t \cap F_r \cap F_l \vert + \vert F_b \cap F_l \cap F_r \vert) \\
& \qquad - \vert F_t \cap F_b \cap F_l \cap F_r \vert
\end{align}
$$

となる.

なお, $$ {}_nC_r $$ の計算はパスカルの三角形でもいいし, 直接計算して割り算で逆元を使うやり方でもいい.
