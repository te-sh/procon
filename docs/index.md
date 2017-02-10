---
layout: default
---
[yukicoder](http://yukicoder.me) の問題を解いたときのメモです。

分からなかった問題は解説を読みながら読みながら書いてますので、その解説を丸パクリしてるようなメモもあると思いますが、問題があるようであれば issue に登録してください。

{% for i in (1..5) %}{% for j in (1..10) %}{% assign no = i | minus: 1 | times: 10 | plus: j %}{% assign title = "No." | append: no %}{% assign doc = site.collections[0].docs | where: "title": title %}|{% if doc[0] %}[{{ title }}]({{ site.baseurl }}{{ doc[0].url }}){% else %}{{ title }}{% endif %}|{% endfor %}
{% endfor %}
