import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.chomp.map!(c => c - '0').array, n = a.length;

  auto dp = new int[][][](n+1, 2, 10);
  dp[0][0][0] = 1;

  foreach (i; 0..n)
    foreach (j; 0..2)
      foreach (k; 0..10) {
        auto dm = j ? 9 : a[i];
        foreach (d; 0..dm+1) {
          if (d != 1) {
            dp[i+1][j || d < dm][k] += dp[i][j][k];
          } else if (k < 9) {
            dp[i+1][j || d < dm][k+1] += dp[i][j][k];
          }
        }
      }

  auto ans = 0;
  foreach (j; 0..2)
    foreach (k; 1..10)
      ans += dp[n][j][k] * k;

  writeln(ans);
}
