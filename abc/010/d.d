import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(int, size_t);
alias edge = graph.Edge;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], g = rd1[1], e = rd1[2];
  auto eg = new edge[][](n+1);

  auto p = readln.split.to!(size_t[]);
  foreach (pi; p) eg[pi] ~= edge(pi, n, 1);

  foreach (_; 0..e) {
    auto rd2 = readln.split.to!(size_t[]), u = rd2[0], v = rd2[1];
    eg[u] ~= edge(u, v, 1);
    eg[v] ~= edge(v, u, 1);
  }

  auto r = graph.fordFulkerson(eg, 0, n);
  writeln(r);
}

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
