import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], k = rd1[1], l = rd1[2];

  auto readUf(size_t m)
  {
    auto uf = UnionFind(n);
    foreach (_1; 0..m) {
      auto rd2 = readln.splitter;
      auto u = rd2.front.to!size_t-1; rd2.popFront;
      auto v = rd2.front.to!size_t-1;
      uf.unite(u, v);
    }
    return uf;
  }

  auto uf1 = readUf(k), uf2 = readUf(l);

  struct P { size_t i, p1, p2; }

  auto p = new P[](n);
  foreach (i; 0..n) p[i] = P(i, uf1[i], uf2[i]);
  p.multiSort!("a.p1 < b.p1", "a.p2 < b.p2");

  auto ans = new size_t[](n), prevP = p[0], prevI = size_t(0);
  foreach (i; 1..n) {
    if (p[i].p1 == prevP.p1 && p[i].p2 == prevP.p2) continue;
    foreach (j; prevI..i)
      ans[p[j].i] = i - prevI;

    prevP = p[i];
    prevI = i;
  }
  foreach (j; prevI..n)
    ans[p[j].i] = n - prevI;

  foreach (i; 0..n) {
    write(ans[i]);
    if (i < n-1) write(" ");
  }
  writeln;
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
