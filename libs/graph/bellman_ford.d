struct Graph(Wt, Node = int, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  const inf = _inf, sent = _sent;

  struct Edge { Node src, dst; Wt wt; }

  Edge[][] g;

  this(size_t n) { g = new Edge[][](n); }
  auto addEdge(Node src, Node dst, Wt wt) { g[src] ~= Edge(src, dst, wt); }

  Wt[] bellmanFord(Node s)
  {
    Wt[] dist;
    Node[] prev;
    bellmanFord(s, dist, prev);
    return dist;
  }

  void bellmanFord(Node s, out Wt[] dist, out Node[] prev)
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
  auto g = Graph!int(9);
  g.addEdge(0, 1, 5); g.addEdge(0, 2, 4);
  g.addEdge(1, 2, -2); g.addEdge(1, 3, 1);
  g.addEdge(2, 4, 1); g.addEdge(2, 5, 4);
  g.addEdge(3, 5, 3); g.addEdge(3, 6, -1);
  g.addEdge(4, 5, 4);
  g.addEdge(6, 7, -1);
  g.addEdge(7, 8, -1);
  g.addEdge(8, 6, -1);

  auto dist = g.bellmanFord(0);
  assert(dist[1] == 5);
  assert(dist[2] == 3);
  assert(dist[5] == 7);
  assert(dist[6] <= -g.inf);
}
