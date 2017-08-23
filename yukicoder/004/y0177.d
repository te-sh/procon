import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto w = readln.chomp.to!int;
  auto n = readln.chomp.to!size_t;
  auto ji = readln.split.to!(int[]);
  auto m = readln.chomp.to!size_t;
  auto ci = readln.split.to!(int[]);

  auto g = new edge[][](n + m + 2);
  foreach (i; 0..n)
    g[n+m] ~= edge(i, ji[i]);
  foreach (i; 0..m)
    g[i+n] ~= edge(n+m+1, ci[i]);

  foreach (i; 0..m) {
    auto rd = readln.split, q = rd[0].to!size_t;
    auto xi = rd[1..$].map!(to!size_t).map!"a - 1";
    foreach (j; setDifference(n.iota, xi))
      g[j] ~= edge(n+i, int.max);
  }

  writeln(g.dinic(n+m, n+m+1) >= w ? "SHIROBAKO" : "BANSAKUTSUKITA");
}

alias Edge!int edge;

struct Edge(T)
{
  size_t v;
  T w;
}

T dinic(T)(const Edge!T[][] gi, size_t s, size_t t)
{
  import std.container;

  class EdgeR
  {
    size_t v;
    T w;
    size_t rev;

    this(size_t v, T w, size_t rev)
    {
      this.v = v;
      this.w = w;
      this.rev = rev;
    }
  }

  auto n = gi.length;

  auto hi = new EdgeR[][](n);
  foreach (i, g; gi)
    foreach (e; g) {
      hi[i] ~= new EdgeR(e.v, e.w, hi[e.v].length);
      hi[e.v] ~= new EdgeR(i, 0, hi[i].length - 1);
    }

  auto level = new int[](n);
  auto itr = new size_t[](n);

  void bfs(size_t s)
  {
    level[] = -1;

    auto qi = new DList!size_t();
    level[s] = 0; qi.insertBack(s);

    while (!qi.empty) {
      auto v = qi.front; qi.removeFront;
      foreach (e; hi[v])
        if (e.w > 0 && level[e.v] < 0) {
          level[e.v] = level[v] + 1;
          qi.insertBack(e.v);
        }
    }
  }

  T dfs(size_t v, size_t t, T f)
  {
    if (v == t) return f;
    foreach (i; itr[v]..hi[v].length) {
      auto e = hi[v][i];
      if (e.w > 0 && level[v] < level[e.v]) {
        auto d = dfs(e.v, t, min(f, e.w));
        if (d > 0) {
          e.w -= d;
          hi[e.v][e.rev].w += d;
          return d;
        }
      }
    }
    return 0;
  }

  T ret, f;

  while (bfs(s), level[t] >= 0) {
    itr[] = 0;
    while ((f = dfs(s, t, T.max)) > 0) ret += f;
  }

  return ret;
}
