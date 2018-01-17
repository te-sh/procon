import graph;

template Dinic(Graph)
{
  import std.algorithm, std.container, std.traits;
  alias Node = TemplateArgsOf!Graph[0], Wt = TemplateArgsOf!Graph[1];

  struct EdgeR { Node src, dst; Wt cap, flow; Node rev; }

  Wt dinic(ref Graph g, Node s, Node t)
  {
    auto n = g.n, adj = withRev(g, n), level = new int[](n);

    auto levelize()
    {
      level[] = -1; level[s] = 0;

      auto q = DList!Node(s);
      while (!q.empty) {
        auto u = q.front; q.removeFront();
        if (u == t) break;
        foreach (ref e; adj[u])
          if (e.cap > e.flow && level[e.dst] < 0) {
            q.insertBack(e.dst);
            level[e.dst] = level[u] + 1;
          }
      }

      return level[t];
    }

    Wt augment(Node u, Wt cur)
    {
      if (u == t) return cur;

      foreach (ref e; adj[u]) {
        auto r = &adj[e.dst][e.rev];
        if (e.cap > e.flow && level[u] < level[e.dst]) {
          auto f = augment(e.dst, min(cur, e.cap - e.flow));
          if (f > 0) {
            e.flow += f;
            r.flow -= f;
            return f;
          }
        }
      }

      return 0;
    }

    Wt flow = 0, f = 0;

    while (levelize >= 0)
      while ((f = augment(s, g.inf)) > 0)
        flow += f;

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

  auto d = Dinic!(typeof(g)).dinic(g, 0, 4);
  assert(d == 13);
}
