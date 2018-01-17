import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

alias graph = GraphW!(int, long, 10L^^18);
const ofs = 10L^^6;

version(unittest) {} else
void main()
{
  int n, m; readV(n, m);
  auto s = readArray!long(n), ss = s.sum*ofs;
  auto t = readArray!long(m);
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

  auto g = graph(n+m+2), gs = n+m, gt = n+m+1;

  foreach (i; 0..n) g.addEdge(i, gt, s[i]*ofs);

  foreach (i; 0..n)
    foreach (j; a[i])
      g.addEdge(n+j, i, 10L^^18);

  auto calc(long x)
  {
    g.g[gs] = [];
    foreach (j; 0..m)
      g.addEdge(gs, n+j, t[j]*x);

    auto f = Dinic!(typeof(g)).dinic(g, gs, gt);
    return f >= ss;
  }

  auto ma = 10000L*ofs;
  auto bsearch = iota(ma+1).map!(x => tuple(x, calc(x))).assumeSorted!"a[1] < b[1]";
  writefln("%.7f", bsearch.upperBound(tuple(0, false)).front[0].to!real/ofs);
}

struct GraphW(N = int, W = int, W i = 10^^9)
{
  import std.typecons;
  alias Node = N, Wt = W, inf = i;
  struct Edge { Node src, dst; Wt wt; alias cap = wt; }
  Node n;
  Edge[][] g;
  mixin Proxy!g;
  this(Node n) { this.n = n; g = new Edge[][](n); }
  void addEdge(Node u, Node v, Wt w) { g[u] ~= Edge(u, v, w); }
  void addEdgeB(Node u, Node v, Wt w) { g[u] ~= Edge(u, v, w); g[v] ~= Edge(v, u, w); }
}

template Dinic(Graph)
{
  import std.algorithm, std.container, std.traits;
  alias Node = TemplateArgsOf!Graph[0], Wt = TemplateArgsOf!Graph[1];

  struct EdgeR { Node src, dst; Wt cap, flow; Node rev; }

  Wt dinic(Graph g, Node s, Node t)
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

  EdgeR[][] withRev(Graph g, Node n)
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
