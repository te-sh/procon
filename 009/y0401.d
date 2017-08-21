import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias Point!int point;
alias Grid!(int, int) grid;

const dirs = [point(1, 0), point(0, 1), point(-1, 0), point(0, -1)];

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto g = grid(n, n), c = 1, p = point(0, 0), d = 0;

  while (c <= n*n) {
    g[p] = c++;
    auto np = p + dirs[d];
    if (!g.validPoint(np) || g[np]) {
      d = (d + 1) % 4;
      np = p + dirs[d];
    }
    p = np;
  }

  foreach (i; 0..n) {
    foreach (j; 0..n) {
      writef("%03d", g[i][j]);
      if (j < n-1) write(" ");
    }
    writeln;
  }
}

struct Point(T)
{
  T x, y;
  pure auto opBinary(string op: "+")(Point!T rhs) const { return Point!T(x + rhs.x, y + rhs.y); }
  pure auto opBinary(string op: "-")(Point!T rhs) const { return Point!T(x - rhs.x, y - rhs.y); }
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
