template Graph(Wt, Ct, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.algorithm, std.container, std.typecons;

  const inf = _inf, sent = _sent;

  struct Edge { Node src, dst; Wt cap;  Ct cost; }
  struct EdgeR { Node src, dst; Wt cap, flow; Ct cost; Node rev; }
  alias Tuple!(Ct, "cost", Wt, "flow") Cf;

  Cf primalDual(Edge[][] g, Node s, Node t, Wt rest = inf)
  {
    auto n = g.length;
    auto adj = withRev(g, n);

    auto p = new Wt[](n);
    Wt flow;
    Ct cost;

    auto rcost(EdgeR e) { return e.cost + p[e.src] - p[e.dst]; }

    for (;;) {
      auto prev = new Node[](n); prev[] = sent; prev[s] = 0;
      auto dist = new Ct[](n); dist[] = inf; dist[s] = 0;

      struct Cv { Ct cost; Node v; }

      auto q = heapify!("a.cost > b.cost")(Array!Cv(Cv(0, s)));
      while (!q.empty) {
        auto a = q.front(); q.removeFront();
        if (a.v == t) break;
        if (dist[a.v] > a.cost) continue;
        foreach (e; adj[a.v]) {
          if (e.cap > e.flow && dist[e.dst] > a.cost + rcost(e)) {
            dist[e.dst] = dist[e.src] + rcost(e);
            prev[e.dst] = e.rev;
            q.insert(Cv(dist[e.dst], e.dst));
          }
        }
      }
      if (prev[t] == sent) break;

      foreach (u; 0..n)
        if (dist[u] < dist[t])
          p[u] += dist[u] - dist[t];

      Wt augment(Node u, Wt cur) {
        if (u == s) return cur;
        auto r = &adj[u][prev[u]], e = &adj[r.dst][r.rev];
        auto f = augment(e.src, min(e.cap - e.flow, cur));
        e.flow += f;
        r.flow -= f;
        return f;
      }

      auto f = augment(t, rest);
      if (f == 0) break;

      flow += f;
      cost += f * (p[t] - p[s]);
      rest -= f;
    }

    return Cf(cost, flow);
  }

  EdgeR[][] withRev(Edge[][] g, size_t n)
  {
    auto r = new EdgeR[][](n);

    foreach (gi; g)
      foreach (e; gi) {
        r[e.src] ~= EdgeR(e.src, e.dst, e.cap, 0, e.cost, r[e.dst].length);
        r[e.dst] ~= EdgeR(e.dst, e.src, 0, 0, -e.cost, r[e.src].length - 1);
      }

    return r;
  }
}

unittest
{
  alias Graph!(int, int, size_t) graph;
  alias graph.Edge Edge;

  auto g = new Edge[][](6);
  g[0] = [Edge(0, 1, 4, 250), Edge(0, 2, 6, 200)];
  g[1] = [Edge(1, 3, 5, 270)];
  g[2] = [Edge(2, 3, 4, 300), Edge(2, 4, 3, 220)];
  g[3] = [Edge(3, 5, 8, 190)];
  g[4] = [Edge(4, 5, 5, 170)];

  auto d = graph.primalDual(g, 0, 5, 8);
  assert(d.cost == 5260);
}
