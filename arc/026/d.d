import std.algorithm, std.conv, std.range, std.stdio, std.string;

const eps = 10.0L^^(-7);

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  struct Road { int a, b; long c, t; real x; }
  auto r = new Road[](m);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto ai = rd2.front.to!int; rd2.popFront();
    auto bi = rd2.front.to!int; rd2.popFront();
    auto ci = rd2.front.to!int; rd2.popFront();
    auto ti = rd2.front.to!int;
    r[i] = Road(ai, bi, ci, ti);
  }

  auto calc(real s)
  {
    foreach (ref ri; r) ri.x = ri.c - s * ri.t;
    r.sort!"a.x < b.x";

    auto uf = UnionFind!int(n), u = 0.0L;
    foreach (ri; r)
      if (ri.x < 0 || uf[ri.a] != uf[ri.b]) {
        uf.unite(ri.a, ri.b);
        u += ri.x;
      }
    return -u;
  }

  auto cs = r.map!"a.c".sum, ts = r.map!"a.t".sum;
  auto sm = cs.to!real / ts;

  struct Result { real s, u; }

  auto bsearch = iota(0, sm+eps, eps).map!((s) => Result(s, calc(s))).assumeSorted!"a.u <= b.u";
  writefln("%.4f", bsearch.lowerBound(Result(0, 0)).back.s);
}

struct UnionFind(T)
{
  import std.algorithm, std.range;

  T[] p; // parent
  const T s; // sentinel
  const T n;
  T countForests; // number of forests
  T[] countNodes; // number of nodes in forests

  this(T n)
  {
    this.n = n;
    s = n;
    p = new T[](n);
    p[] = s;
    countForests = n;
    countNodes = new T[](n);
    countNodes[] = 1;
  }

  T opIndex(T i)
  {
    if (p[i] == s) {
      return i;
    } else {
      p[i] = this[p[i]];
      return p[i];
    }
  }

  bool unite(T i, T j)
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

  auto countNodesOf(T i) { return countNodes[this[i]]; }
  bool isSame(T i, T j) { return this[i] == this[j]; }

  auto groups()
  {
    auto g = new T[][](n);
    foreach (i; 0..n) g[this[i]] ~= i;
    return g.filter!(l => !l.empty);
  }
}
