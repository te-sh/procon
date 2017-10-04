import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

alias point = Point!int;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto p = new point[](n);
  foreach (i; 0..n) {
    auto rd = readln.split.to!(int[]), x = rd[0], y = rd[1];
    p[i] = point(x, y);
  }

  auto r = 0;
  foreach (i; 0..n-1)
    foreach (j; i+1..n)
      r = max(r, (p[i]-p[j]).hypot2);

  writefln("%.4f", r.to!real.sqrt);
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
