import graph;

template FordFulkerson(Graph)
{
  import std.algorithm, std.container, std.traits;
  alias Node = TemplateArgsOf!Graph[0], Wt = TemplateArgsOf!Graph[1];

  struct EdgeR { Node src, dst; Wt cap, flow; Node rev; }

  Wt fordFulkerson(ref Graph g, Node s, Node t)
  {
    auto n = g.n, adj = withRev(g, n), visited = new bool[](n);

    Wt augment(Node u, Wt cur)
    {
      if (u == t) return cur;
      visited[u] = true;
      foreach (ref e; adj[u]) {
        if (!visited[e.dst] && e.cap > e.flow) {
          auto f = augment(e.dst, min(e.cap - e.flow, cur));
          if (f > 0) {
            e.flow += f;
            adj[e.dst][e.rev].flow -= f;
            return f;
          }
        }
      }
      return 0;
    }

    Wt flow;

    for (;;) {
      visited[] = false;
      auto f = augment(s, g.inf);
      if (f == 0) break;
      flow += f;
    }

    return flow;
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

  auto d = FordFulkerson!(typeof(g)).fordFulkerson(g, 0, 4);
  assert(d == 13);
}
