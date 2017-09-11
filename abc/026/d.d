import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

const eps = real(10) ^^ (-6);

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(real[]), a = rd[0], b = rd[1], c = rd[2];

  auto mi = real(0), ma = real(201);
  for (;;) {
    auto mc = (mi + ma) / 2;
    auto f = a * mc + b * sin(PI * c * mc) - 100;
    if (f.abs < eps) {
      writefln("%.16f", mc);
      return;
    }
    if (f > 0) ma = mc;
    else       mi = mc;
  }
}
