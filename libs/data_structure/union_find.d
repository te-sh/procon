struct UnionFind
{
  import std.algorithm, std.range;

  size_t[] p; // parent
  const size_t s; // sentinel
  const size_t n;
  size_t count;

  this(size_t n)
  {
    this.n = n;
    p = new size_t[](n);
    s = n + 1;
    p[] = s;
    count = n;
  }

  size_t opIndex(size_t i)
  {
    if (p[i] == s) {
      return i;
    } else {
      p[i] = this[p[i]];
      return p[i];
    }
  }

  size_t find(size_t i) { return this[i]; }

  bool unite(size_t i, size_t j)
  {
    auto pi = this[i], pj = this[j];
    if (pi != pj) {
      p[pj] = pi;
      --count;
      return true;
    } else {
      return false;
    }
  }

  bool isSame(size_t i, size_t j) { return this[i] == this[j]; }

  auto groups()
  {
    auto g = new size_t[][](n);
    foreach (i; 0..n) g[this[i]] ~= i;
    return g.filter!(l => !l.empty);
  }
}

unittest
{
  import std.range;

  auto uf = UnionFind(6);

  assert(uf.count == 6);
  foreach (i; 0..6)
    assert(uf.find(i) == i);

  uf.unite(0, 1);
  assert(uf.count == 5);
  assert(uf[0] == uf[1]);

  uf.unite(0, 2);
  foreach (i; 0..2)
    foreach (j; i+1..2)
      assert(uf.isSame(i, j));

  uf.unite(3, 5);
  assert(uf.count == 3);
  assert(uf.find(3) == uf.find(5));

  auto g = uf.groups.array;
  assert(g[0] == [0, 1, 2]);
  assert(g[1] == [3, 5]);
  assert(g[2] == [4]);
}
