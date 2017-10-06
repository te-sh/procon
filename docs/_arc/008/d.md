---
number: '008'
problem: D
---
美味しさ $$ r_{i-1} $$ のたこやきを $$ i $$ 番目のタコヤキオイシクナールに入れたときの新しい美味しさ $$ r_i $$ は,

$$
r_i = a_ir_{i-1}+b_i
$$

となる. これを行列で表現すると,

$$
\begin{pmatrix}
r_i \\
1
\end{pmatrix}
=
\begin{pmatrix}
a_i & b_i \\
0 & 1
\end{pmatrix}
\begin{pmatrix}
r_{i-1} \\
1
\end{pmatrix}
$$

となる.

$$
A_i =
\begin{pmatrix}
a_i & b_i \\
0 & 1
\end{pmatrix}
\\
\boldsymbol{r}_i =
\begin{pmatrix}
r_i \\
1
\end{pmatrix}
$$

とおくと,

$$
\boldsymbol{r}_N = A_{N-1}A_{N-2}\cdots A_1\boldsymbol{r}_0
$$

となる.

$$ A_i $$ を総乗を計算するセグメント木に突っ込んでおくことで, $$ A_i $$ のどれかひとつに更新がおきても総乗の計算は $$ O(\log N) $$ で行うことができる.

なお, $$ N $$ が大きいが, 変更されないタコヤキオイシクナールは関係ないので, クエリ先読み&座標圧縮で変更されないタコヤキオイシクナールを無視すれば $$ N $$ は $$ M $$ のオーダーとなる.
