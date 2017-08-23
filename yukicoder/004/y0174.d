import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, pa = rd[1].to!real, pb = rd[2].to!real;
  auto ai = readln.split.to!(int[]); ai.sort();
  auto bi = readln.split.to!(int[]); bi.sort();

  auto paij = calc(n, ai, pa);
  auto pbij = calc(n, bi, pb);

  auto r = real(0);
  foreach (i; 0..n)
    foreach (ja; 0..n)
      foreach (jb; 0..n)
        if (ai[ja] > bi[jb])
          r += paij[ja][i] * pbij[jb][i] * (ai[ja] + bi[jb]);

  writefln("%.10f", r);
}

auto calc(size_t n, int[] ai, real p)
{
  auto dp = new real[](1 << n), pij = new real[][](n, n);
  dp[$-1] = 1; dp[0..$-1] = 0;
  foreach (ref pi; pij) pi[] = 0;

  foreach_reverse (i; 1..(1 << n)) {
    auto f = i.bsf, r = i.bsr, c = i.popcnt;

    auto pf = dp[i] * (c == 1 ? 1 : p);
    dp[i.bitComp(f)] += pf;
    pij[f][n - c] += pf;

    foreach (j; f+1..r+1)
      if (i.bitTest(j)) {
        auto pj = dp[i] * (1 - p) / (c - 1);
        dp[i.bitComp(j)] += pj;
        pij[j][n - c] += pj;
      }
  }

  return pij;
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
