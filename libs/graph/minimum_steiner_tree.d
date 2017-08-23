template Graph(Wt, Node, Wt _inf = 10 ^^ 9)
{
  import std.algorithm, std.array;

  const inf = _inf;

  Wt minimumSteinerTree(Node[] t, Wt[][] g)
  {
    auto n = g.length, nt = t.length;
    auto d = g.map!(i => i.dup).array;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (j; 0..n)
          d[i][j] = min(d[i][j], d[i][k] + d[k][j]);

    auto opt = new Wt[][](1<<nt, n);
    foreach (s; 0..1<<nt)
      opt[s][] = inf;

    foreach (p; 0..nt)
      foreach (q; 0..n)
        opt[1<<p][q] = d[t[p]][q];

    foreach (s; 1..1<<nt)
      if (s & (s-1)) {
        foreach (p; 0..n)
          foreach (e; 0..s)
            if ((e | s) == s) opt[s][p] = min(opt[s][p], opt[e][p] + opt[s-e][p]);
        foreach (p; 0..n)
          foreach (q; 0..n)
            opt[s][p] = min(opt[s][p], opt[s][q] + d[p][q]);
      }

    Wt ans = inf;
    foreach (s; 0..1<<nt)
      foreach (q; 0..n)
        ans = min(ans, opt[s][q] + opt[(1<<nt)-1-s][q]);

    return ans;
  }
}

unittest
{
  alias Graph!(int, size_t) graph;

  auto g = new int[][](6, 6);
  foreach (ref i; g) i[] = graph.inf;

  g[0][1] = g[1][0] = 1;
  g[0][3] = g[3][0] = 6;
  g[1][2] = g[2][1] = 1;
  g[1][5] = g[5][1] = 2;
  g[2][4] = g[4][2] = 3;
  g[3][4] = g[4][3] = 1;
  g[4][5] = g[5][4] = 1;

  auto r = graph.minimumSteinerTree([0, 3], g);
  assert(r == 5);
}
