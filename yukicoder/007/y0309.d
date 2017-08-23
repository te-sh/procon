import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -8

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), r = rd[0], c = rd[1];
  readln;
  auto p = r.iota.map!(_ => readln.split.to!(real[]).map!"a / 100".array).array;
  readln;
  auto s = r.iota.map!(_ => readln.split.to!(int[])).array;

  auto cb = (1 << c), cb2 = (1 << (c * 2));

  auto pb = new real[][](r, cb);
  foreach (i; 0..r)
    foreach (j; 0..cb) {
      pb[i][j] = 1;
      foreach (k; 0..c)
        pb[i][j] *= j.bitTest(k) ? 1 - p[i][k] : p[i][k];
    }

  auto unma = new int[][](r, cb);
  foreach (i; 0..r)
    foreach (j; 0..cb)
      foreach (k; 0..c)
        if (j.bitTest(k)) unma[i][j] |= (3 << (k * 2));

  auto pt2hu = new int[](cb2);
  foreach (i; 0..cb2) pt2hu[i] = calcHu(c, i);

  auto dp = new real[][](r, cb);
  foreach (i; 0..r) dp[i][] = 0;

  foreach (i; 0..cb) {
    auto pt = calcPt(c, s[0], 0);
    auto hu = pt2hu[pt | unma[0][i]];
    dp[0][hu] += pb[0][i];
  }

  foreach (i; 1..r)
    foreach (j; 0..cb) {
      auto pt = calcPt(c, s[i], j);
      foreach (k; 0..cb) {
        auto hu = pt2hu[pt | unma[i][k]];
        dp[i][hu] += pb[i][k] * dp[i-1][j];
      }
    }

  auto ans = real(0);
  foreach (i; 0..r)
    foreach (j; 1..cb)
      ans += dp[i][j] * j.popcnt;

  writefln("%.9f", ans);
}

auto calcP(size_t c, real[] p, int bkn)
{
  auto r = real(0);

  foreach (i; 0..c)
    r *= bkn.bitTest(i) ? p[i] : 1 - p[i];

  return r;
}

auto calcPt(size_t c, int[] s, int bhu)
{
  auto pt = 0;

  foreach (i; 0..c) {
    auto pti = (s[i] - bhu.bitTest(i)).clamp(0, 3);
    pt |= (pti << (i * 2));
  }

  return pt;
}

auto calcHu(size_t c, int bpt)
{
  auto pt = new int[](c);
  foreach (i; 0..c) pt[i] = ((bpt >> (i * 2)) & 3);

  auto op = new bool[](c);

  ptrdiff_t findPt0(int[] pt)
  {
    foreach (i; 0..c)
      if (pt[i] <= 0 && !op[i]) return i;
    return -1;
  }

  auto toHu(int[] pt)
  {
    auto hu = 0;

    foreach (i; 0..c)
      if (pt[i] <= 0) hu = hu.bitSet(i);

    return hu;
  }

  for (;;) {
    auto i = findPt0(pt);

    if (i < 0) return toHu(pt);

    if (i > 0) --pt[i-1];
    if (i < c-1) --pt[i+1];
    op[i] = true;
  }
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  pure T bitSet(T)(T n, size_t s, size_t e) { return n | ((T(1) << e) - 1) & ~((T(1) << s) - 1); }
  pure T bitReset(T)(T n, size_t s, size_t e) { return n & (~((T(1) << e) - 1) | ((T(1) << s) - 1)); }
  pure T bitComp(T)(T n, size_t s, size_t e) { return n ^ ((T(1) << e) - 1) & ~((T(1) << s) - 1); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
