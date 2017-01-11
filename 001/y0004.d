import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto wi = readln.split.to!(int[]);

  writeln(calc(n, wi) ? "possible" : "impossible");
}

auto calc(size_t n, int[] wi)
{
  auto sw = wi.sum;
  if (sw % 2 != 0) return false;
  sw /= 2;

  auto dp = new bool[](sw + 1);
  dp[0] = true;

  foreach (w; wi)
    foreach_reverse (i, ref d; dp)
      if (i >= w) d |= dp[i - w];

  return dp[sw];
}
