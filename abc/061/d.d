import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

alias graph = GraphW!(int, long, 10L ^^ 18);

version(unittest) {} else
void main()
{
  int n, m; readV(n, m);

  auto g = graph(n);
  foreach (_; 0..m){
    int a, b; long c; readV(a, b, c); --a; --b;
    g.addEdge(a, b, -c);
  }

  auto dist = BellmanFord!(typeof(g)).bellmanFord(g, 0), d = dist[n-1];
  if (d <= -graph.inf)
    writeln("inf");
  else
    writeln(-d);
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

template BellmanFord(Graph)
{
  import std.traits;
  alias Node = TemplateArgsOf!Graph[0], Wt = TemplateArgsOf!Graph[1];

  void bellmanFord(Graph g, Node s, out Wt[] dist, out Node[] prev)
  {
    auto n = g.n, sent = n;

    dist = new Wt[](n);
    dist[] = g.inf + g.inf;
    dist[s] = 0;

    prev = new Node[](n);
    prev[] = sent;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (e; g[i])
          if (dist[e.dst] > dist[e.src] + e.wt) {
            dist[e.dst] = dist[e.src] + e.wt;
            prev[e.dst] = e.src;
            if (k == n-1) dist[e.dst] = -g.inf;
          }
  }

  Wt[] bellmanFord(Graph g, Node s)
  {
    Wt[] dist;
    Node[] prev;
    bellmanFord(g, s, dist, prev);
    return dist;
  }
}
