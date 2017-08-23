import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

alias Point!int point;
alias Grid!(int, int) igrid;
alias Grid!(bool, int) bgrid;

const ml = 1101;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), h = rd1[0], w = rd1[1];
  auto rd2 = readln.split.to!(int[]), a = rd2[0], ps = point(rd2[2], rd2[1]);
  auto rd3 = readln.split.to!(int[]), b = rd3[0], pg = point(rd3[2], rd3[1]);

  auto m = h.iota.map!(_ => readln.chomp.map!(c => c == '*' ? 1 : -1).array).array;
  auto gm = igrid(m);

  auto gv = new bgrid[](ml);
  foreach (i; 0..ml) gv[i] = bgrid(h, w);

  struct PL { point p; int l; }

  auto q = DList!PL(PL(ps, a));
  gv[a][ps] = true;

  while (!q.empty) {
    auto qi = q.front; q.removeFront();
    auto p = qi.p, l = qi.l;

    foreach (np; gm.sibPoints4(p)) {
      auto nl = l + gm[np];
      if (np == pg && nl == b) {
        writeln("Yes");
        return;
      }

      if (nl > 0 && nl < ml && !gv[nl][np]) {
        gv[nl][np] = true;
        q.insertBack(PL(np, nl));
      }
    }
  }

  writeln("No");
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
