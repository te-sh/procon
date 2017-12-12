import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], p = rd[1];
  auto r = new int[][](n, 4);
  foreach (i; 0..n) r[i] = readln.split.to!(int[]) ~ 1;

  auto inf = 10^^9;
  auto dp = new int[](p+1), dp2 = new int[](p+1);
  dp[] = inf;
  dp[0] = 0;

  foreach (i; 0..n) {
    dp2[] = inf;
    foreach (j; 0..p+1)
      foreach (k; 0..4)
        if (j-k >= 0)
          dp2[j] = min(dp2[j], dp[j-k] + r[i][k]);
    dp[] = dp2[];
  }

  writefln("%.6f", dp[p].to!real / n);
}
