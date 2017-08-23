import std.algorithm, std.conv, std.range, std.stdio, std.string;

const inf = 10 ^^ 9;

version(unittest) {} else
void main()
{
  auto c = readln.chomp.to!int;
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  ai = ai.sort().uniq.array;
  n = ai.length;

  auto dp = new int[](c+1);
  dp[] = inf;
  dp[0] = 0;

  foreach (i; 1..c+1)
    foreach (a; ai)
      if (i >= a)
        dp[i] = min(dp[i], dp[i-a] + 1);

  auto r = dp[$-1];
  writeln(r == inf ? -1 : r);
}
