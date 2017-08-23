import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto vi = readln.split.to!(int[]);
  vi.sort();
  auto maxV = vi[$-1];

  auto r = int.max;
  foreach (a; 1..maxV+1)
    foreach (b; a..maxV+1)
      foreach (c; b..maxV+1) {
        auto d = calc(vi, [a, b, c]);
        if (d > 0)
          r = min(r, d);
      }

  writeln(r);
}

auto calc(int[] vi, int[] ai)
{
  auto dp = new int[](vi[$-1] + 1);
  dp[] = -1;
  dp[0] = 0;

  auto updateDp(int[] dp, int i, int a)
  {
    if (i >= a && dp[i - a] >= 0)
      return dp[i - a] + 1;
    else
      return -1;
  }

  foreach (i; 1..dp.length) {
    auto a = ai.map!(a => updateDp(dp, i.to!int, a)).filter!"a >= 0";
    if (!a.empty)
      dp[i] = a.fold!min;
  }

  auto ci = vi.map!(v => dp[v]);
  if (ci.all!"a >= 0")
    return ci.sum;
  else
    return -1;
}
