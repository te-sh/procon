import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];

  auto score = new int[][](n, n);
  foreach (_; 0..m) {
    auto rd2 = readln.split, i = rd2[0].to!size_t, j = rd2[1].to!size_t, s = rd2[2].to!int;
    score[i][j] = s;
  }

  auto dp = new int[](1 << n);
  foreach (i; 1..1 << n) {
    foreach (j; 0..n) {
      if (i.bitTest(j)) {
        auto s = 0;
        foreach (k; 0..n)
          if (j != k && i.bitTest(k))
            s += score[j][k];
        dp[i] = max(dp[i], s + dp[i.bitComp(j)]);
      }
    }
  }

  writeln(dp[$-1]);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }
}
