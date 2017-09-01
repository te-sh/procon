import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(int, size_t);

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], m = rd[1];

  auto g = new int[][](n, n);
  foreach (i; 0..n)
    foreach (j; 0..n)
      g[i][j] = i == j ? 0 : graph.inf;

  foreach (_; 0..m) {
    auto rd2 = readln.split;
    auto a = rd2[0].to!size_t-1, b = rd2[1].to!size_t-1, t = rd2[2].to!int;
    g[a][b] = g[b][a] = t;
  }

  auto d = graph.floydWarshal(g);

  auto r = int(graph.inf);
  foreach (i; 0..n)
    r = min(r, d[i].reduce!max);

  writeln(r);
}

template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.algorithm, std.array, std.conv;

  const inf = _inf, sent = _sent;

  Wt[][] floydWarshal(Wt[][] g)
  {
    Wt[][] dist;
    Node[][] inter;
    floydWarshal(g, dist, inter);
    return dist;
  }

  void floydWarshal(Wt[][] g, out Wt[][] dist, out Node[][] inter)
  {
    auto n = g.length;
    dist = g.map!(i => i.dup).array;

    inter = new Node[][](n, n);
    foreach (i; 0..n) inter[i][] = sent;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (j; 0..n)
          if (dist[i][j] > dist[i][k] + dist[k][j]) {
            dist[i][j] = dist[i][k] + dist[k][j];
            inter[i][j] = k.to!Node;
          }
  }
}
