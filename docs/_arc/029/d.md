---
number: '029'
problem: D
---
※ コードは `WA` が取れてない

後で捨てられる数字を置く意味はない. よって, $$ M $$ 個の数字の中で最後の状態で木に何個残るようにするかを考える. この数を $$ k $$ とすると, 残す数字は明らかに上位 $$ k $$ 個を選ぶのが最適である. そして $$ k $$ 個を木に残すようにするやり方は必ずあるので, 入れる順番は考えなくてもいい.

また, $$ k $$ 個数字を木に残すということは, 木からはすでにある数字から $$ k $$ 個が捨てられるということである. 捨てる数字は $$ k = 1 $$ ならば1番の木で決まりである. $$ k = 2 $$ ならば1番の木と, それにつながっている木のどれかであり, その中の最小の数字を捨てるのが最適である.

このように1番の木から連結になるように $$ k $$ 個の数字をその合計が最小になるように選ぶのが最適な捨て方となる.

$$ i $$ 番の木とその子孫から $$ j $$ 個を連結になるように選んだときの合計の最小値を $$ C(i, j) $$ としてこれを番号の大きい木から順番に更新していく.

このとき, $$ j $$ の最大値は $$ i $$ 番の木の自分を含む子孫の数であり, ここで枝刈りをしておかないと間に合わなくなる.

最後に $$ k $$ を $$ 0 \dots N $$ の範囲で動かして, 木に残る合計数値の最大値を求める.