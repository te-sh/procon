double integrate(double function(double) f, double lo, double hi, double eps = 1e-8)
{
  import std.math;

  const auto th = eps / 1e-14;

  double rec(double x0, double x6, double y0, double y6, int d)
  {
    const auto a = sqrt(2.0/3.0), b = 1.0 / sqrt(5.0);
    auto x3 = (x0+x6)/2, y3 = f(x3), h = (x6-x0)/2;
    auto x1 = x3-a*h, x2 = x3-b*h, x4 = x3+b*h, x5 = x3+a*h;
    auto y1 = f(x1), y2 = f(x2), y4 = f(x4), y5 = f(x5);
    auto i1 = (y0 + y6 + (y2 + y4) * 5) * (h/6);
    auto i2 = ((y0 + y6) * 77 + (y1 + y5) * 432 + (y2 + y4) * 625 + y3 * 672) * (h/1470);
    if (x3 + h == x3 || d > 50) return 0.0;
    if (d > 4 && th + (i1 - i2) == th) return i2;
    return rec(x0, x1, y0, y1, d+1) + rec(x1, x2, y1, y2, d+1) +
           rec(x2, x3, y2, y3, d+1) + rec(x3, x4, y3, y4, d+1) +
           rec(x4, x5, y4, y5, d+1) + rec(x5, x6, y5, y6, d+1);
  }

  return rec(lo, hi, f(lo), f(hi), 0);
}

unittest
{
  import std.math, std.stdio;

  assert((integrate((x) => 2 * x ^^ 3 - x ^^ 2 + 4, -2, 2) - 32.0/3.0).abs < 1e-11);
  assert((integrate((x) => (1 - x ^^ 2).sqrt, -1, 1) - PI/2).abs < 1e-11);
}
