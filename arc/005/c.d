import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(int, size_t);
alias edge = graph.Edge;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), h = rd[0], w = rd[1], hw = h*w;
  auto c = new string[](h);
  foreach (i; 0..h) c[i] = readln.chomp;

  auto gr = new edge[][](hw);
  auto idx(size_t i, size_t j) { return i*w+j; }

  size_t s, g;
  foreach (i; 0..h)
    foreach (j; 0..w) {
      if (i > 0)   gr[idx(i, j)] ~= edge(idx(i, j), idx(i-1, j), c[i][j] == '#');
      if (i < h-1) gr[idx(i, j)] ~= edge(idx(i, j), idx(i+1, j), c[i][j] == '#');
      if (j > 0)   gr[idx(i, j)] ~= edge(idx(i, j), idx(i, j-1), c[i][j] == '#');
      if (j < w-1) gr[idx(i, j)] ~= edge(idx(i, j), idx(i, j+1), c[i][j] == '#');

      if (c[i][j] == 's') s = idx(i, j);
      if (c[i][j] == 'g') g = idx(i, j);
    }

  auto d = graph.dijkstra(gr, s);
  writeln(d[g] <= 2 ? "YES" : "NO");
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
