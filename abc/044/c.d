import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], a = rd[1];
  auto x = readln.split.to!(int[]), xs = x.sum;

  auto dp = new long[][][](n+1, n+1, xs+1);
  dp[0][0][0] = 1;

  foreach (i; 0..n)
    foreach (j; 0..n+1)
      foreach (k; 0..xs+1) {
        dp[i+1][j][k] = dp[i][j][k];
        if (j >= 1 && k >= x[i])
          dp[i+1][j][k] += dp[i][j-1][k-x[i]];
      }

  auto ans = 0L;
  foreach (i; 1..n+1) {
    if (i*a > xs) break;
    ans += dp[n][i][i*a];
  }

  writeln(ans);
}
