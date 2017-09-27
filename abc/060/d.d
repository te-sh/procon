import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc073_b

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(long[]), n = rd1[0], ws = rd1[1];
  auto w = new long[](n), v = new long[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(long[]), wi = rd2[0], vi = rd2[1];
    w[i] = wi;
    v[i] = vi;
  }
  auto w0 = w[0];
  foreach (ref wi; w) wi -= w0;

  auto sumW = w.sum, dp = new long[][][](n+1, n+1, sumW+1);
  dp[0][0][0] = 1;
  foreach (i; 0..n)
    foreach (j; 0..n+1)
      foreach (k; 0..sumW+1) {
        if (j >= 1 && k >= w[i] && dp[i][j-1][k-w[i]])
          dp[i+1][j][k] = max(dp[i][j][k], dp[i][j-1][k-w[i]] + v[i]);
        else
          dp[i+1][j][k] = dp[i][j][k];
      }

  auto ans = 0L;
  foreach (j; 0..n+1)
    foreach (k; 0..sumW+1)
      if (k + w0 * j <= ws)
        ans = max(ans, dp[n][j][k]);

  writeln(ans-1);
}
