import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

alias graph = Graph!(real, size_t);
alias edge = graph.Edge;

struct Person { real x, y, t, r; }

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  if (n == 1) {
    writeln(0);
    return;
  }

  auto p = new Person[](n);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    auto x = rd.front.to!real; rd.popFront();
    auto y = rd.front.to!real; rd.popFront();
    auto t = rd.front.to!real; rd.popFront();
    auto r = rd.front.to!real;
    p[i] = Person(x, y, t, r);
  }

  auto g = new edge[][](n);
  foreach (i; 0..n) {
    auto pi = p[i];
    foreach (j; 0..n) {
      if (i == j) continue;
      auto pj = p[j];
      auto d = ((pi.x - pj.x) ^^ 2 + (pi.y - pj.y) ^^ 2).sqrt;
      auto w = d / min(pi.t, pj.r);
      g[i] ~= edge(i, j, w);
    }
  }

  auto ds = graph.dijkstra(g, 0)[1..$];
  ds.sort!"a > b";
  foreach (i, ref dsi; ds) dsi += i;

  writefln("%.7f", ds.reduce!max);
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
