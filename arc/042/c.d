import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], p = rd[1];
  struct Snack { int a, b; }
  auto snacks = new Snack[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int; rd2.popFront();
    auto b = rd2.front.to!int;
    snacks[i] = Snack(a, b);
  }
  snacks.sort!"a.a > b.a";

  auto pm = p + snacks[0].a;

  auto dp = new int[][](n+1, pm+1);
  dp[0][0] = 1;
  foreach (i, snack; snacks) {
    foreach (j; 0..pm+1) {
      dp[i+1][j] = dp[i][j];
      if (j >= snack.a && dp[i][j-snack.a])
        dp[i+1][j] = max(dp[i+1][j], dp[i][j-snack.a] + snack.b);
    }
  }

  auto ans = 0;
  foreach (i, snack; snacks)
    ans = max(ans, dp[i+1][0..p+snack.a+1].reduce!max);

  writeln(ans-1);
}
