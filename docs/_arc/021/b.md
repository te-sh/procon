---
number: '021'
problem: B
---
$$ A_1 \oplus A_2 = B_1, A_2 \oplus A_3 = B_2, \dots, A_{L-1} \oplus A_L = B_{L-1} $$ を左辺同士, 右辺同士それぞれ排他的論理和を取ると, $$ A_1 \oplus A_L = B_1 \oplus B_2 \oplus \cdots \oplus B_{L-1} $$ となる.

$$ A_1 \oplus A_L = B_L $$ なので, $$ B_1 \oplus B_2 \oplus \cdots \oplus B_{L-1} \neq B_L $$ ならば問題に矛盾があるので答えは存在しない.

あとは $$ A_1 = 0 $$ として, $$ A_2 = B_1 \oplus A_1, A_3 = B_2 \oplus A_2 $$ と芋づる式に求めていけばいい. $$ A_1 = 0 $$ とすれば辞書順最小は保証される.
