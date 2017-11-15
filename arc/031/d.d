import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

alias graph = Graph!(long, int, 10L^^18);
alias edge = graph.Edge;
const ofs = 10L^^6;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto s = readln.split.to!(long[]), ss = s.sum*ofs;
  auto t = readln.split.to!(long[]);
  auto a = new int[][](n);
  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto k = rd2.front.to!int; rd2.popFront();
    a[i] = new int[](k);
    foreach (j; 0..k) {
      a[i][j] = rd2.front.to!int-1;
      rd2.popFront();
    }
  }

  auto g = new edge[][](n+m+2), gs = n+m, gt = n+m+1;

  foreach (i; 0..n)
    g[i] ~= edge(i, gt, s[i]*ofs);

  foreach (i; 0..n)
    foreach (j; a[i])
      g[n+j] ~= edge(n+j, i, 10L^^18);

  auto calc(long x)
  {
    g[gs] = [];
    foreach (j; 0..m)
      g[gs] ~= edge(gs, n+j, t[j]*x);

    auto f = graph.dinic(g, gs, gt);
    return f >= ss;
  }

  auto ma = 10000L*ofs;
  auto bsearch = iota(ma+1).map!(x => tuple(x, calc(x))).assumeSorted!"a[1] < b[1]";
  writefln("%.7f", bsearch.upperBound(tuple(0, false)).front[0].to!real/ofs);
}

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
      while ((f = augment(s, inf)) > 0)
        flow += f;

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
