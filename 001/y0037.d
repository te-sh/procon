import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!int;
  auto n = readln.chomp.to!size_t;
  auto ci = readln.split.to!(int[]);
  auto vi = readln.split.to!(int[]);

  auto halfs(int v)
  {
    int[] vi;
    for (auto u = v / 2; u > 0; u /= 2) vi ~= u;
    return vi;
  }

  foreach (i; n.iota) {
    auto nvi = halfs(vi[i]);
    auto nci = new int[](nvi.length);
    nci[] = ci[i];
    ci ~= nci;
    vi ~= nvi;
  }

  n = ci.length;

  auto dp = new int[](t + 1);
  foreach (c, v; lockstep(ci, vi))
    foreach_reverse (i; c..t+1)
      dp[i] = max(dp[i], dp[i - c] + v);

  writeln(dp.reduce!max);
}
