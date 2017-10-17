import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(int, int);
alias edge = graph.Edge;

version(unittest) {} else
void main()
{
  struct Pair { int a, b; }
  auto n = readln.chomp.to!size_t;

  auto v = 20*20*20, s = v*2, t = v*2+1;
  auto g = new edge[][](v*2+2);

  auto addEdges(int w, int z)
  {
    foreach (i; 1..w) {
      auto v1 = i*z-1, v2 = (w-i)*z-1;
      g[v1] ~= edge(v1, v2+v, 1);
    }
  }

  foreach (_; 0..n) {
    auto rd = readln.split.to!(int[]);
    addEdges(rd[0], rd[1]*rd[2]);
    addEdges(rd[1], rd[2]*rd[0]);
    addEdges(rd[2], rd[0]*rd[1]);
  }

  foreach (i; 0..v) {
    g[s] ~= edge(s, i, 1);
    g[i+v] ~= edge(i+v, t, 1);
  }

  auto ans = g[0..v].filter!(e => e.length != 0).walkLength * 2 - graph.fordFulkerson(g, s, t);
  writeln(ans);
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
        r[e.src] ~= EdgeR(e.src, e.dst, e.cap, 0, cast(Node)(r[e.dst].length));
        r[e.dst] ~= EdgeR(e.dst, e.src, 0, 0, cast(Node)(r[e.src].length) - 1);
      }

    return r;
  }
}
