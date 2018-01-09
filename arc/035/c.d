import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(int, int);

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];

  auto g = new int[][](n, n);
  foreach (i; 0..n)
    foreach (j; 0..n)
      g[i][j] = i == j ? 0 : graph.inf;

  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int-1; rd2.popFront();
    auto b = rd2.front.to!int-1; rd2.popFront();
    auto c = rd2.front.to!int;
    g[a][b] = g[b][a] = min(g[a][b], c);
  }

  auto d = graph.floydWarshal(g);

  auto k = readln.chomp.to!int;
  foreach (_; 0..k) {
    auto rd2 = readln.splitter;
    auto x = rd2.front.to!int-1; rd2.popFront();
    auto y = rd2.front.to!int-1; rd2.popFront();
    auto z = rd2.front.to!int;
    d[x][y] = d[y][x] = min(d[x][y], z);

    foreach (i; 0..n)
      foreach (j; 0..n)
        d[i][j] = min(d[i][j], d[i][x] + d[j][y] + d[x][y], d[i][y] + d[j][x] + d[x][y]);

    auto r = 0L;
    foreach (i; 0..n)
      foreach (j; i+1..n)
        r += d[i][j];

    writeln(r);
  }
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
