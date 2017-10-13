import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

const eps = real(10) ^^ (-10);
mixin Geom!(real, eps);

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, m = rd1[1].to!size_t, r = rd1[2].to!real;
  auto lines = new Line[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(real[]), a = rd2[0], b = rd2[1], c = rd2[2];
    lines[i] = Line(a, b, c);
  }
  auto points = new Point[](m);
  foreach (i; 0..m) {
    auto rd3 = readln.split.to!(real[]), p = rd3[0], q = rd3[1];
    points[i] = Point(p, q);
  }

  Line[] c;

  foreach (i; 0..n-1)
    foreach (j; i+1..n)
      c ~= bisector(lines[i], lines[j]);

  foreach (i; 0..m-1)
    foreach (j; i+1..m) {
      auto ci = bisector(points[i], points[j]);
      if (!ci.isNaN) c ~= ci;
    }

  c ~= Line(0, 1, r);
  c ~= Line(0, 1, -r);
  c ~= Line(1, 0, r);
  c ~= Line(1, 0, -r);

  auto nc = c.length, ans = real(0);
  foreach (i; 0..nc-1)
    foreach (j; i+1..nc) {
      auto p = intersect(c[i], c[j]);
      if (p.isNaN || p.x > r || p.x < -r || p.y > r || p.y < -r) continue;

      auto r1 = lines.map!(line => dist(p, line)).reduce!min;
      auto r2 = points.map!(point => dist(p, point) ^^ 2).reduce!min;
      ans = max(ans, r1 + r2);
    }

  writefln("%.7f", ans);
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
