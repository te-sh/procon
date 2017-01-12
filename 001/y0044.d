import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto dp = new ulong[](n + 1);
  dp[0] = 1;
  dp[1] = 1;

  foreach (i; 2..n+1)
    dp[i] = dp[i - 2] + dp[i - 1];

  writeln(dp[n]);
}
