import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), p = point(rd[0] * 2, rd[1] * 2);

  auto r2 = p.hypot2;
  auto l = max(0, r2.to!real.sqrt.floor.to!long * 2 - 2);
  for (; (l / 2) ^^ 2 <= r2; l += 2) {}
  writeln(l / 2);
}

struct Point(T) {
  T x, y;

  T hypot2() { return x ^^ 2 + y ^^ 2; }
}

alias Point!long point;
