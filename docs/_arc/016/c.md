---
number: '016'
problem: C
---
$$ E(T) $$ を, 必要な残りのアイドルの集合 $$ T $$ からコンプリートまでの必要な金額の期待値とする.

このとき, くじ $$ i $$ を引いたとすると,

$$
E(T) = cost_i + \sum_{j \in T} E(T \setminus j)q_{i,j} + E(T)\left(1-\sum_{j \in T} q_{i,j}\right)
$$

となる. ただし $$ q_{i, j} $$ は $$ i $$ 番目のくじをひいたときにアイドル $$ j $$ を引く確率である.

これを解いて,

$$
E(T) = \left( cost_i + \sum_{j \in T} E(T \setminus j)q_{i, j} \right) \frac{1}{ \sum_{j \in T} q_{i, j} }
$$

となる. ただし, $$ \sum q_{i,j} = 0 $$ となるくじは引いても意味がないので引かない.

この期待値をくじごとに計算して, 最も $$ E(T) $$ が少ないくじをひく.

これを順に計算していって, $$ E(S) $$ ($$ S $$ はすべてのアイドルの集合) を求める.
