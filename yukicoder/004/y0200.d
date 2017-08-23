import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto al = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]); ai.sort().reverse;
  auto bl = readln.chomp.to!size_t;
  auto bi = readln.split.to!(int[]); bi.sort();

  auto pai = new int[](n), pbi = new int[](n);
  foreach (i; 0..n) {
    pai[i] = ai[i % al];
    pbi[i] = bi[i % bl];
  }

  auto g = new Edge[][](n * 2 + 2);
  foreach (i; 0..n) {
    g[n*2] ~= Edge(n*2, i, 1, 0);
    g[i+n] ~= Edge(i+n, n*2+1, 1, 0);
  }

  foreach (i; 0..n) {
    auto aps = i / al * al, ape = min(n - 1, aps + al - 1);
    auto bps = aps / bl * bl, bpe = min(n - 1, ape / bl * bl + bl - 1);
    foreach (j; bps..bpe+1)
      g[i] ~= Edge(i, j+n, 1, pai[i] > pbi[j] ? 0 : 1);
  }

  auto r = graph.primalDual(g, n*2, n*2+1, n.to!int);
  writeln(n - r.cost);
}

alias Graph!(int, int, size_t) graph;
alias graph.Edge Edge;

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
