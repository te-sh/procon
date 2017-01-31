import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto pr = readln.split.to!(real[]), p = point(pr[0], pr[1], pr[2]);
  auto qi = n.iota
    .map!(_ => readln.split.to!(real[]))
    .map!(qr => point(qr[0], qr[1], qr[2]))
    .map!(q => q - p)
    .array;

  auto r = real(0);
  foreach (i; 0..n-2)
    foreach (j; i+1..n-1)
      foreach (k; j+1..n)
        r += calc(qi[i], qi[j], qi[k]);

  writefln("%.10f", r);
}

auto calc(point q1, point q2, point q3)
{
  auto n = outerProd(q2 - q1, q3 - q1);
  return (n * q1).abs / n.hypot2.sqrt;
}

struct Point3(T) {
  T x, y, z;

  auto opBinary(string op)(Point3!T rhs) {
    static if (op == "+") return Point3!T(x + rhs.x, y + rhs.y, z + rhs.z);
    else static if (op == "-") return Point3!T(x - rhs.x, y - rhs.y, z - rhs.z);
    else static if (op == "*") return x * rhs.x + y * rhs.y + z * rhs.z;
  }

  T hypot2() { return x ^^ 2 + y ^^ 2 + z ^^ 2; }
}

auto outerProd(T)(Point3!T p1, Point3!T p2)
{
  return Point3!T(p1.y * p2.z - p1.z * p2.y,
                  p1.z * p2.x - p1.x * p2.z,
                  p1.x * p2.y - p1.y * p2.x);
}

alias Point3!real point;
