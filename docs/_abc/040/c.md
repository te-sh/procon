---
number: '040'
problem: C
---
$$ i $$ 番目の柱まで進むときの最小コストを $$ C(i) $$ とすると,

$$
C(i) = \min(C(i-2) + \vert a_i - a_{i-2} \vert, C(i-1) + \vert a_i - a_{i-1})
$$

となり, これを DP で解く.
