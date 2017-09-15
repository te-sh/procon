import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto dp = new int[](n);
  dp[1] = (a[1]-a[0]).abs;
  foreach (i; 2..n)
    dp[i] = min(dp[i-2]+(a[i]-a[i-2]).abs, dp[i-1]+(a[i]-a[i-1]).abs);

  writeln(dp[$-1]);
}
