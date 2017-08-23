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
    dist[1..$][] = inf;

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

unittest
{
  alias Graph!(int, size_t) graph;
  alias graph.Edge Edge;

  auto g = new Edge[][](6);
  g[0] = [Edge(0, 1, 5), Edge(0, 2, 4), Edge(0, 3, 2)];
  g[1] = [Edge(1, 0, 5), Edge(1, 2, 2), Edge(1, 4, 6)];
  g[2] = [Edge(2, 0, 4), Edge(2, 1, 2), Edge(2, 3, 3), Edge(2, 5, 2)];
  g[3] = [Edge(3, 0, 2), Edge(3, 5, 6)];
  g[4] = [Edge(4, 1, 6), Edge(4, 5, 4)];
  g[5] = [Edge(5, 2, 2), Edge(5, 3, 6), Edge(5, 4, 4)];

  auto dist = graph.dijkstra(g, 0);

  assert(dist[4] == 10);
  assert(dist[5] == 6);
}
