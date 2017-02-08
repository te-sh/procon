import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto t = readln.chomp.to!int;
  auto ai = readln.split.to!(int[]);

  auto dp = new bool[][](n + 1, t + 1);
  dp[n][t] = true;

  foreach_reverse (i; 0..n)
    foreach (j; 0..t+1)
      if (dp[i + 1][j]) {
        auto a = ai[i];
        if (j >= a) dp[i][j - a] = true;
        if (j % a == 0) dp[i][j / a] = true;
      }

  auto calc(size_t i, int acc) {
    if (i == n) return "";

    auto a = ai[i];
    if (acc + a <= t && dp[i + 1][acc + a]) return "+" ~ calc(i + 1, acc + a);
    if (acc * a <= t && dp[i + 1][acc * a]) return "*" ~ calc(i + 1, acc * a);

    return "E";
  }

  auto r = calc(1, ai.front);
  writeln(r);
}
