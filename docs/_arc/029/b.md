---
number: '029'
problem: B
---
左下を原点, 右上を $$ (A, B) $$ となるように配置し, 反時計周りに角度 $$ \theta $$ ($$ 0 \leq \theta \leq \pi/2 $$) だけ回転させたとする.

このときの幅 $$ w $$ と高さは $$ h $$ は以下の通りである.

$$
\begin{align}
w &= A\cos\theta + B\sin\theta \\
h &= \sqrt{A^2+B^2}\sin(\theta + \alpha)
\end{align}
$$

ただし,

$$
\tan\alpha = \frac{B}{A}
$$

である.

$$ w $$ を加法定理を使ってまとめると,

$$
w = \sqrt{A^2+B^2} \sin(\theta + \beta)
$$

となる. ただし,

$$
\tan\beta = \frac{A}{B}
$$

である.

$$ w \leq C $$ かつ $$ h \leq D $$ となる $$ \theta $$ が存在するならノートを収めることができる. 逆に考えると, $$ w \gt C $$ または $$ h \gt d $$ ならばノートを収めることができない.

ノートを収めることができない $$ \theta $$ の範囲が $$ 0 \leq \theta \leq \pi/2 $$ をすべて覆っているならば, この箱にノートを収めることができる角度がないことになる.

まずは $$ c = C/\sqrt{A^2+B^2} $$ とすると,

$$ c \geq 1 $$ のとき: $$ \theta $$ 存在しない

$$ c \lt 1 $$ のとき: $$ \sin^{-1}c - \beta \leq \theta \leq \pi - \sin^{-1}c - \beta $$

同様に $$ d = D/sqrt{A^2+B^2} $$ とすると,

$$ d \geq 1 $$ のとき: $$ \theta $$ は存在しない

$$ d \lt 1 $$ のとき: $$ \sin^{-1}d - \alpha \leq \theta \leq \pi - \sin^{-1}d - \alpha $$

よって, ノートを収める角度がある条件は,

* $$ \min(\sin^{-1}c - \beta, \sin^{-1}d - \alpha) \leq 0 $$
* $$ \max(\pi - \sin^{-1}c - \beta, \pi - \sin^{-1}d - \alpha) \leq \pi/2 $$
* $$ \pi - \sin^{-1}c - \beta \leq \sin^{-1}d - \alpha $$
* $$ \pi - \sin^{-1}d - \alpha \leq \sin^{-1}c - \beta $$

のいずれかが成り立つことである.
