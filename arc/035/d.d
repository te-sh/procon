import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto p = new int[](n), q = new int[](n);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    p[i] = rd.front.to!int; rd.popFront();
    q[i] = rd.front.to!int;
  }

  auto ma = 10^^6;
  auto fact = new real[](ma+1);
  fact[0] = 0;
  foreach (i; 1..ma+1) fact[i] = fact[i-1] + log2(i);

  auto sti = new real[](n-1);
  foreach (i; 0..n-1)
    sti[i] = fact[p[i+1]-p[i]+q[i+1]-q[i]] - fact[p[i+1]-p[i]] - fact[q[i+1]-q[i]];
  auto st = SegmentTree!real(sti, 0);

  auto query = readln.chomp.to!int;
  foreach (_; 0..query) {
    auto rd = readln.splitter;
    auto t = rd.front.to!int; rd.popFront();

    switch (t) {
    case 1:
      auto k = rd.front.to!int-1; rd.popFront();
      auto a = rd.front.to!int; rd.popFront();
      auto b = rd.front.to!int;

      p[k] = a;
      q[k] = b;

      if (k > 0)
        st[k-1] = fact[p[k]-p[k-1]+q[k]-q[k-1]] - fact[p[k]-p[k-1]] - fact[q[k]-q[k-1]];
      if (k < n-1)
        st[k] = fact[p[k+1]-p[k]+q[k+1]-q[k]] - fact[p[k+1]-p[k]] - fact[q[k+1]-q[k]];

      break;

    case 2:
      auto l1 = rd.front.to!int-1; rd.popFront();
      auto r1 = rd.front.to!int-1; rd.popFront();
      auto l2 = rd.front.to!int-1; rd.popFront();
      auto r2 = rd.front.to!int-1;

      writeln(st[l1..r1] > st[l2..r2] ? "FIRST" : "SECOND");

      break;

    default:
      assert(0);
    }
  }
}

struct SegmentTree(T, alias pred = "a + b")
{
  import core.bitop, std.functional;
  alias predFun = binaryFun!pred;

  const size_t n, an;
  T[] buf;
  T unit;

  this(size_t n, T unit = T.init)
  {
    this.n = n;
    this.unit = unit;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    if (T.init != unit) {
      buf[] = unit;
    }
  }

  this(T[] init, T unit = T.init)
  {
    this(init.length, unit);
    buf[an..an+n][] = init[];
    foreach_reverse (i; 1..an)
      buf[i] = predFun(buf[i*2], buf[i*2+1]);
  }

  void opIndexAssign(T val, size_t i)
  {
    buf[i += an] = val;
    while (i /= 2)
      buf[i] = predFun(buf[i * 2], buf[i * 2 + 1]);
  }

  pure T opSlice(size_t l, size_t r)
  {
    l += an; r += an;
    T r1 = unit, r2 = unit;
    while (l != r) {
      if (l % 2) r1 = predFun(r1, buf[l++]);
      if (r % 2) r2 = predFun(buf[--r], r2);
      l /= 2; r /= 2;
    }
    return predFun(r1, r2);
  }

  pure size_t opDollar() { return n; }
  pure T opIndex(size_t i) { return buf[i + an]; }
}
