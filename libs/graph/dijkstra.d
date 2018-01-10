struct Graph(Wt, Node = int, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.container;

  const inf = _inf, sent = _sent;

  struct Edge { Node src, dst; Wt wt; }
  Edge[][] g;

  this(size_t n) { g = new Edge[][](n); }
  void addEdge(Node src, Node dst, Wt wt) { g[src] ~= Edge(src, dst, wt); }
  void addEdgeB(Node src, Node dst, Wt wt) { g[src] ~= Edge(src, dst, wt); g[dst] ~= Edge(dst, src, wt); }

  Wt[] dijkstra(Node s)
  {
    Wt[] dist;
    Node[] prev;
    dijkstra(s, dist, prev);
    return dist;
  }

  void dijkstra(Node s, out Wt[] dist, out Node[] prev)
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

unittest
{
  auto g = Graph!(int)(6);
  g.addEdge(0, 1, 5); g.addEdge(0, 2, 4); g.addEdge(0, 3, 2);
  g.addEdge(1, 0, 5); g.addEdge(1, 2, 2); g.addEdge(1, 4, 6);
  g.addEdge(2, 0, 4); g.addEdge(2, 1, 2); g.addEdge(2, 3, 3); g.addEdge(2, 5, 2);
  g.addEdge(3, 0, 2); g.addEdge(3, 5, 6);
  g.addEdge(4, 1, 6); g.addEdge(4, 5, 4);
  g.addEdge(5, 2, 2); g.addEdge(5, 3, 6); g.addEdge(5, 4, 4);

  auto dist = g.dijkstra(0);

  assert(dist[4] == 10);
  assert(dist[5] == 6);
}
