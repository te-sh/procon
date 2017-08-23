import std.algorithm, std.conv, std.range, std.stdio, std.string;

const inf = 10 ^^ 9;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, m = rd[1].to!long;
  auto ai = readln.split.to!(int[]);
  auto ki = readln.split.to!(long[]);

  auto b = zip(ai, ki).map!"a[0] * a[1]".sum;
  if (b < m) {
    writeln(-1);
    return;
  }

  auto c = b - m;
  auto r = max((c - ai[$-1] ^^ 2) / ai[$-1], 0);
  c -= r * ai[$-1];

  auto dp = new int[][](n+1, c+1);
  foreach (ref dpi; dp) dpi[] = inf;
  dp[0][0] = 0;

  foreach (i; 0..n) {
    foreach (j; 0..c+1) {
      dp[i+1][j] = dp[i][j];
      if (j >= ai[i])
        dp[i+1][j] = min(dp[i+1][j], dp[i+1][j-ai[i]] + 1);
    }
  }

  auto s = dp[$-1][$-1];
  if (s == inf)
    writeln(-1);
  else
    writeln(r + s);
}
