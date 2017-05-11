import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias Point!int point;

const maxX = 20000, maxY = 20000, gs = 20;
auto grid = Grid!(point[], int)(maxX / gs + 1, maxY / gs + 1);

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto r = 0;
  foreach (_; 0..n) {
    auto rd = readln.split.to!(int[]), p = point(rd[0], rd[1]), gp = p / gs;
    if (!isOverlap(p, gp)) {
      grid[gp] ~= p;
      ++r;
    }
  }

  writeln(r);
}

auto isOverlap(point p, point gp)
{
  foreach (q; grid.sibPoints8(gp).chain([gp]))
    foreach (tp; grid[q])
      if ((p - tp).hypot2 < 400) return true;
  return false;
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

  pure auto opIndex(Point!U p) const { return m[p.y][p.x]; }
  pure auto opIndex(size_t y) { return m[y]; }
  pure auto opIndex(size_t y, size_t x) const { return m[y][x]; }
  static if (isAssignable!T) {
    auto opIndexAssign(T v, Point!U p) { return m[p.y][p.x] = v; }
    auto opIndexAssign(T v, size_t y, size_t x) { return m[y][x] = v; }
    auto opIndexOpAssign(string op, V)(V v, Point!U p) { return mixin("m[p.y][p.x] " ~ op ~ "= v"); }
    auto opIndexOpAssign(string op, V)(V v, size_t y, size_t x) { return mixin("m[y][x] " ~ op ~ "= v"); }
  }
  pure auto validPoint(Point!U p) const { return p.x >= 0 && p.x < cols && p.y >= 0 && p.y < rows; }
  pure auto points() const { return rows.to!U.iota.map!(y => cols.to!U.iota.map!(x => Point!U(x, y))).joiner; }
  pure auto sibPoints4(Point!U p) const { return sibs4.map!(s => p + s).filter!(p => validPoint(p)); }
  pure auto sibPoints8(Point!U p) const { return sibs8.map!(s => p + s).filter!(p => validPoint(p)); }
}
