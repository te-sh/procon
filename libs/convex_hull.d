import point;

Point!T[] convexHull(T)(Point!T[] pi)
{
  import std.algorithm, std.range;

  auto cross(Point!T a, Point!T b, Point!T o)
  {
    return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x);
  }

  pi.sort!"a.x == b.x ? a.y < b.y : a.x < b.x";

  Point!T[] lower;
  foreach (p; pi) {
    while (lower.length >= 2 && cross(lower[$-2], lower[$-1], p) <= 0) lower.length -= 1;
    lower ~= p;
  }

  Point!T[] upper;
  foreach_reverse (p; pi) {
    while (upper.length >= 2 && cross(upper[$-2], upper[$-1], p) <= 0) upper.length -= 1;
    upper ~= p;
  }

  return (lower.dropBackOne ~ upper.dropBackOne).array;
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
}
