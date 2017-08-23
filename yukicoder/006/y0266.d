import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto si = readln.split.to!(int[]);

  auto dp = new int[][](n+1, si.back+1);
  dp[0][0] = 1;

  foreach (i; 0..n+1)
    foreach (j; 0..si[i]+1) {
      if (i == 0 && j == 0) continue;

      if (i > 0 && j <= si[i-1])
        dp[i][j] = dp[i-1][j] + 1;
      else
        dp[i][j] = int.max;

      foreach (k; 0..j)
        dp[i][j] = min(dp[i][j], dp[i][k] + dp[i][j-k-1]);
    }

  writeln(dp[$-1].to!(string[]).join(" "));
}
