import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  mixin Geom!real;

  auto rd = readln.split.to!(real[]), c = rd[0], d = rd[1];
  auto l1 = Line(3.0/4, 2.0/7, -c);
  auto l2 = Line(1.0/4, 5.0/7, -d);
  auto p = intersect(l1, l2);
  if (p.x >= 0 && p.y >= 0)
    writefln("%.7f", p.x * 1000 + p.y * 2000);
  else if (p.y < 0)
    writefln("%.7f", d * 4 * 1000);
  else
    writefln("%.7f", c * 7 / 2 * 2000);
}

template Geom(T, T eps = T(10) ^^ (-10))
{
  import std.math;

  struct Point
  {
    T x, y;
    auto isNaN() { return x.isNaN || y.isNaN; }
  }

  struct Line
  {
    T a, b, c;
    auto isNaN() { return a.isNaN || b.isNaN || c.isNaN; }
  }

  auto dist(Point p1, Point p2)
  {
    return ((p1.x - p2.x) ^^ 2 + (p1.y - p2.y) ^^ 2).sqrt;
  }

  auto dist(Point p, Line l)
  {
    return (l.a * p.x + l.b * p.y + l.c).abs / (l.a ^^ 2 + l.b ^^ 2).sqrt;
  }

  auto intersect(Line l1, Line l2)
  {
    auto det = l1.a * l2.b - l1.b * l2.a;
    if (det.abs < eps) return Point(T.nan, T.nan);
    auto x = (l1.b * l2.c - l2.b * l1.c) / det;
    auto y = (l2.a * l1.c - l1.a * l2.c) / det;
    return Point(x, y);
  }

  auto bisector(Point p1, Point p2)
  {
    auto a = p2.x - p1.x;
    auto b = p2.y - p1.y;
    auto c = (p1.x ^^ 2 - p2.x ^^ 2 + p1.y ^^ 2 - p2.y ^^ 2) / 2;
    if (a.abs < eps && b.abs < eps) return Line(T.nan, T.nan, T.nan);
    return Line(a, b, c);
  }

  auto bisector(Line l1, Line l2)
  {
    auto d1 = (l1.a ^^ 2 + l1.b ^^ 2).sqrt;
    auto d2 = (l2.a ^^ 2 + l2.b ^^ 2).sqrt;

    Line[] r;

    auto a3 = l1.a * d2 - l2.a * d1;
    auto b3 = l1.b * d2 - l2.b * d1;
    auto c3 = l1.c * d2 - l2.c * d1;
    if (a3.abs >= eps || b3.abs >= eps) r ~= Line(a3, b3, c3);

    auto a4 = l1.a * d2 + l2.a * d1;
    auto b4 = l1.b * d2 + l2.b * d1;
    auto c4 = l1.c * d2 + l2.c * d1;
    if (a4.abs >= eps || b4.abs >= eps) r ~= Line(a4, b4, c4);

    return r;
  }
}
