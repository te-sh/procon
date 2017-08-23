import point;

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

unittest
{
  import std.algorithm;

  alias Point!int point;

  auto m = Grid!(int, int)(2, 3);

  m[0][1] = 4;
  assert(m[0, 1] == 4);
  assert(m[point(1, 0)] == 4);

  m[point(1, 0)] = 5;
  m[0, 1] = 5;
  assert(m[0][1] == 5);
  assert(m[0][1] == 5);

  auto n = m.dup;
  m[0][1] = 6;
  assert(n[0][1] == 5);

  m[point(1, 0)] += 2;
  assert(m[0][1] == 8);
  m[0, 1] -= 2;
  assert(m[0][1] == 6);

  assert(m.points.equal([point(0, 0), point(1, 0), point(2, 0), point(0, 1), point(1, 1), point(2, 1)]));
  assert(m.sibPoints4(point(0, 0)).equal([point(1, 0), point(0, 1)]));
  assert(m.sibPoints8(point(0, 0)).equal([point(1, 0), point(1, 1), point(0, 1)]));
}
