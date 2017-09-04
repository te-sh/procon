import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto w = readln.chomp.to!int;
  auto rd1 = readln.split.to!(int[]), n = rd1[0], k = rd1[1];
  auto a = new int[](n), b = new int[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(int[]);
    a[i] = rd2[0];
    b[i] = rd2[1];
  }

  auto dp = new int[][][](n+1, w+1, k+1);
  dp[0][0][0] = 1;
  foreach (i; 1..n+1) {
    foreach (j; 0..w+1) {
      foreach (m; 0..k+1) {
        dp[i][j][m] = dp[i-1][j][m];
        if (j >= a[i-1] && m >= 1 && dp[i-1][j-a[i-1]][m-1])
          dp[i][j][m] = max(dp[i][j][m], dp[i-1][j-a[i-1]][m-1] + b[i-1]);
      }
    }
  }

  auto r = 0;
  foreach (j; 0..w+1)
    foreach (m; 0..k+1)
      r = max(r, dp[n][j][m]);

  writeln(r-1);
}
