import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

alias point = Point!int;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]);
  auto ta = point(rd1[0], rd1[1]), tb = point(rd1[2], rd1[3]), t = rd1[4], v = rd1[5];
  auto n = readln.chomp.to!size_t;
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(int[]);
    auto p = point(rd2[0], rd2[1]);

    auto d = (ta - p).hypot2.to!real.sqrt + (tb - p).hypot2.to!real.sqrt;
    if (d <= t * v) {
      writeln("YES");
      return;
    }
  }

  writeln("NO");
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
