import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long, n6 = n * 6;
  auto m = 8;

  auto dp = new long[][](m+1, n6+1);
  dp[0][0] = 1;

  foreach (i; 0..m)
    foreach (j; 0..n6+1)
      dp[i+1][j] = dp[i][max(j-n, 0)..j+1].sum;

  writeln(dp[$-1][$-1]);
}
