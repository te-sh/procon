import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

alias graph = Graph!(long, int, 10L^^18);
alias edge = graph.Edge;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1], k = rd[2], s = rd[3], t = rd[4];

  struct Rouka { int a, b, c; }
  auto roukas = new Rouka[](m);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int-1; rd2.popFront();
    auto b = rd2.front.to!int;   rd2.popFront();
    auto c = rd2.front.to!int;
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

  auto g = new edge[][](cnt);

  foreach (i, ri; r)
    if (ri.length >= 2)
      foreach (j; 0..ri.length-1) {
        auto u = h[i][ri[j]], v = h[i][ri[j+1]], w = ri[j+1]-ri[j];
        g[u] ~= edge(u, v, w);
        g[v] ~= edge(v, u, w);
      }

  foreach (rouka; roukas) {
    auto u = h[rouka.a][rouka.b], v = h[rouka.a+1][rouka.c];
    g[u] ~= edge(u, v, 0);
  }

  auto dist = graph.dijkstra(g, h[0][s])[h[$-1][t]];

  writeln(dist == graph.inf ? -1 : dist);
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
