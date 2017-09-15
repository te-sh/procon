import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto g = new bool[][](n, n), h = new size_t[](n);

  foreach (_; 0..m) {
    auto rd2 = readln.split.to!(size_t[]), x = rd2[0]-1, y = rd2[1]-1;
    g[x][y] = true;
    ++h[y];
  }

  auto memo = new long[](1<<n);

  long calc(int rest, size_t[] h)
  {
    if (memo[rest]) return memo[rest];
    if (rest == 0) return 0;
    if (rest.popcnt == 1) return 1;

    auto r = 0L;
    foreach (i; 0..n) {
      if (!rest.bitTest(i) || h[i]) continue;
      auto nh = h.dup;
      foreach (j; 0..n)
        if (g[i][j]) --nh[j];
      r += calc(rest.bitComp(i), nh);
    }

    return memo[rest] = r;
  }

  writeln(calc((1<<n)-1, h));
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
