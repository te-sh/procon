import graph;

template Dijkstra(Graph)
{
  import std.array, std.container, std.traits;
  alias Node = TemplateArgsOf!Graph[0], Wt = TemplateArgsOf!Graph[1];
  alias Edge = Graph.Edge;

  void dijkstra(Graph g, Node s, out Wt[] dist, out Node[] prev)
  {
    auto n = g.n, sent = n;

    dist = new Wt[](n);
    dist[] = g.inf;
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

  auto dijkstra(Graph g, Node s)
  {
    Wt[] dist;
    Node[] prev;
    dijkstra(g, s, dist, prev);
    return dist;
  }
}

unittest
{
  auto g = GraphW!int(6);
  g.addEdge(0, 1, 5); g.addEdge(0, 2, 4); g.addEdge(0, 3, 2);
  g.addEdge(1, 0, 5); g.addEdge(1, 2, 2); g.addEdge(1, 4, 6);
  g.addEdge(2, 0, 4); g.addEdge(2, 1, 2); g.addEdge(2, 3, 3); g.addEdge(2, 5, 2);
  g.addEdge(3, 0, 2); g.addEdge(3, 5, 6);
  g.addEdge(4, 1, 6); g.addEdge(4, 5, 4);
  g.addEdge(5, 2, 2); g.addEdge(5, 3, 6); g.addEdge(5, 4, 4);

  auto dist = Dijkstra!(typeof(g)).dijkstra(g, 0);

  assert(dist[4] == 10);
  assert(dist[5] == 6);
}
