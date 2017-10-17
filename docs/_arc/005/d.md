---
number: '005'
problem: D
---
$$ i $$ 個の使える数字の和が $$ j $$ となる数字の組み合わせのうちのひとつを DP を使って求めておく. このとき, 0 が使えるならばなるべく多くの 0 を使うように求める.

数字は最大で9個足せばいいので, 9個の数字を決定する. (0 も含む)

$$ i $$ を固定して下の桁から目的の数字にできる組み合わせについて, 次の桁以降の最小の長さをメモ化再帰で求める. 下の桁がたとえば 1 ならば, 足して 1, 11, 21, ... になる組み合わせごとにこれを計算し, 最小の長さを返す.