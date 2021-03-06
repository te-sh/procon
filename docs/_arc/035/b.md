---
number: '035'
problem: B
---
解くのにかかる時間が $$ T_1 $$, $$ T_2 $$ の問題があるとき, $$ 1 $$ 番目から先に解いたときのペナルティ $$ S_1 $$ と $$ 2 $$ 番目から先に解いたときのペナルティ $$ S_2 $$ を比較すると,

$$
S_1 = T_1 + (T_1 + T_2) \\
S_2 = T_2 + (T_2 + T_1) \\
S_2 - S_1 = T_2 - T_1
$$

となるので, $$ T_i $$ が小さい順に解くのが最適である.

そして, 小さい順に解くときに同じ時間がかかる問題が複数 ($$ k $$ 個) あるときは, その問題はどの順序で解いてもいいので, $$ k! $$ の組み合わせがある.
