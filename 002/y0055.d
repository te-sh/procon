import std.algorithm, std.conv, std.range, std.stdio, std.string;

const invalid = point(999, 999);

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]);
  auto p1 = point(rd[0], rd[1]), p2 = point(rd[2], rd[3]), p3 = point(rd[4], rd[5]);

  auto r1 = calc(p1, p2, p3), r2 = calc(p3, p1, p2), r3 = calc(p2, p3, p1);
  if (r1 != invalid)
    writeln(r1.x, " ", r1.y);
  else if (r2 != invalid)
    writeln(r2.x, " ", r2.y);
  else if (r3 != invalid)
    writeln(r3.x, " ", r3.y);
  else
    writeln(-1);
}

auto calc(point p1, point p2, point p3)
{
  auto v1 = p2 - p1, v2 = p3 - p2;

  if (v1.hypot2 != v2.hypot2 || v1.innerProd(v2) != 0)
    return invalid;

  return p1 + v2;
}

struct Point(T) {
  T x, y;

  point opBinary(string op)(point rhs) {
    static if (op == "+") return point(x + rhs.x, y + rhs.y);
    else static if (op == "-") return point(x - rhs.x, y - rhs.y);
  }

  T hypot2() {
    return x ^^ 2 + y ^^ 2;
  }

  T innerProd(Point!T p) {
    return x * p.x + y * p.y;
  }
}

alias Point!int point;
