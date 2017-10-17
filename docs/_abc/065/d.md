---
number: '065'
problem: D
problem_path: arc076_b
---
一次元で考えると, $$ x_1 \leq x_2 \leq x_3 $$ の町があれば, $$ x_1 $$ と $$ x_2 $$, $$ x_2 $$ と $$ x_3 $$ をつなげればいいので,  $$ x_1 $$ と $$ x_3 $$ はつなげる必要がない. よって, ソートして隣同士をつなげていくのが最も効率的である.

これを二次元に拡張して, 町を $$ x $$ 座標でソートし, 隣り合う町同士の距離を求める. $$ y $$ 座標でも同様にソートして隣り合う町同士の距離を求める.

この隣り合う町同士の距離をソートして短い順に Union-Find でつなげていく. ただし, すでに同じ森に所属しているならつなげない.

すべての町がつながった (森がひとつになった) ときのつなげたコストの和が答えである.