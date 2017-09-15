import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias SegT = SegmentTree!(int, 0, max);

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  struct WH { int w, h; }
  auto wh = new WH[](n);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    auto w = rd.front.to!int; rd.popFront();
    auto h = rd.front.to!int;
    wh[i] = WH(w, h);
  }

  wh.multiSort!("a.h < b.h", "a.w > b.w");

  auto st = SegT(wh.map!"a.w".reduce!max+1), ans = 0;
  foreach (i; 0..n) {
    auto w = wh[i].w;
    auto s = st[0..w] + 1;
    st[w] = max(st[w], s);
    ans = max(ans, s);
  }

  writeln(ans);
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
