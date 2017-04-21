import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto pi = n.iota.map!(_ => readln.split.to!(int[])).map!(rd => point(rd[0], rd[1])).array;

  if (n == 0) {
    writeln(1);
    return;
  }

  auto minX = pi.map!"a.x".minElement;
  auto minY = pi.map!"a.y".minElement;
  foreach (ref p; pi) {
    p.x -= minX;
    p.y -= minY;
  }

  auto maxX = pi.map!"a.x".maxElement, maxBx = maxX / 10;
  auto maxY = pi.map!"a.y".maxElement, maxBy = maxY / 10;

  auto bucket = new size_t[][][](maxBy + 1, maxBx + 1);
  foreach (i, p; pi)
    bucket[p.y / 10][p.x / 10] ~= i;

  auto uf = UnionFind!size_t(n);
  foreach (i, p; pi)
    for (auto by = p.y / 10 - 1; by <= p.y / 10 + 1; ++by)
      for (auto bx = p.x / 10 - 1; bx <= p.x / 10 + 1; ++bx) {
        if (bx < 0 || bx > maxBx || by < 0 || by > maxBy) continue;
        foreach (ti; bucket[by][bx]) {
          if (i >= ti || (p - pi[ti]).hypot2 > 100) continue;
          uf.unite(i, ti);
        }
      }

  auto gi = new size_t[][](n);
  foreach (i; 0..n) gi[uf.find(i)] ~= i;

  auto gpi = gi.filter!"!a.empty".map!(g => pi.indexed(g).array.convexHull);
  auto maxD = 0;
  foreach (gp; gpi)
    foreach (i; 0..gp.length)
      foreach (j; i+1..gp.length)
        maxD = max(maxD, (gp[i] - gp[j]).hypot2);

  writefln("%.7f", maxD.to!real.sqrt + 2);
}

struct UnionFind(T)
{
  T[] p; // parent
  const T s; // sentinel

  this(T n)
  {
    p = new T[](n);
    s = n + 1;
    p[] = s;
  }

  T find(T i)
  {
    if (p[i] == s) {
      return i;
    } else {
      p[i] = find(p[i]);
      return p[i];
    }
  }

  void unite(T i, T j)
  {
    auto pi = find(i), pj = find(j);
    if (pi != pj) p[pj] = pi;
  }
}

struct Point(T)
{
  T x, y;
  pure auto opBinary(string op: "+")(Point!T rhs) const { return Point!T(x + rhs.x, y + rhs.y); }
  pure auto opBinary(string op: "-")(Point!T rhs) const { return Point!T(x - rhs.x, y - rhs.y); }
  pure auto opBinary(string op: "*")(Point!T rhs) const { return x * rhs.x + y * rhs.y; }
  pure auto opBinary(string op: "*")(T a) const { return Point!T(x * a, y * a); }
  pure auto hypot2() const { return x ^^ 2 + y ^^ 2; }
}

alias Point!int point;

Point!T[] convexHull(T)(Point!T[] pi)
{
  if (pi.length <= 2) return pi;

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
