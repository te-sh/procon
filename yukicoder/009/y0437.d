import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp.map!(c => cast(int)(c - '0')).array, n = s.length;

  auto dp = new int[](1<<n);
  foreach (d; 0..1<<n) {
    if (d.popcnt < 3 || d.popcnt % 3 != n % 3) continue;
    foreach (i; 0..n) {
      if (!d.bitTest(i) || s[i] == 0) continue;
      foreach (j; i+1..n) {
        if (!d.bitTest(j) || s[i] == s[j]) continue;
        foreach (k; j+1..n) {
          if (!d.bitTest(k) || s[j] != s[k]) continue;
          auto r = s[i] * 100 + s[j] * 10 + s[k];
          dp[d] = max(dp[d], r + dp[d.bitComp(i).bitComp(j).bitComp(k)]);
        }
      }
    }
  }

  writeln(dp.maxElement);
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
