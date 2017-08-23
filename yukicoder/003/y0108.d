import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  auto xi = new int[](3);
  foreach (a; ai)
    if (a < 3) ++xi[a];

  auto dp = new real[][][](n+1, n+1, n+1);
  dp[0][0][0] = 0;

  real calc(int x0, int x1, int x2) {
    if (!dp[x0][x1][x2].isNaN) {
      return dp[x0][x1][x2];
    } else {
      auto r = real(n);
      if (x0 > 0)
        r += calc(x0 - 1, x1 + 1, x2) * x0;
      if (x1 > 0)
        r += calc(x0, x1 - 1, x2 + 1) * x1;
      if (x2 > 0)
        r += calc(x0, x1, x2 - 1) * x2;

      return dp[x0][x1][x2] = r / (x0 + x1 + x2);
    }
  }

  writefln("%.7f", calc(xi[0], xi[1], xi[2]));
}
