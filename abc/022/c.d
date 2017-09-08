import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(int, size_t);

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];

  auto gs = new int[](n), gr = new int[][](n-1, n-1);
  foreach (i; 0..n-1) {
    gr[i][] = graph.inf;
    gr[i][i] = 0;
  }

  foreach (_; 0..m) {
    auto rd2 = readln.split;
    auto u = rd2[0].to!size_t-1, v = rd2[1].to!size_t-1, l = rd2[2].to!int;
    if (v == 0) swap(u, v);
    if (u == 0) {
      gs[v] = l;
    } else {
      gr[u-1][v-1] = gr[v-1][u-1] = l;
    }
  }

  size_t[] s;
  foreach (i; 1..n)
    if (gs[i]) s ~= i;
  auto ns = s.length;

  auto d = graph.floydWarshal(gr);

  auto r = int.max;
  foreach (i; 0..ns-1)
    foreach (j; i+1..ns) {
      auto si = s[i], sj = s[j];
      r = min(r, gs[si] + gs[sj] + d[si-1][sj-1]);
    }

  writeln(r >= graph.inf ? -1 : r);
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
