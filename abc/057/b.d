import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

alias point = Point!int;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto a = new point[](n), c = new point[](m);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(int[]), x = rd2[0], y = rd2[1];
    a[i] = point(x, y);
  }
  foreach (i; 0..m) {
    auto rd2 = readln.split.to!(int[]), x = rd2[0], y = rd2[1];
    c[i] = point(x, y);
  }

  foreach (ai; a) {
    auto minD = int.max, minI = size_t(0);
    foreach (j, ci; c) {
      auto p = ci - ai, d = p.x.abs + p.y.abs;
      if (d < minD) {
        minD = d;
        minI = j;
      }
    }
    writeln(minI+1);
  }
}

struct Point(T)
{
  T x, y;
  pure auto opBinary(string op: "+")(Point!T rhs) const { return Point!T(x + rhs.x, y + rhs.y); }
  pure auto opBinary(string op: "-")(Point!T rhs) const { return Point!T(x - rhs.x, y - rhs.y); }
  pure auto opBinary(string op: "*")(Point!T rhs) const { return x * rhs.x + y * rhs.y; }
  pure auto opBinary(string op: "*")(T a) const { return Point!T(x * a, y * a); }
  pure auto opBinary(string op: "/")(T a) const { return Point!T(x / a, y / a); }
  pure auto hypot2() const { return x ^^ 2 + y ^^ 2; }
}
