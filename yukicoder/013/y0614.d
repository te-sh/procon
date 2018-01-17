import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n, m, k, s, t; readV(n, m, k, s, t);

  struct Rouka { int a, b, c; }
  auto roukas = new Rouka[](m);
  foreach (i; 0..m) {
    int a, b, c; readV(a, b, c); --a;
    roukas[i] = Rouka(a, b, c);
  }

  auto r = new int[][](n);
  foreach (rouka; roukas) {
    r[rouka.a] ~= rouka.b;
    r[rouka.a+1] ~= rouka.c;
  }
  r[0] ~= s;
  r[$-1] ~= t;

  foreach (ri; r) ri.sort();

  auto h = new int[int][](n), cnt = 0;
  foreach (i, ri; r)
    foreach (rij; ri)
      h[i][rij] = cnt++;

  auto g = GraphW!(int, long, 10L^^18)(cnt);

  foreach (i, ri; r)
    if (ri.length >= 2)
      foreach (j; 0..ri.length-1) {
        auto u = h[i][ri[j]], v = h[i][ri[j+1]], w = ri[j+1]-ri[j];
        g.addEdgeB(u, v, w);
      }

  foreach (rouka; roukas) {
    auto u = h[rouka.a][rouka.b], v = h[rouka.a+1][rouka.c];
    g.addEdge(u, v, 0);
  }

  auto dist = Dijkstra!(typeof(g)).dijkstra(g, h[0][s])[h[$-1][t]];

  writeln(dist == g.inf ? -1 : dist);
}

struct GraphW(N = int, W = int, W i = 10^^9)
{
  import std.typecons;
  alias Node = N, Wt = W, inf = i;
  struct Edge { Node src, dst; Wt wt; }
  Node n;
  Edge[][] g;
  mixin Proxy!g;
  this(Node n) { this.n = n; g = new Edge[][](n); }
  void addEdge(Node u, Node v, Wt w) { g[u] ~= Edge(u, v, w); }
  void addEdgeB(Node u, Node v, Wt w) { g[u] ~= Edge(u, v, w); g[v] ~= Edge(v, u, w); }
}

template Dijkstra(Graph)
{
  import std.array, std.container, std.traits;
  alias Node = TemplateArgsOf!Graph[0], Wt = TemplateArgsOf!Graph[1];
  alias Edge = Graph.Edge;

  auto dijkstra(Graph g, Node s)
  {
    Wt[] dist;
    Node[] prev;
    dijkstra(g, s, dist, prev);
    return dist;
  }

  void dijkstra(Graph g, Node s, out Wt[] dist, out Node[] prev)
  {
    auto n = g.n, sent = n;

    dist = new Wt[](n);
    dist[] = g.inf;
    dist[s] = 0;

    prev = new Node[](n);
    prev[] = sent;

    auto q = heapify!("a.wt > b.wt")(Array!Edge(Edge(sent, s, 0)));
    while (!q.empty) {
      auto e = q.front; q.removeFront();
      if (prev[e.dst] != sent) continue;
      prev[e.dst] = e.src;
      foreach (f; g[e.dst]) {
        auto w = e.wt + f.wt;
        if (dist[f.dst] > w) {
          dist[f.dst] = w;
          q.insert(Edge(f.src, f.dst, w));
        }
      }
    }
  }
}
