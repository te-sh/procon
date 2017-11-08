import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], m = rd[1];
  auto a = new int[](n);
  foreach (i; 0..n) a[i] = readln.chomp.to!int;

  auto dp = new long[int][](n);
  dp[0][a[0]] = 1;
  foreach (i; 1..n) {
    dp[i][a[i]] = 1;
    foreach (x; dp[i-1].byKey)
      dp[i][gcd(x, a[i])] += dp[i-1][x];
  }

  long[int] b;
  foreach (i; 0..n)
    foreach (x; dp[i].byKey)
      b[x] += dp[i][x];

  foreach (i; 0..m) {
    auto x = readln.chomp.to!int;
    writeln(x in b ? b[x] : 0);
  }
}
