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

unittest
{
  import std.algorithm;

  auto st1 = SegmentTreeLazy!(int, 0, "a + b")(7);
  st1[0..5] = 1;
  st1[2..7] = 2;
  assert(st1[0..0] == 0);
  assert(st1[0..1] == 1);
  assert(st1[0..2] == 2);
  assert(st1[0..3] == 4);
  assert(st1[2..$] == 10);
  st1[3..6] += 3;
  assert(st1[0..3] == 4);
  assert(st1[2..$] == 19);
}
