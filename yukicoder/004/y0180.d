import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = new long[](n), bi = new long[](n);
  foreach (i; n.iota) {
    auto rd = readln.split.to!(long[]);
    ai[i] = rd[0];
    bi[i] = rd[1];
  }

  auto f(long x) {
    auto ci = n.iota.map!(i => ai[i] + bi[i] * x);
    return ci.fold!max - ci.fold!min;
  }

  auto x0 = 1L, x3 = 2L, f0 = f(0);
  while (f(x3) < f0) x3 <<= 1;

  while (x3 - x0 >= 3) {
    auto x1 = (x3 - x0) / 3 + x0;
    auto x2 = (x3 - x0) * 2 / 3 + x0;
    if (f(x1) <= f(x2)) x3 = x2;
    else x0 = x1;
  }

  auto xm = (x3 - x0) / 2 + x0;
  if (f(x0) <= f(x3))
    writeln(f(x0) <= f(xm) ? x0 : xm);
  else
    writeln(f(xm) <= f(x3) ? xm : x3);
}
