import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  auto direct(dchar c) {
    return c.predSwitch('N', point(0, -1), 'E', point(1, 0), 'W', point(-1, 0), 'S', point(0, 1));
  }

  writefln("%.3f", s.fold!((a, c) => a + direct(c))(point(0, 0)).hypot2.to!real.sqrt);
}

struct Point(T) {
  T x, y;

  point opBinary(string op)(point rhs) {
    static if (op == "+") return point(x + rhs.x, y + rhs.y);
  }

  T hypot2() { return x ^^ 2 + y ^^ 2; }
}

alias Point!int point;
