import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  auto dp = new bool[][](n + 1, 1 << 15);
  dp[0][1] = true;
  foreach (i, a; ai)
    foreach (j; 0..(1 << 15))
      if (dp[i][j]) {
        dp[i + 1][j] = true;
        dp[i + 1][j ^ a] = true;
      }

  writeln(dp[n].count!(a => a));
}
