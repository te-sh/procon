import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 10L ^^ 18 + 9;
const teams = 5;

alias SegmentTreeLazy!(long, 0) SegTreeLazy;
alias SegmentTree!(long, 0) SegTree;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  auto q = readln.chomp.to!size_t;

  if (q == 0) {
    writeln("0 0 0 0 0");
    return;
  }

  auto xi = new int[](q), li = new long[](q), ri = new long[](q);
  foreach (i; 0..q) {
    auto rd = readln.split;
    xi[i] = rd[0].to!int;
    li[i] = rd[1].to!long;
    ri[i] = rd[2].to!long + 1;
  }

  auto zi = li ~ ri;
  zi = zi.sort().array.uniq.array;
  auto n2 = zi.length;

  size_t[long] zaa;
  foreach (i, z; zi)
    zaa[z] = i;

  foreach (ref l; li) l = zaa[l];
  foreach (ref r; ri) r = zaa[r];

  auto wi = new long[](n2);
  foreach (i; 0..n2-1)
    wi[i] = zi[i+1] - zi[i];

  auto stw = SegTree(wi);
  auto sti = teams.iota.map!(_ => SegTreeLazy(n2, stw)).array;

  auto sci = new long[](teams);

  foreach (x, l, r; lockstep(xi, li, ri)) {
    if (x == 0) {
      auto bsi = sti.map!(st => st[l..r]);
      auto maxBs = bsi.maxElement;
      if (bsi.count(maxBs) == 1) {
        auto i = bsi.countUntil(maxBs);
        sci[i] = (sci[i] + bsi[i]) % p;
      }
    } else {
      sti[x-1][l..r] += 1;
      foreach (i; 0..teams)
        if (i != x-1)
          sti[i][l..r] = 0;
    }
  }

  foreach (i; 0..teams)
    sci[i] = (sci[i] + sti[i][0..$]) % p;

  writeln(sci.to!(string[]).join(" "));
}

struct SegmentTreeLazy(T, T unit, alias pred = "a + b")
{
  import core.bitop, std.conv, std.functional, std.range;
  alias predFun = binaryFun!pred;
  enum Op { none, fill, add };

  const size_t n, an;
  T[] buf, laz;
  Op[] op;
  SegTree wt;

  this(size_t n, ref SegTree wt)
  {
    this.n = n;
    this.wt = wt;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    laz = new T[](an * 2);
    op = new Op[](an * 2);
    static if (T.init != unit) {
      buf[] = unit;
    }
  }

  void propagate(size_t k, size_t nl, size_t nr)
  {
    if (op[k] == Op.none) return;

    size_t nm = (nl + nr) / 2;
    setLazy(op[k], laz[k], k*2,   nl, nm);
    setLazy(op[k], laz[k], k*2+1, nm, nr);

    op[k] = Op.none;
    laz[k] = unit;
  }

  void setLazy(Op nop, T val, size_t k, size_t nl, size_t nr)
  {
    switch (nop) {
    case Op.fill:
      buf[k] = val * wt.buf[k];
      laz[k] = val;
      op[k] = nop;
      break;
    case Op.add:
      buf[k] += val * wt.buf[k];
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
    if (nr <= l || r <= nl) return 0;

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
    static if (T.init != unit) {
      buf[] = unit;
    }
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

  pure size_t opDollar() const { return n; }
  pure T opIndex(size_t i) const { return buf[i + an]; }
}
