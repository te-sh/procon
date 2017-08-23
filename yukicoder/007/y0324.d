import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto w = readln.split.to!(int[]);

  auto dpInit()
  {
    auto dp = new int[][](m+1, 2);
    foreach (j; 0..m+1)
      foreach (k; 0..2)
        dp[j][k] = -10^^9;
    return dp;
  }

  auto calc1()
  {
    auto dp = dpInit();
    dp[0][0] = 0;

    foreach (i; 1..n) {
      auto dp2 = dpInit();
      foreach (j; 0..m+1) {
        dp2[j][0] = max(dp2[j][0], dp[j][0], dp[j][1]);
        if (j < m)
          dp2[j+1][1] = max(dp2[j+1][1], dp[j][0], dp[j][1] + w[i-1]);
      }
      dp = dp2;
    }

    return max(dp[m][0], dp[m][1]);
  }

  auto calc2()
  {
    auto dp = dpInit();
    dp[1][1] = 0;

    foreach (i; 1..n) {
      auto dp2 = dpInit();
      foreach (j; 0..m+1) {
        dp2[j][0] = max(dp2[j][0], dp[j][0], dp[j][1]);
        if (j < m)
          dp2[j+1][1] = max(dp2[j+1][1], dp[j][0], dp[j][1] + w[i-1]);
      }
      dp = dp2;
    }

    return max(dp[m][0], dp[m][1] + w[n-1]);
  }

  if (m == 0)
    writeln(0);
  else
    writeln(max(calc1, calc2));
}
