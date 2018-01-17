import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

alias graph = GraphW!(int, long, 10L^^18);

version(unittest) {} else
void main()
{
  int h, w, t; readV(h, w, t);

  auto id(int i, int j) { return i*w+j; }

  auto s = new bool[](h*w);
  int st, gl;
  foreach (i; 0..h) {
    auto rd2 = readln.chomp;
    foreach (j; 0..w) {
      switch (rd2[j]) {
      case 'S': st = id(i,j); break;
      case 'G': gl = id(i,j); break;
      case '#': s[id(i,j)] = true; break;
      case '.': break;        
      default: assert(0);
      }
    }
  }

  auto calcDist(int x)
  {
    auto g = graph(h*w);

    auto addEdge(int i1, int j1, int i2, int j2)
    {
      auto id1 = id(i1, j1), id2 = id(i2, j2), w = s[id2] ? x : 1;
      g.addEdge(id1, id2, w);
    }

    foreach (i; 0..h)
      foreach (j; 0..w) {
        if (j > 0)   addEdge(i, j, i, j-1);
        if (j < w-1) addEdge(i, j, i, j+1);
        if (i > 0)   addEdge(i, j, i-1, j);
        if (i < h-1) addEdge(i, j, i+1, j);
      }

    auto r = Dijkstra!(typeof(g)).dijkstra(g, st);
    return r[gl];
  }

  struct xd { int x; long d; }

  auto ans = iota(1, t+1).map!((x) => xd(x, calcDist(x))).assumeSorted!"a.d < b.d".upperBound(xd(0, t));
  writeln(ans.front.x - 1);
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

  auto dijkstra(Graph g, Node s)
  {
    Wt[] dist;
    Node[] prev;
    dijkstra(g, s, dist, prev);
    return dist;
  }
}
