---
number: '060'
problem: D
problem_path: arc073_b
---
ナップザック問題であるが, $$ w_i, v_i $$ が大きい. しかし, $$ w_i $$ はすべて似た値である.

そこで, $$ w^{\prime}_i = w_i - w_1 $$ とする.

そして, $$ i $$ 番目の荷物まで見たとき, $$ j $$ 個の荷物を入れて重さ ($$ w^{\prime}_i $$) の合計が $$ k $$ となるときの最大価値を $$ V(i, j, k) $$ として,

$$
V(i+1, j, k) = \max(V(i, j, k), V(i, j-1, k-w^{\prime}_k)+v_k)
$$

の DP を計算する.

そして, $$ \max_{k + jw_1 \leq W} V(n, j, k) $$ を計算する.
