---
number: '024'
problem: D
---
$$ (r, c) $$ のマスに書かれているのは $$ {}_{r+c}C_r $$ である. ここで,

$$
\begin{align}
\frac{B}{A} &= \frac{ {}_{r+(c+1)}C_r }{ {}_{r+c}C_r } = \frac{(r+c+1)!}{r!(c+1)!} \cdot \frac{r!c!}{(r+c)!} = \frac{r+c+1}{c+1} \\
\frac{C}{A} &= \frac{ {}_{(r+1)+c}C_{r+1} }{ {}_{r+c}C_r } = \frac{(r+c+1)!}{(r+1)!c!} \cdot \frac{r!c!}{(r+c)!} = \frac{r+c+1}{r+1}
\end{align}
$$

となる. これを整理して

$$
\begin{align}
Ar+(A-B)c+A-B &= 0 \\
(A-C)r+Ac+A-C &= 0
\end{align}
$$

となり, これを解いて,

$$
\begin{align}
c &= \frac{B(A-C)}{BC-(B+C)A} \\
r &= \frac{C(A-B)}{BC-(B+C)A}
\end{align}
$$

となる. なお計算は法を $$ 10^9+7 $$ とする剰余環上で行う. すなわち, 割り算は逆元を使う.
