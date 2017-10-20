import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(long[]);

  auto st1 = SegmentTreeLazy!(long, 0L)(a);

  auto b = new long[](n-1);
  foreach (i; 0..n-1) b[i] = (a[i] - a[i+1]).abs;
  auto st2 = SegmentTree!(long, 0, gcd)(b);

  auto m = readln.chomp.to!size_t;
  foreach (_; 0..m) {
    auto rd = readln.splitter;
    auto t = rd.front.to!int; rd.popFront();
    auto l = rd.front.to!size_t-1; rd.popFront();
    auto r = rd.front.to!size_t-1;

    if (t == 0) {
      writeln(gcd(st1[l..l+1], st2[l..r]));
    } else {
      st1[l..r+1] += t;
      if (l > 0)   st2[l-1] = (st1[l-1..l] - st1[l..l+1]  ).abs;
      if (r < n-1) st2[r]   = (st1[r..r+1] - st1[r+1..r+2]).abs;
    }
  }
}

struct SegmentTree(T, T unit, alias pred = "a + b")
{
  import core.bitop, std.functional;
  alias predFun = binaryFun!pred;

  const size_t n, an;
  T[] buf;

  this(size_t n)
  {
    this.n = n;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    static if (T.init != unit) buf[] = unit;
  }

  this(T[] init)
  {
    this(init.length);
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

  pure T opSlice(size_t l, size_t r) const
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

struct SegmentTreeLazy(T, T unit, alias pred = "a + b")
{
  import core.bitop, std.conv, std.functional, std.range;
  alias predFun = binaryFun!pred;
  enum Op { none, fill, add };

  const size_t n, an;
  T[] buf, laz;
  Op[] op;

  this(size_t n)
  {
    this.n = n;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    laz = new T[](an * 2);
    op = new Op[](an * 2);
    static if (T.init != unit) buf[] = unit;
  }

  this(T[] init)
  {
    this(init.length);
    buf[an..an+n][] = init[];
    foreach_reverse (i; 1..an)
      buf[i] = predFun(buf[i*2], buf[i*2+1]);
  }

  void propagate(size_t k, size_t nl, size_t nr)
  {
    if (op[k] == Op.none) return;

    size_t nm = (nl + nr) / 2;
    setLazy(op[k], laz[k], k*2,   nl, nm);
    setLazy(op[k], laz[k], k*2+1, nm, nr);

    op[k] = Op.none;
  }

  void setLazy(Op nop, T val, size_t k, size_t nl, size_t nr)
  {
    switch (nop) {
    case Op.fill:
      buf[k] = val * (nr - nl).to!T;
      laz[k] = val;
      op[k] = nop;
      break;
    case Op.add:
      buf[k] += val * (nr - nl).to!T;
      laz[k] = op[k] == Op.none ? val : laz[k] + val;
      op[k] = op[k] == Op.fill ? Op.fill : Op.add;
      break;
    default:
      assert(0);
    }
  }

  void addOpe(Op op, T val, size_t l, size_t r, size_t k, size_t nl, size_t nr)
  {
    if (nr <= l || r <= nl) return;

    if (l <= nl && nr <= r) {
      setLazy(op, val, k, nl, nr);
      return;
    }

    propagate(k, nl, nr);

    auto nm = (nl + nr) / 2;
    addOpe(op, val, l, r, k*2,   nl, nm);
    addOpe(op, val, l, r, k*2+1, nm, nr);

    buf[k] = predFun(buf[k*2], buf[k*2+1]);
  }

  void opSliceAssign(T val, size_t l, size_t r)
  {
    addOpe(Op.fill, val, l, r, 1, 0, an);
  }

  void opSliceOpAssign(string op: "+")(T val, size_t l, size_t r)
  {
    addOpe(Op.add, val, l, r, 1, 0, an);
  }

  T summary(size_t l, size_t r, size_t k, size_t nl, size_t nr)
  {
    if (nr <= l || r <= nl) return unit;

    if (l <= nl && nr <= r) return buf[k];

    propagate(k, nl, nr);

    auto nm = (nl + nr) / 2;
    auto vl = summary(l, r, k*2,   nl, nm);
    auto vr = summary(l, r, k*2+1, nm, nr);

    return predFun(vl, vr);
  }

  T opSlice(size_t l, size_t r)
  {
    return summary(l, r, 1, 0, an);
  }

  pure size_t opDollar() const { return n; }
}
