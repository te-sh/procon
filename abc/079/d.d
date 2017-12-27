import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(int, int);

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1];

  auto g = new int[][](10, 10);
  foreach (i; 0..10) g[i] = readln.split.to!(int[]);

  auto d = graph.floydWarshal(g);

  auto ans = 0;
  foreach (i; 0..h) {
    auto rd2 = readln.splitter;
    foreach (j; 0..w) {
      auto a = rd2.front.to!int;
      rd2.popFront();
      if (a >= 0) ans += d[a][1];
    }
  }

  writeln(ans);
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
