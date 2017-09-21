import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

alias graph = Graph!(int, size_t);

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];

  struct Edge { size_t a, b; int c; }

  auto e = new Edge[](m);
  auto g = new int[][](n, n);
  foreach (i; 0..n) {
    g[i][] = graph.inf;
    g[i][i] = 0;
  }

  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!size_t-1; rd2.popFront();
    auto b = rd2.front.to!size_t-1; rd2.popFront();
    auto c = rd2.front.to!int;
    e[i] = Edge(a, b, c);
    g[a][b] = g[b][a] = c;
  }

  auto d = graph.floydWarshal(g);

  auto ans = BitArray();
  ans.length = m;

  foreach (i; 0..n)
    foreach (j; 0..m) {
      auto a = e[j].a, b = e[j].b, c = e[j].c;
      if (d[i][a] + c == d[i][b] || d[i][b] + c == d[i][a])
        ans[j] = true;
    }

  writeln(m - ans.bitsSet.walkLength);
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
