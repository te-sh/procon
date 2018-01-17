import graph;

template BellmanFord(Graph)
{
  import std.traits;
  alias Node = TemplateArgsOf!Graph[0], Wt = TemplateArgsOf!Graph[1];

  void bellmanFord(ref Graph g, Node s, out Wt[] dist, out Node[] prev)
  {
    auto n = g.n, sent = n;

    dist = new Wt[](n);
    dist[] = g.inf + g.inf;
    dist[s] = 0;

    prev = new Node[](n);
    prev[] = sent;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (e; g[i])
          if (dist[e.dst] > dist[e.src] + e.wt) {
            dist[e.dst] = dist[e.src] + e.wt;
            prev[e.dst] = e.src;
            if (k == n-1) dist[e.dst] = -g.inf;
          }
  }

  Wt[] bellmanFord(ref Graph g, Node s)
  {
    Wt[] dist;
    Node[] prev;
    bellmanFord(g, s, dist, prev);
    return dist;
  }
}

unittest
{
  auto g = GraphW!int(9);
  g.addEdge(0, 1, 5); g.addEdge(0, 2, 4);
  g.addEdge(1, 2, -2); g.addEdge(1, 3, 1);
  g.addEdge(2, 4, 1); g.addEdge(2, 5, 4);
  g.addEdge(3, 5, 3); g.addEdge(3, 6, -1);
  g.addEdge(4, 5, 4);
  g.addEdge(6, 7, -1);
  g.addEdge(7, 8, -1);
  g.addEdge(8, 6, -1);

  auto dist = BellmanFord!(typeof(g)).bellmanFord(g, 0);
  assert(dist[1] == 5);
  assert(dist[2] == 3);
  assert(dist[5] == 7);
  assert(dist[6] <= -g.inf);
}
