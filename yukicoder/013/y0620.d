import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.complex;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  foreach (_; 0..n) {
    auto rd = readln.splitter;
    auto t = rd.front.to!int; rd.popFront();
    auto p = rd.front.to!real; rd.popFront();
    auto w = rd.front.to!real; rd.popFront();
    auto v = rd.front.to!real; rd.popFront();
    auto gx = rd.front.to!real; rd.popFront();
    auto gy = rd.front.to!real; rd.popFront();
    calc(t, p, w, v, gx, gy);
  }
}

auto calc(int t, real p, real w, real v, real gx, real gy)
{
  auto g = complex!real(gx, gy), e = complex!real(1+v, w);

  auto a = new Complex!real[](t);
  a[$-1] = 1;
  foreach_reverse (i; 0..t-1) a[i] = a[i+1] * e;

  auto b = g - a[0] * e;
  auto d = a.map!(ai => ai.sqAbs).sum;

  foreach (i; 0..t) {
    auto u = a[i].conj / d * b;
    writefln("%.15f %.15f", u.re, u.im);
  }
}
