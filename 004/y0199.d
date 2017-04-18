import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto pi = 5.iota.map!(_ => readln.split.to!(int[])).map!(rd => point(rd[0], rd[1])).array;
  writeln(convexHull(pi).length == 5 ? "YES" : "NO");
}

alias Point!int point;

struct Point(T)
{
  T x, y;
}

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
