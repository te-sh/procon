// path: arc076_b

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto x = new int[](n), y = new int[](n);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    x[i] = rd.front.to!int; rd.popFront();
    y[i] = rd.front.to!int;
  }

  struct ZI { int z; size_t i; }
  auto zix = new ZI[](n), ziy = new ZI[](n);
  foreach (i; 0..n) {
    zix[i] = ZI(x[i], i);
    ziy[i] = ZI(y[i], i);
  }
  zix.sort!"a.z < b.z";
  ziy.sort!"a.z < b.z";

  struct DI { int d; size_t a, b; }
  auto di = new DI[]((n-1)*2);
  foreach (i; 0..n-1) {
    di[i*2]   = DI(zix[i+1].z-zix[i].z, zix[i].i, zix[i+1].i);
    di[i*2+1] = DI(ziy[i+1].z-ziy[i].z, ziy[i].i, ziy[i+1].i);
  }
  di.sort!"a.d < b.d";

  auto uf = UnionFind(n), ans = 0L;
  foreach (dii; di) {
    if (!uf.isSame(dii.a, dii.b)) {
      uf.unite(dii.a, dii.b);
      ans += dii.d;
      if (uf.countForests == 1) break;
    }
  }

  writeln(ans);
}

struct UnionFind
{
  import std.algorithm, std.range;

  size_t[] p; // parent
  const size_t s; // sentinel
  const size_t n;
  size_t countForests; // number of forests
  size_t[] countNodes; // number of nodes in forests

  this(size_t n)
  {
    this.n = n;
    s = n;
    p = new size_t[](n);
    p[] = s;
    countForests = n;
    countNodes = new size_t[](n);
    countNodes[] = 1;
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

  bool unite(size_t i, size_t j)
  {
    auto pi = this[i], pj = this[j];
    if (pi != pj) {
      p[pj] = pi;
      --countForests;
      countNodes[pi] += countNodes[pj];
      return true;
    } else {
      return false;
    }
  }

  auto countNodesOf(size_t i) { return countNodes[this[i]]; }
  bool isSame(size_t i, size_t j) { return this[i] == this[j]; }

  auto groups()
  {
    auto g = new size_t[][](n);
    foreach (i; 0..n) g[this[i]] ~= i;
    return g.filter!(l => !l.empty);
  }
}
