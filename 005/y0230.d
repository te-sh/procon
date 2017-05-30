import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias SegmentTreeLazy!(int, 0, "a + b") SegTree;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto q = readln.chomp.to!size_t;

  auto sa = SegTree(n), sb = SegTree(n);
  auto pa = 0L, pb = 0L;

  foreach (_; 0..q) {
    auto rd = readln.split, x = rd[0], l = rd[1].to!size_t, r = rd[2].to!size_t + 1;
    switch (x) {
    case "0":
      auto ca = sa[l..r], cb = sb[l..r];
      if (ca > cb) pa += ca;
      if (ca < cb) pb += cb;
      break;
    case "1":
      sa[l..r] = 1;
      sb[l..r] = 0;
      break;
    case "2":
      sa[l..r] = 0;
      sb[l..r] = 1;
      break;
    default:
      assert(0);
    }
  }

  pa += sa[0..$];
  pb += sb[0..$];

  writeln(pa, " ", pb);
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

  int summary(size_t l, size_t r, size_t k, size_t nl, size_t nr)
  {
    if (nr <= l || r <= nl) return 0;

    if (l <= nl && nr <= r) return buf[k];

    propagate(k, nl, nr);

    auto nm = (nl + nr) / 2;
    auto vl = summary(l, r, k*2,   nl, nm);
    auto vr = summary(l, r, k*2+1, nm, nr);

    return predFun(vl, vr);
  }

  int opSlice(size_t l, size_t r)
  {
    return summary(l, r, 1, 0, an);
  }

  pure size_t opDollar() const { return n; }
}
