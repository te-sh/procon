import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto vi = readln.split.to!(int[]);

  auto dp = new ulong[][](n, 2);

  foreach (i, v; vi) {
    dp[i][0] = i >= 1 ? max(dp[i - 1][0], dp[i - 1][1]) : 0;
    dp[i][1] = v + max(i >= 1 ? dp[i - 1][0] : 0,
                       i >= 2 ? max(dp[i - 2][0], dp[i - 2][1]) : 0);
  }

  writeln(max(dp[n - 1][0], dp[n - 1][1]));
}
