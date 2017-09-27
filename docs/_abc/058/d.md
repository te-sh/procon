---
number: '058'
problem: D
problem_path: arc071_b
---
愚直に計算すると $$ O(n^2m^2) $$ で全然間に合わない.

長方形の面積の和は,

$$
\left(\sum X_i\right) \left(\sum Y_i\right)
$$

となる. ただし, $$ \{ X_i \} $$ は $$ x_j - x_i $$ ($$ i \lt j $$) をすべて集めた集合であり, $$ \{ Y_i \} $$ も同様である.

このとき, 最初の $$ k $$ 個の $$ x_i $$ から2つ取ってできる差の集合の和を $$ S_X(k) $$ とすると,

$$
\begin{align}
S_X(k+1) &= S_X(k) + \sum_{i=1}^k(x_{k+1} - x_i) \\
         &= S_X(k) + kx_{k+1} - \sum_{i=1}^kx_i
\end{align}
$$

となる. $$ \sum x_i $$ の部分は累積和をあらかじめ計算しておく. $$ S_Y(k) $$ も同様の式となる.

DP で $$ S_X(n), S_Y(m) $$ を求め, $$ S_X(n)S_Y(m) $$ が答えとなる.
