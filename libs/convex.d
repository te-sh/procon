import point;

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

unittest
{
  import std.algorithm, std.range;

  alias Point!int point;
  auto pi = [ 4.iota.map!(i => point(0,i)).array,
              4.iota.map!(i => point(1,i)).array,
             10.iota.map!(i => point(2,i)).array,
              4.iota.map!(i => point(3,i)).array,
              5.iota.map!(i => point(4,i)).array,
              1.iota.map!(i => point(5,i+1)).array].joiner.array;

  assert(equal(convexHull(pi), [point(0,0), point(4,0), point(5,1), point(4,4), point(2,9), point(0,3)]));
  assert(convexHull(pi).convexDiameter2 == 85);
}
