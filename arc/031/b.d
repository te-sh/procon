import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

alias point = Point!int;
alias bgrid = Grid!(bool, int);

version(unittest) {} else
void main()
{
  auto n = 10, g = bgrid(n, n);
  foreach (i; 0..n) {
    auto s = readln.chomp;
    foreach (j; 0..n) g[i][j] = s[j] == 'o';
  }

  auto findLand(bgrid g)
  {
    foreach (i; 0..n)
      foreach (j; 0..n) {
        auto p = point(j, i);
        if (g[p]) return p;
      }
    assert(0);
  }

  auto isOneLand(bgrid g)
  {
    auto p0 = findLand(g);
    auto q = DList!point(p0), v = bgrid(n, n);
    v[p0] = true;
    while (!q.empty) {
      auto p = q.front; q.removeFront();
      foreach (np; g.sibPoints4(p).filter!(np => g[np]))
        if (!v[np]) {
          v[np] = true;
          q.insertBack(np);
        }
    }
    foreach (i; 0..n)
      foreach (j; 0..n)
        if (g[i][j] && !v[i][j])
          return false;
    return true;
  }

  foreach (i; 0..n)
    foreach (j; 0..n)
      if (!g[i][j]) {
        auto cg = g.dup;
        cg[i][j] = true;
        if (isOneLand(cg)) {
          writeln("YES");
          return;
        }
      }
  writeln("NO");
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
