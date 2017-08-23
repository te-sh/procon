import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto li = new int[](n);
  auto uf = new UnionFind!size_t(n);
  auto pi = new size_t[](n);
  pi[] = n;

  foreach (i; n.iota) {
    auto rd = readln.split, l = rd[0].to!int, s = rd[1].to!size_t - 1;
    li[i] = l;
    uf.unite(s, i);
    pi[i] = s;
  }

  auto vi = new bool[](n);

  auto findLoop(size_t d) {
    auto lp = [pi[d]];
    vi[] = false;
    while (!vi[lp.back]) {
      vi[lp.back] = true;
      lp ~= pi[lp.back];
    }
    return lp ~ pi[lp.back];
  }

  auto findRoot(size_t[] c) {
    auto d = c.front;
    vi[] = false;
    vi[d] = true;
    while (pi[d] < n) {
      if (vi[pi[d]]) return findLoop(d);
      d = pi[d];
      vi[d] = true;
    }
    return [pi[d]];
  }

  auto pt = 0;
  foreach (c; uf.groups) {
    auto ri = findRoot(c);
    pt += ri.map!(r => li.indexed(c).sum + li[r]).fold!min;
  }

  writefln("%.1f", pt.to!real / 2);
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
