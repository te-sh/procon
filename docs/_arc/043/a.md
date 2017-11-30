---
number: '043'
problem: A
---
最大と最小の差が $$ B $$ になる. この変換によって最大と最小の組は変わらないので,

$$
P \vert \max S_i - \min S_i \vert = B
$$

となり,

$$
P = \frac{B}{\vert \max S_i - \min S_i \vert}
$$

である. ただし, $$ \vert \max S_i - \min S_i \vert = 0 $$ のときは解がない.

$$ Q $$ は平均が $$ A $$ になることから,

$$
\frac{\sum(PS_i+Q)}{N} = A
$$

となり,

$$
Q = A - \frac{P\sum S_i}{N}
$$

となる.
