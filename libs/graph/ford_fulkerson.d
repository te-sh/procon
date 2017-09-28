template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.algorithm, std.container, std.conv;

  const inf = _inf, sent = _sent;

  struct Edge { Node src, dst; Wt cap; }
  struct EdgeR { Node src, dst; Wt cap, flow; Node rev; }

  Wt fordFulkerson(Edge[][] g, Node s, Node t)
  {
    auto n = g.length;
    auto adj = withRev(g, n);

    auto visited = new bool[](n);

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
      auto f = augment(s, inf);
      if (f == 0) break;
      flow += f;
    }

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
  alias graph = Graph!(int, size_t);
  alias Edge = graph.Edge;

  auto g = new Edge[][](5);
  g[0] = [Edge(0, 1, 5), Edge(0, 2, 2), Edge(0, 3, 8)];
  g[1] = [Edge(1, 2, 3), Edge(1, 4, 4)];
  g[2] = [Edge(2, 3, 4), Edge(2, 4, 4)];
  g[3] = [Edge(3, 4, 6)];

  auto d = graph.fordFulkerson(g, 0, 4);
  assert(d == 13);
}
