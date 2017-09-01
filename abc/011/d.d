import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

static real[] fact;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], d = rd1[1];
  auto rd2 = readln.split.to!(int[]), x = rd2[0], y = rd2[1];

  if (x % d != 0 || y % d != 0) {
    writeln(0);
    return;
  }

  x /= d; y /= d;

  fact = new real[](n+1);
  fact[0] = 1;
  foreach (i; 1..n+1) fact[i] = fact[i-1] * i;

  auto r = real(0);
  foreach (up; 0..n+1) {
    auto dn = up - y;
    if (dn < 0) continue;

    auto lt = n - 2 * up + x + y;
    if (lt % 2 != 0 || lt < 0) continue;
    lt /= 2;

    auto rt = n - 2 * up - x + y;
    if (rt % 2 != 0 || rt < 0) continue;
    rt /= 2;

    r += combi(n, up) * combi(n-up, dn) * combi(n-up-dn, lt);
  }

  writefln("%.10f", r / real(4) ^^ n);
}

auto combi(int n, int r)
{
  return fact[n] / fact[n-r] / fact[r];
}
