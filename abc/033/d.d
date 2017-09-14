import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

const eps = real(10) ^^ (-10);

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto x = new real[](n), y = new real[](n);
  foreach (i; 0..n) {
    auto rd = readln.split.to!(real[]);
    x[i] = rd[0];
    y[i] = rd[1];
  }

  auto don = 0L, cho = 0L;

  foreach (i; 0..n) {
    real[] a;
    foreach (j; 0..n)
      if (i != j)
        a ~= atan2(y[j]-y[i], x[j]-x[i]);
    a.sort();

    auto b = new real[]((n-1)*2);
    b[0..n-1] = a[0..$];
    foreach (j; 0..n-1)
      b[j+n-1] = b[j] + PI*2;
    auto bs = b.assumeSorted;

    foreach (j; 0..n-1) {
      auto c = bs.upperBound(a[j] + PI/2 - eps).lowerBound(a[j] + PI);
      if (!c.empty) {
        don += c.length;
        if ((c.front - a[j] - PI/2).abs < eps) {
          --don;
          ++cho;
        }
      }
    }
  }

  writeln(n*(n-1)*(n-2)/6-don-cho, " ", cho, " ", don);
}
