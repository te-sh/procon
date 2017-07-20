import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

const n = 41, unknown = 0, wall = 1, empty = 2;
alias Point!int point;
alias Grid!(int, int) igrid;
alias Grid!(bool, int) bgrid;

version(unittest) {} else
void main()
{
  auto g = igrid(n, n);
  auto p = point(n/2, n/2);
  auto d = point(0, -1), r = 0;

  int ask(string c)
  {
    import core.stdc.stdlib;
    if (c != "") {
      writeln(c); stdout.flush();
    }
    auto s = readln.chomp;
    if (s == "Merry Christmas!") exit(0);
    auto r = s.to!int;
    if (r == 20151224) ask("F");
    return r;
  }

  auto setKnown(point p, point d, int r) {
    foreach (i; 1..r+1) g[p + d * i] = empty;
    g[p + d * (r + 1)] = wall;
  }

  auto calcRoute(point p) {
    auto q = DList!(point[])(), v = bgrid(n, n);
    q.insertBack([p]);
    v[p] = true;
    while (!q.empty) {
      auto qi = q.front; q.removeFront();
      foreach (np; v.sibPoints4(qi.back)) {
        if (g[np] == unknown) return qi ~ np;
        if (g[np] == empty && !v[np]) {
          v[np] = true;
          q.insertBack(qi ~ np);
        }
      }
    }
    assert(0);
  }

  auto rot(ref point p, ref point d, point td)
  {
    while (d != td) {
      auto r = ask("L");
      d = d.predSwitch(point(0, -1), point(-1, 0), point(-1, 0), point(0, 1), point(0, 1), point(1, 0), point(1, 0), point(0, -1));
      setKnown(p, d, r);
    }
  }

  auto move(ref point p, ref point d, point[] route)
  {
    foreach (np; route[1..$]) {
      auto td = np - p;
      rot(p, d, td);
      if (g[p + d] == wall) return;
      auto r = ask("F");
      p = p + d;
      setKnown(p, d, r);
    }
  }

  g[p] = empty;
  r = ask("");
  setKnown(p, d, r);

  for (;;) {
    auto route = calcRoute(p);
    move(p, d, route);
  }
}

struct Point(T)
{
  T x, y;
  pure auto opBinary(string op: "+")(Point!T rhs) const { return Point!T(x + rhs.x, y + rhs.y); }
  pure auto opBinary(string op: "-")(Point!T rhs) const { return Point!T(x - rhs.x, y - rhs.y); }
  pure auto opBinary(string op: "*")(T a) const { return Point!T(x * a, y * a); }
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
