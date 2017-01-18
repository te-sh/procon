import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10L ^^ 9 + 9;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;
  auto mi = t.iota.map!(_ => readln.chomp.to!long);

  auto ni = mi.map!"a / 111111".array;
  auto maxN = ni.fold!max;

  auto dp = new long[](maxN + 1);
  dp[0] = 1;

  foreach (c; 0..10) {
    auto cc = c == 0 ? 1 : c;
    foreach (i; cc..maxN+1)
      dp[i] = (dp[i] + dp[i - cc]) % mod;
  }

  foreach (n; ni) writeln(dp[n]);
}
