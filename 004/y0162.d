import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto a = 80 - readln.chomp.to!int;
  auto rd = readln.split.map!(s => s.to!real / 100).array, p0 = rd[0], p1 = rd[1], p2 = rd[2];

  auto dp = new real[][](a + 1, 15);

  real prob(ulong b, int n)
  {
    real r = 1;
    r *= b.bitTest(0)   ? 1 - p1 : p1;
    r *= b.bitTest(n-1) ? 1 - p1 : p1;
    foreach (i; 1..n-1)
      r *= b.bitTest(i) ? 1 - p2 : p2;
    return r;
  }

  int[] conts(ulong b, int n)
  {
    auto r = new int[](0), c = 0;
    foreach (i; 0..n) {
      if (b.bitTest(i)) {
        ++c;
      } else if (c) {
        r ~= c; c = 0;
      }
    }
    if (c) r ~= c;
    return r;
  }

  real calc(int y, int n)
  {
    if (y == 0) return n;
    if (n == 1) return (1 - p0) * calc(y - 1, n);
    if (!dp[y][n].isNaN) return dp[y][n];

    real e = 0;
    foreach (i; 0..(1 << n)) {
      auto p = prob(i, n);
      auto ci = conts(i, n);
      e += p * ci.map!(c => calc(y - 1, c)).sum;
    }
    return dp[y][n] = e;
  }

  writefln("%.7f", calc(a, 14) * 2);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
}
