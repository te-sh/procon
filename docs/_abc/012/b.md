---
number: '012'
problem: B
---
時分秒を $$ h, m, s $$ とすると,

$$
\begin{align}
h = N / 3600 \\
m = (N \% 3600) / 60 \\
s = N \% 60
\end{align}
$$

で求められる. ただし割り算は小数点以下切り捨てである.
