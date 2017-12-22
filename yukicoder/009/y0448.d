import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];
  auto t = new int[](n), d = new long[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    t[i] = rd2.front.to!int; rd2.popFront();
    d[i] = rd2.front.to!long;
  }

  auto canSolve(long x)
  {
    auto prev = -k.to!long;
    foreach (i; 0..n)
      if (d[i] > x) {
        if (t[i] - prev < k) {
          return false;
        } else {
          prev = t[i];
        }
      }
    return true;
  }

  auto bsearch = iota(d.maxElement+1).map!(x => tuple(x, canSolve(x))).assumeSorted!"a[1]<b[1]";
  auto dm = bsearch.upperBound(tuple(0, false)).front[0];

  writeln(dm);

  auto dp = new long[](n+1), prev = -k.to!long;
  foreach (i; 0..n) {
    auto j = t.assumeSorted.lowerBound(t[i]-k+1).length;
    if (d[i] > dm) {
      dp[i+1] = d[i] + dp[j];
      prev = t[i];
    } else {
      if (t[i] - prev < k) {
        dp[i+1] = dp[i];
      } else {
        dp[i+1] = max(dp[i], d[i] + dp[j]);
      }
    }
  }

  writeln(d.sum - dp[n]);
}
