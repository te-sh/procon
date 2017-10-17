---
number: '070'
problem: C
---
$$ t_i $$ の最小公倍数を出力する.

最小公倍数は $$ t_1, t_2 $$ の最小公倍数を計算し, その結果と $$ t_3 $$ の最小公倍数を計算し…というのを繰り返す.

なお, $$ a, b $$ の最大公約数を $$ g $$ とする (D言語には `gcd` 関数がある) と, 最小公倍数は $$ ab/g $$ である. オーバーフローを避けるためには $$ a \div g \times b $$ の計算順序で計算すればいい.