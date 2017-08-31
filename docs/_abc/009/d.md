---
number: '009'
problem: D
---
$$ M \leq K $$ の場合は $$ A_K $$ をそのまま出力する.

そうでない場合は, まず加法を `XOR`, 乗法を `AND` とする半環で考える. 乗法の単位元は $$ u = 2^{32}-1 $$ である.

この半環上では漸化式は以下のようになる.

$$
A_{N+K} = C_1A_{N+K-1} + C_2A_{N+K-2} + \cdots + C_KA_N
$$

$$ M $$ が大きく順に計算していく方法では間に合わないので, コンパニオン行列を使う.

$$
B_N =
\left(
\begin{array}{c}
A_{N+K} \\
A_{N+K-1} \\
\vdots \\
A_N
\end{array}
\right)
$$

$$
S =
\left(
\begin{array}{cccc}
C_1 & C_2 & \dots & C_K \\
u   &     &       &     \\
    & \ddots &    &     \\
	&     & u     &
\end{array}
\right)
$$

とすると,

$$
B_{N+1} = S B_N
$$

と表せるので, これを繰り返し適用して

$$
B_N = S^NB_0
$$

となる. 後は行列の累乗を繰り返し2乗法で計算する.
