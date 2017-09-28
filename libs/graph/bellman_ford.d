template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  const inf = _inf, sent = _sent;

  struct Edge
  {
    Node src, dst;
    Wt wt;
  }

  Wt[] bellmanFord(Edge[][] g, Node s)
  {
    Wt[] dist;
    Node[] prev;
    bellmanFord(g, s, dist, prev);
    return dist;
  }

  void bellmanFord(Edge[][] g, Node s, out Wt[] dist, out Node[] prev)
  {
    auto n = g.length;

    dist = new Wt[](n);
    dist[] = inf + inf;
    dist[s] = 0;

    prev = new Node[](n);
    prev[] = sent;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (e; g[i])
          if (dist[e.dst] > dist[e.src] + e.wt) {
            dist[e.dst] = dist[e.src] + e.wt;
            prev[e.dst] = e.src;
            if (k == n-1) dist[e.dst] = -inf;
          }
  }
}

unittest
{
  alias graph = Graph!(int, size_t);
  alias Edge = graph.Edge;

  auto g = new Edge[][](9);
  g[0] = [Edge(0, 1, 5), Edge(0, 2, 4)];
  g[1] = [Edge(1, 2, -2), Edge(1, 3, 1)];
  g[2] = [Edge(2, 4, 1), Edge(2, 5, 4)];
  g[3] = [Edge(3, 5, 3), Edge(3, 6, -1)];
  g[4] = [Edge(4, 5, 4)];
  g[5] = [];
  g[6] = [Edge(6, 7, -1)];
  g[7] = [Edge(7, 8, -1)];
  g[8] = [Edge(8, 6, -1)];

  auto dist = graph.bellmanFord(g, 0);
  assert(dist[1] == 5);
  assert(dist[2] == 3);
  assert(dist[5] == 7);
  assert(dist[6] <= -graph.inf);
}
