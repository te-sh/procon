import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

alias graph = GraphW!(int, int);

version(unittest) {} else
void main()
{
  struct Pair { int a, b; }
  int n; readV(n);

  auto v = 20*20*20, s = v*2, t = v*2+1;
  auto g = graph(v*2+2);

  auto addEdges(int w, int z)
  {
    foreach (i; 1..w) {
      auto v1 = i*z-1, v2 = (w-i)*z-1;
      g.addEdge(v1, v2+v, 1);
    }
  }

  foreach (_; 0..n) {
    int x, y, z; readV(x, y, z);
    addEdges(x, y*z);
    addEdges(y, z*x);
    addEdges(z, x*y);
  }

  foreach (i; 0..v) {
    g.addEdge(s, i, 1);
    g.addEdge(i+v, t, 1);
  }

  auto f = FordFulkerson!(typeof(g)).fordFulkerson(g, s, t);
  auto ans = g[0..v].filter!(e => e.length != 0).walkLength * 2 - f;
  writeln(ans);
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

template FordFulkerson(Graph)
{
  import std.algorithm, std.container, std.traits;
  alias Node = TemplateArgsOf!Graph[0], Wt = TemplateArgsOf!Graph[1];

  struct EdgeR { Node src, dst; Wt cap, flow; Node rev; }

  Wt fordFulkerson(Graph g, Node s, Node t)
  {
    auto n = g.n, adj = withRev(g, n), visited = new bool[](n);

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
      auto f = augment(s, g.inf);
      if (f == 0) break;
      flow += f;
    }

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
