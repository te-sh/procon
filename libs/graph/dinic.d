template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.algorithm, std.container, std.conv;

  const inf = _inf, sent = _sent;

  struct Edge { Node src, dst; Wt cap; }
  struct EdgeR { Node src, dst; Wt cap, flow; Node rev; }

  Wt dinic(Edge[][] g, Node s, Node t)
  {
    auto n = g.length;
    auto adj = withRev(g, n);

    auto level = new int[](n);

    auto levelize()
    {
      level[] = -1; level[s] = 0;

      auto q = new DList!Node(s);
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
        auto r = adj[e.dst][e.rev];
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

    Wt flow, f;

    while (levelize >= 0)
      while ((f = augment(s, inf)) > 0)
        flow += f;

    return flow;
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
  alias Graph!(int, size_t) graph;
  alias graph.Edge Edge;

  auto g = new Edge[][](5);
  g[0] = [Edge(0, 1, 5), Edge(0, 2, 2), Edge(0, 3, 8)];
  g[1] = [Edge(1, 2, 3), Edge(1, 4, 4)];
  g[2] = [Edge(2, 3, 4), Edge(2, 4, 4)];
  g[3] = [Edge(3, 4, 6)];

  auto d = graph.dinic(g, 0, 4);
  assert(d == 13);
}
