import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto x = new long[](n), y = new long[](n);
  foreach (i; 0..n) {
    auto rd = readln.split.to!(int[]), xi = rd[0], yi = rd[1];
    x[i] = xi;
    y[i] = yi;
  }

  auto ans = 0;
  foreach (i; 0..n-2)
    foreach (j; i+1..n-1)
      foreach (k; j+1..n) {
        auto x1 = x[i]-x[j], y1 = y[i]-y[j];
        auto x2 = x[i]-x[k], y2 = y[i]-y[k];
        auto s2 = x1*y2 - x2*y1;
        if (s2 != 0 && s2 % 2 == 0) ++ans;
      }

  writeln(ans);
}
