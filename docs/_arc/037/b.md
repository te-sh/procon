---
number: '037'
problem: B
---
Union-Find でつないでいき, すでに同じ森に所属している辺をよけておく.

すべての辺を見た後, 連結となっている森の代表頂点を `true` としておいて, よけておいた辺について代表頂点を `false` に変える.

`true` となっている代表頂点の数が答えである.
