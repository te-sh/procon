import graph;

template FloydWarshal(Graph)
{
  import std.algorithm, std.array, std.traits;
  alias Wt = TemplateArgsOf!Graph[0];

  Wt[][] floydWarshal(ref Graph g)
  {
    Wt[][] dist;
    int[][] inter;
    floydWarshal(g, dist, inter);
    return dist;
  }

  void floydWarshal(ref Graph g, out Wt[][] dist, out int[][] inter)
  {
    auto n = g.n, sent = n;
    dist = g.g.map!(i => i.dup).array;

    inter = new int[][](n, n);
    foreach (i; 0..n) inter[i][] = sent;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (j; 0..n)
          if (dist[i][j] > dist[i][k] + dist[k][j]) {
            dist[i][j] = dist[i][k] + dist[k][j];
            inter[i][j] = k;
          }
  }
}

unittest
{
  auto g = GraphM!int(5).init;

  g[0][1] = 10;
  g[0][3] = 100;
  g[1][3] = 1000;
  g[2][1] = 1;
  g[2][3] = 10000;
  g[3][0] = 5;

  auto r = FloydWarshal!(typeof(g)).floydWarshal(g);

  assert(r[0][1] == 10);
  assert(r[2][3] == 1001);
  assert(r[3][1] == 15);
  assert(r[4][2] == 10 ^^ 9);
}
