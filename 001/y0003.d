import std.algorithm, std.conv, std.range, std.stdio, std.string;
import core.bitop;    // bit operation

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  writeln(calc(n));
}

auto calc(int n)
{
  if (n == 1) return 1;

  auto dp = new bool[](n + 1);
  dp[1] = true;

  auto a = [1];

  for (auto c = 1; !a.empty; ++c) {
    int[] b = [];
    foreach (i; a) {
      auto e = i.popcnt;
      if (i + e <= n && !dp[i + e]) {
        if (i + e == n) return c + 1;
        dp[i + e] = true;
        b ~= i + e;
      }
      if (i - e >= 1 && !dp[i - e]) {
        dp[i - e] = true;
        b ~= i - e;
      }
    }
    a = b;
  }

  return -1;
}
