import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto t = readln.split.to!(int[]);

  auto st = SegmentTreeLazy!(long, max)(n);
  foreach (i; 0..n-1) st[i..i+1] += t[i] - i*3;

  auto m = readln.chomp.to!int;
  foreach (_; 0..m) {
    auto rd2 = readln.splitter;
    auto l = rd2.front.to!int-1; rd2.popFront();
    auto r = rd2.front.to!int;   rd2.popFront();
    auto d = rd2.front.to!long;
    st[l..r] += d;
    writeln(st[0..$] + (n-1)*3);
  }
}

struct SegmentTreeLazy(T, alias pred = "a + b")
{
  import core.bitop, std.conv, std.functional, std.range;
  alias predFun = binaryFun!pred;
  enum Op { none, add };

  const size_t n, an;
  T[] buf, laz;
  Op[] op;
  T unit;

  this(size_t n, T unit = T.init)
  {
    this.n = n;
    this.unit = unit;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    laz = new T[](an * 2);
    op = new Op[](an * 2);
    if (T.init != unit) {
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
    case Op.add:
      buf[k] += val;
      laz[k] = op[k] == Op.none ? val : laz[k] + val;
      op[k] = Op.add;
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
