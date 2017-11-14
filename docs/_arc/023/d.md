---
number: '023'
problem: D
---
数列の区間 $$ [i, j+1] $$ の最大公約数は区間 $$ [i, j] $$ の最大公約数と同じか小さく, 小さい場合は $$ 1/2 $$ より小さくなる. すなわち, $$ i $$ を固定したときの最大公約数の種類は, $$ 10^9 \gt 2^{29} $$ であるので高々 $$ 29 $$ 個である. よって, すべての最大公約数の個数も $$ 3 \times 10^6 $$ 個程度に収まる.

最初にすべての最大公約数を計算して区間数を連想配列に入れるようにする.

$$ t $$ を固定して区間 $$ [*, t] $$ で最大公約数が $$ x $$ となる区間の数を $$ B(t, x) $$ とすると,

$$
B(t+1, \gcd(x, A_t)) += B(t, x)
$$

で更新していける.

最後にすべての $$ t $$ について $$ B(t, *) $$ を合成すれば連想配列の完成である.