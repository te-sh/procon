import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias Graph!(int, size_t) graph;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1], t = rd1[2];
  auto e = new Edge[](m);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto src = rd2.front.to!size_t-1; rd2.popFront();
    auto dst = rd2.front.to!size_t-1; rd2.popFront();
    e[i] = Edge(src, dst, rd2.front.to!int);
  }
  auto v = t.iota.map!(_ => readln.chomp.to!size_t-1).array;
  v.sort();

  auto calc1()
  {
    auto g = new int[][](n, n);
    foreach (ref r; g) r[] = graph.inf;
    foreach (i; 0..n) g[i][i] = 0;

    foreach (ref ei; e) g[ei.s][ei.t] = g[ei.t][ei.s] = ei.w;
    auto r = graph.minimumSteinerTree(v, g);
    return r >= graph.inf ? 0 : r;
  }

  auto calc2()
  {
    auto cb = ulong(0);
    foreach (vi; v) cb |= (ulong(1) << vi);
    
    auto w = n.iota.setDifference(v).array;
    e.sort!"a.w < b.w";

    auto u = n - t, ans = int.max;

    auto bt = new ulong[n];
    foreach (i; 0..n) bt[i] = (ulong(1) << i);

    foreach (i; 0..1<<u) {
      auto cc = cb;
      foreach (j; 0..u) cc |= (i & (1L << j)) << (w[j] - j);

      auto mif = n - cc.popcnt + 1;
      auto uf = UnionFind(n), r = 0;

      foreach (ei; e) {
        if ((cc & bt[ei.s]) && (cc & bt[ei.t]) && uf.unite(ei.s, ei.t)) {
          r += ei.w;
          if (uf.count <= mif) break;
        }
      }

      if (uf.count <= mif) ans = min(ans, r);
    }

    return ans;
  }

  writeln(t <= 13 ? calc1 : calc2);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}

struct Edge { size_t s, t; int w; }

template Graph(Wt, Node, Wt _inf = 10 ^^ 9)
{
  import std.algorithm, std.array;

  const inf = _inf;

  Wt minimumSteinerTree(Node[] t, Wt[][] g)
  {
    auto n = g.length, nt = t.length;
    auto d = g.map!(i => i.dup).array;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (j; 0..n)
          d[i][j] = min(d[i][j], d[i][k] + d[k][j]);

    auto opt = new Wt[][](1<<nt, n);
    foreach (s; 0..1<<nt)
      opt[s][] = inf;

    foreach (p; 0..nt)
      foreach (q; 0..n)
        opt[1<<p][q] = d[t[p]][q];

    foreach (s; 1..1<<nt)
      if (s & (s-1)) {
        foreach (p; 0..n)
          foreach (e; 0..s)
            if ((e | s) == s) opt[s][p] = min(opt[s][p], opt[e][p] + opt[s-e][p]);
        foreach (p; 0..n)
          foreach (q; 0..n)
            opt[s][p] = min(opt[s][p], opt[s][q] + d[p][q]);
      }

    Wt ans = inf;
    foreach (s; 0..1<<nt)
      foreach (q; 0..n)
        ans = min(ans, opt[s][q] + opt[$-1-s][q]);

    return ans;
  }
}

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
