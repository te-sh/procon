---
number: '007'
problem: D
---
$$ n $$ 未満の数の中に4または9が含まれるパターンの数を $$ C(n) $$ とすると, 求める数は $$ C(B+1)-C(A) $$ となる.

$$ C(n) $$ は桁DPを使って求める.

キーとして何桁目か, 最大値未満か, 4か9が含まれているかを取り, 値としてパターンの数を取る桁DPを行う.
