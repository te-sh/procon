import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto bi = new int[](n), ci = new int[](n);

  foreach (i; 0..n) {
    auto rd = readln.split.to!(int[]);
    bi[i] = rd[0];
    ci[i] = rd[1];
  }

  auto gi = new edge[][](n * 2 + 2), s = n * 2, t = n * 2 + 1;
  foreach (i; 0..n) {
    gi[s] ~= edge(i, bi[i]);
    gi[i] ~= edge(i + n, int.max);
    gi[i + n] ~= edge(t, ci[i]);
  }

  auto m = readln.chomp.to!size_t;
  foreach (_; 0..m) {
    auto rd = readln.split.to!(size_t[]), i = rd[0], j = rd[1];
    gi[i] ~= edge(j + n, int.max);
  }

  writeln(bi.sum + ci.sum - gi.dinic(s, t));
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

  int[] bfs(size_t s)
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

    return level;
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

  while (bfs(s)[t] >= 0) {
    itr[] = 0;
    while ((f = dfs(s, t, T.max)) > 0) ret += f;
  }

  return ret;
}
