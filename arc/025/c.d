import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(int, int);
alias edge = graph.Edge;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1], r = rd[2], t = rd[3];
  auto g = new edge[][](n);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int-1; rd2.popFront();
    auto b = rd2.front.to!int-1; rd2.popFront();
    auto c = rd2.front.to!int;
    g[a] ~= edge(a, b, c);
    g[b] ~= edge(b, a, c);
  }

  auto ans = 0L;
  foreach (a; 0..n) {
    auto d = graph.dijkstra(g, a);

    auto dr = d.dup;
    dr[] *= t;
    auto drs = dr.sort();

    foreach (b; 0..n) {
      if (a == b) continue;
      auto c = drs.upperBound(d[b] * r).length;
      if (r < t)
        ans += max(c-1, 0);
      else
        ans += c;
    }
  }

  writeln(ans);
}

template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.container;

  const inf = _inf, sent = _sent;

  struct Edge
  {
    Node src, dst;
    Wt wt;
  }

  Wt[] dijkstra(Edge[][] g, Node s)
  {
    Wt[] dist;
    Node[] prev;
    dijkstra(g, s, dist, prev);
    return dist;
  }

  void dijkstra(Edge[][] g, Node s, out Wt[] dist, out Node[] prev)
  {
    auto n = g.length;

    dist = new Wt[](n);
    dist[] = inf;
    dist[s] = 0;

    prev = new Node[](n);
    prev[] = sent;

    auto q = heapify!("a.wt > b.wt")(Array!Edge(Edge(sent, s, 0)));
    while (!q.empty) {
      auto e = q.front; q.removeFront();
      if (prev[e.dst] != sent) continue;
      prev[e.dst] = e.src;
      foreach (f; g[e.dst]) {
        auto w = e.wt + f.wt;
        if (dist[f.dst] > w) {
          dist[f.dst] = w;
          q.insert(Edge(f.src, f.dst, w));
        }
      }
    }
  }
}
