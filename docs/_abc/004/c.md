---
number: '004'
problem: C
---
5回入れ替えを行うと, 一番左のカードは一番右に移動し, 残りのカードはひとつずつ左にずれる. これを6回繰り返すと元のカード配置に戻る.

よって周期30で元に戻るので, $$ N $$ を $$ 30 $$ で割った余りの数だけシミュレーションすればいい.
