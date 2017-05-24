import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto q = readln.chomp.to!size_t;

  auto sa = SegmentTree(n), sb = SegmentTree(n);
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
      sa[l..r] = true;
      sb[l..r] = false;
      break;
    case "2":
      sa[l..r] = false;
      sb[l..r] = true;
      break;
    default:
      assert(0);
    }
  }

  pa += sa[0..$];
  pb += sb[0..$];

  writeln(pa, " ", pb);
}

struct SegmentTree
{
  import core.bitop, std.conv;

  const size_t n, an;
  int[] buf;
  bool[] laz, prop;

  this(size_t n)
  {
    this.n = n;
    an = (1 << ((n - 1).bsr + 1));
    buf = new int[](an * 2);
    laz = new bool[](an * 2);
    prop = new bool[](an * 2);
  }

  void propagate(size_t k, size_t nl, size_t nr)
  {
    if (!prop[k]) return;

    size_t nm = (nl + nr) / 2;
    setLazy(laz[k], k*2,   nl, nm);
    setLazy(laz[k], k*2+1, nm, nr);

    prop[k] = false;
  }

  void setLazy(bool val, size_t k, size_t nl, size_t nr)
  {
    buf[k] = val ? (nr - nl).to!int : 0;
    laz[k] = val;
    prop[k] = true;
  }

  void opSliceAssign(bool val, size_t l, size_t r)
  {
    fill(val, l, r, 1, 0, an);
  }

  void fill(bool val, size_t l, size_t r, size_t k, size_t nl, size_t nr)
  {
    if (nr <= l || r <= nl) return;

    if (l <= nl && nr <= r) {
      setLazy(val, k, nl, nr);
      return;
    }
    
    propagate(k, nl, nr);

    auto nm = (nl + nr) / 2;
    fill(val, l, r, k*2,   nl, nm);
    fill(val, l, r, k*2+1, nm, nr);

    buf[k] = buf[k*2] + buf[k*2+1];
  }

  int opSlice(size_t l, size_t r)
  {
    return count(l, r, 1, 0, an);
  }

  int count(size_t l, size_t r, size_t k, size_t nl, size_t nr)
  {
    if (nr <= l || r <= nl) return 0;

    if (l <= nl && nr <= r) return buf[k];

    propagate(k, nl, nr);

    auto nm = (nl + nr) / 2;
    auto vl = count(l, r, k*2,   nl, nm);
    auto vr = count(l, r, k*2+1, nm, nr);

    return vl + vr;
  }

  pure size_t opDollar() const { return n; }
}
