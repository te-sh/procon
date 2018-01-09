---
number: '084'
problem: C
---
駅 $$ i $$ に時刻 $$ t $$ にいるとすると, 一番早く乗れる列車の出発時刻は

$$
T_i = \max(S_i, \lceil t/F_i \rceil \times F_i)
$$

であり, このとき, 次の駅には $$ T_i + C_i $$ に到着する.

これを順に計算していく.
