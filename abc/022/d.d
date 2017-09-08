import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

alias point = Point!long;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto readPoints(size_t n)
  {
    auto p = new point[](n);
    foreach (i; 0..n) {
      auto rd = readln.split.to!(long[]), x = rd[0], y = rd[1];
      p[i] = point(x, y);
    }
    return p;
  }

  auto a = readPoints(n), b = readPoints(n);

  auto da = a.convexHull.convexDiameter2;
  auto db = b.convexHull.convexDiameter2;

  writefln("%.7f", (db.to!real / da.to!real).sqrt);
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

pure Point!T[] convexHull(T)(Point!T[] p)
{
  import std.algorithm, std.range;

  p.sort!"a.x == b.x ? a.y < b.y : a.x < b.x";

  Point!T[] lower;
  foreach (pi; p) {
    while (lower.length >= 2 && cross(lower[$-2] - pi, lower[$-1] - pi) <= 0)
      lower.length -= 1;
    lower ~= pi;
  }

  Point!T[] upper;
  foreach_reverse (pi; p) {
    while (upper.length >= 2 && cross(upper[$-2] - pi, upper[$-1] - pi) <= 0)
      upper.length -= 1;
    upper ~= pi;
  }

  return (lower.dropBackOne ~ upper.dropBackOne).array;
}

pure T convexDiameter2(T)(Point!T[] p)
{
  import std.algorithm;

  auto n = p.length;
  size_t ps, pt;
  foreach (i; 1..n) {
    if (p[i].y > p[ps].y) ps = i;
    if (p[i].y < p[pt].y) pt = i;
  }

  auto maxD = (p[ps] - p[pt]).hypot2;
  auto i = ps, j = pt;
  do {
    auto ni = (i + 1) % n, nj = (j + 1) % n;
    if (cross(p[ni] - p[i], p[nj] - p[j]) < 0)
      i = ni;
    else
      j = nj;
    maxD = max(maxD, (p[i] - p[j]).hypot2);
  } while (i != ps || j != pt);

  return maxD;
}

pure auto cross(T)(Point!T a, Point!T b)
{
  return a.x * b.y - a.y * b.x;
}
