import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias Graph!(int, size_t) graph;
alias graph.Edge Edge;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = n.iota.map!(_ => readln.chomp.to!size_t).array;

  auto g = new Edge[][](n*2+2), s = n*2, t = n*2+1;
  foreach (i; 0..n) {
    g[s] ~= Edge(s, i, 1);
    g[i+n] ~= Edge(i+n, t, 1);
    foreach (j; 0..n)
      if (j != ai[i]) g[i] ~= Edge(i, j+n, 1);
  }

  auto ri = graph.fordFulkerson(g, s, t);
  if (ri.empty)
    writeln(-1);
  else
    ri.map!(r => r - n).each!writeln;
}

template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.algorithm, std.container, std.conv;

  const inf = _inf, sent = _sent;

  struct Edge { Node src, dst; Wt cap; }
  struct EdgeR { Node src, dst; Wt cap, flow; Node rev; }

  size_t[] fordFulkerson(Edge[][] g, Node s, Node t)
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

    auto m = (n-2)/2;
    if (flow == m) {
      auto ri = new size_t[](m);
      foreach (i; 0..m)
        ri[i] = adj[i].find!"a.flow > 0".front.dst;
      return ri;
    } else {
      return [];
    }
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
