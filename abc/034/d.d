import std.algorithm, std.conv, std.range, std.stdio, std.string;

const eps = real(10) ^^ (-10);

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], k = rd1[1];
  auto w = new real[](n), p = new real[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(real[]);
    w[i] = rd2[0].to!real;
    p[i] = rd2[1].to!real/100;
  }

  auto calc(real x)
  {
    auto t = new real[](n);
    foreach (i; 0..n)
      t[i] = w[i] * (p[i] - x);
    t.sort!"a > b";
    return t[0..k].sum;
  }

  struct XD { real x, d; }
  auto ans = iota(p.reduce!min, p.reduce!max + eps, eps)
    .map!(x => XD(x, calc(x)))
    .assumeSorted!"a.d > b.d"
    .upperBound(XD(0, 0))
    .front.x - eps;
  writefln("%.10f", ans * 100);
}
