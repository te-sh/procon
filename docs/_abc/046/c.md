---
number: '046'
problem: C
problem_path: arc062_a
---
$$ i $$ 回目の速報時での高橋くんと青木くんの得票はそれぞれ $$ k_iT_i, k_iA_i $$ となる. これは $$ T_i, A_i $$ が互いに素という制約があるからである. こうなる最小の $$ k_i $$ は $$ k_i = \max(\lceil k_{i-1}T_{i-1}/T_i \rceil, \lceil k_{i-1}A_{i-1}/A_i \rceil) $$ で求められる.
