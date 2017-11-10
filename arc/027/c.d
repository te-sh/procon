import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), x = rd1[0], y = rd1[1];
  y += x;
  auto n = readln.chomp.to!int;

  auto dp = new uint[][](y+1, n+1);
  dp[0][0] = 1;
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(int[]), t = rd2[0], h = rd2[1];
    foreach_reverse (j; t..y+1)
      foreach_reverse (k; 1..n+1)
        if (dp[j-t][k-1])
          dp[j][k] = max(dp[j][k], dp[j-t][k-1] + h);
  }

  auto ans = 0u;
  foreach (j; 1..y+1)
    foreach (k; 1..min(x, n)+1)
      ans = max(ans, dp[j][k]);

  writeln(ans-1);
}
