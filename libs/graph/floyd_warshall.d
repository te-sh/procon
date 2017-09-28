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

unittest
{
  alias graph = Graph!(int, size_t);

  auto g = new int[][](5, 5);
  foreach (ref i; g) i[] = graph.inf;

  g[0][1] = 10;
  g[0][3] = 100;
  g[1][3] = 1000;
  g[2][1] = 1;
  g[2][3] = 10000;
  g[3][0] = 5;

  auto r = graph.floydWarshal(g);

  assert(r[0][1] == 10);
  assert(r[2][3] == 1001);
  assert(r[3][1] == 15);
  assert(r[4][2] == 10 ^^ 9);
}
