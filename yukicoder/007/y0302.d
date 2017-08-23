import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;
import std.mathspecial;

// allowable-error: 10 ** -5

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  auto rd = readln.split.to!(long[]), l = rd[0], r = rd[1];

  writefln("%.6f", n < 5000 ? calc1(n, l, r) : calc2(n, l, r));
}

auto calc1(long n, long l, long r)
{
  auto m = n * 6;

  auto dp1 = new real[](m+1);
  dp1[0] = 1; dp1[1..$] = 0;
  
  foreach (i; 1..n+1) {
    auto dp2 = new real[](m+1);
    dp2[] = 0;

    foreach (j; 1..m+1)
      dp2[j] = dp1[max(0, j-6)..j].sum / 6;

    dp1 = dp2;
  }

  return dp1[min(l, m)..min(r, m)+1].sum;
}

auto calc2(long n, long l, long r)
{
  auto u = 7.0 / 2 * n, s2 = 35.0 / 12 * n;
  return (erf((r+0.5 - u) / sqrt(s2 * 2)) - erf((l-0.5 - u) / sqrt(s2 * 2))) / 2;
}
