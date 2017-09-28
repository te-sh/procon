template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.algorithm, std.container;

  const inf = _inf, sent = _sent;

  struct Edge { Node src, dst; Wt cap; }
  struct EdgeR { Node src, dst; Wt cap, residue; Node rev; }

  Wt edmondsKarp(Edge[][] g, Node s, Node t)
  {
    auto n = g.length;
    auto adj = withRev(g, n);

    ref auto revE(EdgeR e) { return adj[e.dst][e.rev]; }

    foreach (gi; adj)
      foreach (ref e; gi)
        e.residue = e.cap;

    Wt total;
    auto prev = new Node[](n);

    for (;;) {
      prev[] = sent; --prev[s];

      auto q = new DList!Node(s);
      while (!q.empty && prev[t] == sent) {
        auto u = q.front; q.removeFront();
        foreach (ref e; adj[u])
          if (prev[e.dst] == sent && e.residue > 0) {
            prev[e.dst] = e.rev;
            q.insertBack(e.dst);
          }
      }
      if (prev[t] == sent) break;

      Wt inc = inf;
      for (auto u = t; u != s; u = adj[u][prev[u]].dst)
        inc = min(inc, revE(adj[u][prev[u]]).residue);
      for (auto u = t; u != s; u = adj[u][prev[u]].dst) {
        adj[u][prev[u]].residue += inc;
        revE(adj[u][prev[u]]).residue -= inc;
      }
      total += inc;
    }

    return total;
  }

  EdgeR[][] withRev(Edge[][] g, size_t n)
  {
    auto r = new EdgeR[][](n);

    foreach (gi; g)
      foreach (e; gi) {
        r[e.src] ~= EdgeR(e.src, e.dst, e.cap, 0, r[e.dst].length);
        r[e.dst] ~= EdgeR(e.dst, e.src, 0, 0, r[e.src].length - 1);
      }

    return r;
  }
}

unittest
{
  alias graph = Graph!(int, size_t);
  alias Edge = graph.Edge;

  auto g = new Edge[][](5);
  g[0] = [Edge(0, 1, 5), Edge(0, 2, 2), Edge(0, 3, 8)];
  g[1] = [Edge(1, 2, 3), Edge(1, 4, 4)];
  g[2] = [Edge(2, 3, 4), Edge(2, 4, 4)];
  g[3] = [Edge(3, 4, 6)];

  auto d = graph.edmondsKarp(g, 0, 4);
  assert(d == 13);
}
