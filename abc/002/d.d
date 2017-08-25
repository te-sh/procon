import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto rel = new bool[][](n, n);
  foreach (_; 0..m) {
    auto rd2 = readln.split.to!(size_t[]), x = rd2[0]-1, y = rd2[1]-1;
    rel[x][y] = rel[y][x] = true;
  }

  auto ma = 0;

  auto dp = new bool[](1<<n);
  dp[0] = true;

  auto calcDp(int j, int k)
  {
    if (!dp[k]) return false;
    foreach (ki; k.bitsSet)
      if (!rel[j][ki])
        return false;
    return true;
  }

  foreach (i; 1..1<<n) {
    auto j = i.bsf, k = i.bitComp(j);
    dp[i] = calcDp(j, k);
    if (dp[i]) ma = max(ma, i.popcnt);
  }

  writeln(ma);
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
