import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.math;      // math functions

alias point = Point!int;
alias igrid = Grid!(int, int);
alias bgrid = Grid!(bool, int);

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), h = rd1[0], w = rd1[1];
  auto rd2 = readln.split.to!(int[]), sx = rd2[0]-1, sy = rd2[1]-1, gx = rd2[2]-1, gy = rd2[3]-1;
  auto ps = point(sy, sx), pg = point(gy, gx);

  auto ig = igrid(h, w);
  foreach (i; 0..h) {
    auto b = readln.chomp;
    foreach (j; 0..w)
      ig[i][j] = b[j] - '0';
  }

  auto q = DList!point(ps), bg = bgrid(h, w);
  bg[ps] = true;

  while (!q.empty) {
    auto p = q.front; q.removeFront();
    if (p == pg) {
      writeln("YES");
      return;
    }
    foreach (np; ig.sibPoints4(p).filter!(np => !bg[np]))
      if ((ig[p] - ig[np]).abs <= 1) {
        bg[np] = true;
        q.insertBack(np);
      }

    foreach (np; ig.sibPoints42(p).filter!(np => !bg[np]))
      if (ig[p] == ig[np] && ig[p] > ig[(p+np)/2]) {
        bg[np] = true;
        q.insertBack(np);
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
  const sibs42 = [Point!U(-2, 0), Point!U(0, -2), Point!U(2, 0), Point!U(0, 2)];
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
  pure auto sibPoints42(Point!U p) { return sibs42.map!(s => p + s).filter!(p => validPoint(p)); }
  pure auto sibPoints8(Point!U p) { return sibs8.map!(s => p + s).filter!(p => validPoint(p)); }
}
