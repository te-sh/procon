import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto ng = new int[](3);
  foreach (i; 0..3) ng[i] = readln.chomp.to!int;

  auto dp = new int[](n+1);
  foreach (i; 1..n+1) {
    if (ng.canFind(i)) {
      dp[i] = 101;
    } else {
      auto r = dp[i-1];
      if (i >= 2) r = min(r, dp[i-2]);
      if (i >= 3) r = min(r, dp[i-3]);
      dp[i] = r + 1;
    }
  }

  writeln(dp[n] <= 100 ? "YES" : "NO");
}
