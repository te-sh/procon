import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(long, size_t, 10L^^18);
alias edge = graph.Edge;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, m = rd1[1].to!size_t, t = rd1[2].to!long;
  auto a = readln.split.to!(long[]);

  auto g1 = new edge[][](n), g2 = new edge[][](n);
  foreach (_; 0..m) {
    auto rd2 = readln.splitter;
    auto u = rd2.front.to!size_t-1; rd2.popFront();
    auto v = rd2.front.to!size_t-1; rd2.popFront();
    auto w = rd2.front.to!long;
    g1[u] ~= edge(u, v, w);
    g2[v] ~= edge(v, u, w);
  }

  auto d1 = graph.dijkstra(g1, 0);
  auto d2 = graph.dijkstra(g2, 0);

  auto ans = 0L;
  foreach (i; 0..n)
    if (d1[i] < graph.inf && d2[i] < graph.inf)
      ans = max(ans, (t - d1[i] - d2[i]) * a[i]);

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

    auto q = heapify!("a.wt > b.wt")(Array!Edge(Edge(sent, s)));
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
