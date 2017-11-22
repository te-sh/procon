import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto a = new int[](n), c = new int[](n);
  foreach (i; 1..n) {
    auto rd = readln.splitter;
    c[i] = rd.front.to!int; rd.popFront();
    a[i] = rd.front.to!int;
  }

  auto g = new int[](n), mag = 0;
  auto st = SegmentTree!(int, min)(n+1, int.max);
  st[0] = 0;

  foreach (i; 1..n) {
    auto bsearch = iota(0, mag+1).map!(x => tuple(x, st[0..x+1])).assumeSorted!"a[1] >= b[1]";
    auto r = bsearch.lowerBound(tuple(0, i-c[i]));
    g[i] = r.empty ? 0 : r.back[0] + 1;
    mag = max(g[i], mag);
    st[g[i]] = i;
  }

  auto ans = 0;
  foreach (i; 1..n)
    if (a[i] % 2) ans ^= g[i];

  writeln(ans == 0 ? "Second" : "First");
}

struct SegmentTree(T, alias pred = "a + b")
{
  import core.bitop, std.functional;
  alias predFun = binaryFun!pred;

  const size_t n, an;
  T[] buf;
  T unit;

  this(size_t n, T unit)
  {
    this.n = n;
    this.unit = unit;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    buf[] = unit;
  }

  this(T[] init, T unit)
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
