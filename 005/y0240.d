import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

alias Point!int point;
alias Grid!(bool, int) grid;

const maxWalk = 3, offset = 6;
const knightWalks = [point(-2,-1),point(-2,+1),point(-1,-2),point(-1,+2),
                     point(+1,-2),point(+1,+2),point(+2,-1),point(+2,+1)];

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), x = rd[0], y = rd[1];

  auto g = grid(offset * 2 + 1, offset * 2 + 1);
  struct QItem { point p; size_t len; }

  auto p0 = point(offset, offset);
  auto qi = new DList!QItem(QItem(p0, 0));
  g[p0] = true;

  while (!qi.empty) {
    auto q = qi.front; qi.removeFront();
    if (q.len < maxWalk) {
      foreach (dp; knightWalks) {
        auto np = q.p + dp;
        if (!g[np]) {
          g[np] = true;
          qi.insertBack(QItem(np, q.len+1));
        }
      }
    }
  }

  if (x < -offset || y < -offset || x > offset || y > offset)
    writeln("NO");
  else
    writeln(g[point(x + offset, y + offset)] ? "YES" : "NO");
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

struct Grid(T, U)
{
  import std.algorithm, std.conv, std.range, std.traits, std.typecons;

  const sibs4 = [Point!U(-1, 0), Point!U(0, -1), Point!U(1, 0), Point!U(0, 1)];
  const sibs8 = [Point!U(-1, 0), Point!U(-1, -1), Point!U(0, -1), Point!U(1, -1),
                 Point!U(1, 0), Point!U(1, 1), Point!U(0, 1), Point!U(-1, 1)];

  T[][] m;
  const size_t rows, cols;

  mixin Proxy!m;

  this(size_t r, size_t c) { rows = r; cols = c; m = new T[][](rows, cols); }
  this(T[][] s) { rows = s.length; cols = s[0].length; m = s; }

  pure auto dup() const { return Grid(m.map!(r => r.dup).array); }
  ref pure auto opIndex(Point!U p) { return m[p.y][p.x]; }
  ref pure auto opIndex(size_t y) { return m[y]; }
  ref pure auto opIndex(size_t y, size_t x) const { return m[y][x]; }
  static if (isAssignable!T) {
    auto opIndexAssign(T v, Point!U p) { return m[p.y][p.x] = v; }
    auto opIndexAssign(T v, size_t y, size_t x) { return m[y][x] = v; }
    auto opIndexOpAssign(string op, V)(V v, Point!U p) { return mixin("m[p.y][p.x] " ~ op ~ "= v"); }
    auto opIndexOpAssign(string op, V)(V v, size_t y, size_t x) { return mixin("m[y][x] " ~ op ~ "= v"); }
  }
  pure auto validPoint(Point!U p) { return p.x >= 0 && p.x < cols && p.y >= 0 && p.y < rows; }
  pure auto points() const { return rows.to!U.iota.map!(y => cols.to!U.iota.map!(x => Point!U(x, y))).joiner; }
  pure auto sibPoints4(Point!U p) { return sibs4.map!(s => p + s).filter!(p => validPoint(p)); }
  pure auto sibPoints8(Point!U p) { return sibs8.map!(s => p + s).filter!(p => validPoint(p)); }
}
