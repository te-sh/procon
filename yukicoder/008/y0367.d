import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

alias Point!int point;
alias Grid!(bool, int) grid;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), h = rd[0], w = rd[1];
  auto red = grid(h, w), visit = new grid[](2);
  foreach (i; 0..2) visit[i] = grid(h, w);

  point s, g;
  foreach (i; 0..h)
    foreach (j, c; readln.chomp) {
      switch (c) {
      case 'S': s = point(j.to!int, i.to!int); break;
      case 'G': g = point(j.to!int, i.to!int); break;
      case 'R': red[i][j] = true; break;
      default: break;
      }
    }

  struct Qitem { point p; bool knight; int len; }

  auto q = DList!Qitem(Qitem(s, true, 0));
  visit[true][s] = true;

  while (!q.empty) {
    auto qi = q.front; q.removeFront();
    foreach (np; qi.knight ? red.sibPointsKnight(qi.p).array : red.sibPointsBishop(qi.p).array) {
      if (np == g) {
        writeln(qi.len + 1);
        return;
      }
      auto knight = qi.knight ^ red[np];
      if (!visit[knight][np]) {
        visit[knight][np] = true;
        q.insertBack(Qitem(np, knight, qi.len + 1));
      }
    }
  }

  writeln(-1);
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

  const sibsKnight = [Point!U(-1, -2), Point!U(-2, -1), Point!U(-1, 2), Point!U(-2, 1),
                      Point!U(1, 2), Point!U(2, 1), Point!U(1, -2), Point!U(2, -1)];
  const sibsBishop = [Point!U(-1, -1), Point!U(-1, 1), Point!U(1, 1), Point!U(1, -1)];

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
  pure auto sibPointsKnight(Point!U p) { return sibsKnight.map!(s => p + s).filter!(p => validPoint(p)); }
  pure auto sibPointsBishop(Point!U p) { return sibsBishop.map!(s => p + s).filter!(p => validPoint(p)); }
}
