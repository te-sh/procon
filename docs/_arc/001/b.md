---
number: '001'
problem: B
---
$$ A \leq B $$ としても一般性を失わない. $$ C = B-A $$ とする.

$$ C $$ を10で割った余りが0ならば, 残りは $$ C/10 $$ 回10度上げればいいので, $$ C $$ を10で割った余りの温度を上げるのに必要な操作回数を考えると下表のようになる.

<table class="table table-bordered">
  <tr>
    <td>0</td>
    <td>0回</td>
    <td>操作の必要はない</td>
  </tr>
  <tr>
    <td>1</td>
    <td>1回</td>
    <td>1回1度上げる</td>
  </tr>
  <tr>
    <td>2</td>
    <td>2回</td>
    <td>2回1度上げる</td>
  </tr>
  <tr>
    <td>3</td>
    <td>3回</td>
    <td>3回1度上げるか, 2回1度下げて1回5度上げる</td>
  </tr>
  <tr>
    <td>4</td>
    <td>2回</td>
    <td>1回1度下げて1回5度上げる</td>
  </tr>
  <tr>
    <td>5</td>
    <td>1回</td>
    <td>1回5度上げる</td>
  </tr>
  <tr>
    <td>6</td>
    <td>2回</td>
    <td>1回1度上げて1回5度上げる</td>
  </tr>
  <tr>
    <td>7</td>
    <td>3回</td>
    <td>2回1度上げて1回5度上げる</td>
  </tr>
  <tr>
    <td>8</td>
    <td>3回</td>
    <td>2回1度下げて1回10度上げる</td>
  </tr>
  <tr>
    <td>9</td>
    <td>2回</td>
    <td>1回1度下げて1回10度上げる</td>
  </tr>
</table>
