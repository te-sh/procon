import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(long, size_t, 10L^^18);
alias edge = graph.Edge;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split;
  auto h = rd1[0].to!size_t, w = rd1[1].to!size_t, t = rd1[2].to!int;

  auto id(size_t i, size_t j) { return i*w+j; }

  auto s = new bool[](h*w);
  size_t st, gl;
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
    auto g = new edge[][](h*w);

    auto addEdge(size_t i1, size_t j1, size_t i2, size_t j2)
    {
      auto id1 = id(i1, j1), id2 = id(i2, j2), w = s[id2] ? x : 1;
      g[id1] ~= edge(id1, id2, w);
    }

    foreach (i; 0..h)
      foreach (j; 0..w) {
        if (j > 0)   addEdge(i, j, i, j-1);
        if (j < w-1) addEdge(i, j, i, j+1);
        if (i > 0)   addEdge(i, j, i-1, j);
        if (i < h-1) addEdge(i, j, i+1, j);
      }

    auto r = graph.dijkstra(g, st);
    return r[gl];
  }

  struct xd { int x; long d; }

  auto ans = iota(1, t+1).map!((x) => xd(x, calcDist(x))).assumeSorted!"a.d < b.d".upperBound(xd(0, t));
  writeln(ans.front.x - 1);
}

template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.container;

  const inf = _inf, sent = _sent;

  struct Edge
  {
    Node src, dst;
    Wt wt;
  }

  Wt[] dijkstra(Edge[][] g, Node s)
  {
    Wt[] dist;
    Node[] prev;
    dijkstra(g, s, dist, prev);
    return dist;
  }

  void dijkstra(Edge[][] g, Node s, out Wt[] dist, out Node[] prev)
  {
    auto n = g.length;

    dist = new Wt[](n);
    dist[] = inf;
    dist[s] = 0;

    prev = new Node[](n);
    prev[] = sent;

    auto q = heapify!("a.wt > b.wt")(Array!Edge(Edge(sent, s)));
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
