import graph;

template EdmondsKarp(Graph)
{
  import std.algorithm, std.container, std.traits;
  alias Node = TemplateArgsOf!Graph[0], Wt = TemplateArgsOf!Graph[1];

  struct EdgeR { Node src, dst; Wt cap, residue; Node rev; }

  Wt edmondsKarp(ref Graph g, Node s, Node t)
  {
    auto n = g.n, sent = n, adj = withRev(g, n);

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

      Wt inc = g.inf;
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

  EdgeR[][] withRev(ref Graph g, Node n)
  {
    auto r = new EdgeR[][](n);

    foreach (gi; g)
      foreach (e; gi) {
        r[e.src] ~= EdgeR(e.src, e.dst, e.cap, 0, cast(Node)(r[e.dst].length));
        r[e.dst] ~= EdgeR(e.dst, e.src, 0, 0, cast(Node)(r[e.src].length) - 1);
      }

    return r;
  }
}

unittest
{
  auto g = GraphW!int(5);
  g.addEdge(0, 1, 5); g.addEdge(0, 2, 2); g.addEdge(0, 3, 8);
  g.addEdge(1, 2, 3); g.addEdge(1, 4, 4);
  g.addEdge(2, 3, 4); g.addEdge(2, 4, 4);
  g.addEdge(3, 4, 6);

  auto d = EdmondsKarp!(typeof(g)).edmondsKarp(g, 0, 4);
  assert(d == 13);
}
