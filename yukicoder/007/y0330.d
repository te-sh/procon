import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], m = rd[1];

  auto uf = UnionFind!size_t(n);
  foreach (_; 0..m) {
    auto rd2 = readln.split[0..2].to!(size_t[]), i = rd2[0]-1, j = rd2[1]-1;
    uf.unite(i, j);
  }

  auto b = new bool[](n);
  foreach (i; 0..n) b[uf.find(i)] = true;

  writeln(b.count!"a");
}

struct UnionFind(T)
{
  import std.algorithm, std.range;

  T[] p; // parent
  const T s; // sentinel
  const T n;

  this(T n)
  {
    this.n = n;
    p = new T[](n);
    s = n + 1;
    p[] = s;
  }

  T find(T i)
  {
    if (p[i] == s) {
      return i;
    } else {
      p[i] = find(p[i]);
      return p[i];
    }
  }

  void unite(T i, T j)
  {
    auto pi = find(i), pj = find(j);
    if (pi != pj) p[pj] = pi;
  }

  bool isSame(T i, T j) { return find(i) == find(j); }

  auto groups()
  {
    auto g = new T[][](n);
    foreach (i; 0..n) g[find(i)] ~= i;
    return g.filter!(l => !l.empty);
  }
}
