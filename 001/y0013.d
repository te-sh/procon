import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), w = rd[0], h = rd[1];
  auto mij = Grid!(int, int)(h.iota.map!(_ => readln.split.to!(int[])).array);

  auto vij = Grid!(bool, int)(h, w);

  bool wfs(point s)
  {
    auto q = SList!pointsCP(pointsCP(s, point(-1, -1)));
    vij[s] = true;

    while (!q.empty) {
      auto cp = q.front; q.removeFront;
      auto curr = cp.curr, prev = cp.prev;
      foreach (np; mij.sibPoints4(curr)) {
        if (np != prev && mij[curr] == mij[np]) {
          if (vij[np]) return true;
          vij[np] = true;
          q.insertFront(pointsCP(np, curr));
        }
      }
    }
    return false;
  }

  bool calc()
  {
    foreach (p; vij.points)
      if (!vij[p] && wfs(p))
        return true;

    return false;
  }

  writeln(calc ? "possible" : "impossible");
}

struct pointsCP
{
  point curr;
  point prev;
}

struct Point(T) {
  T x, y;

  point opBinary(string op)(point rhs) {
    static if (op == "+") return point(x + rhs.x, y + rhs.y);
  }
}

alias Point!int point;

struct Grid(T, U)
{
  import std.algorithm, std.conv, std.range, std.traits, std.typecons;

  const sibs4 = [Point!U(-1, 0), Point!U(0, -1), Point!U(1, 0), Point!U(0, 1)];

  T[][] m;
  const size_t rows, cols;

  mixin Proxy!m;

  this(size_t r, size_t c) { rows = r; cols = c; m = new T[][](rows, cols); }
  this(T[][] s) { rows = s.length; cols = s[0].length; m = s; }

  pure auto dup() const { return Grid(m.map!(r => r.dup).array); }
  pure auto opIndex(Point!U p) const { return m[p.y][p.x]; }
  pure auto opIndex(size_t y) { return m[y]; }
  pure auto opIndex(size_t y, size_t x) const { return m[y][x]; }
  static if (isAssignable!T) {
    auto opIndexAssign(T v, Point!U p) { return m[p.y][p.x] = v; }
    auto opIndexAssign(T v, size_t y, size_t x) { return m[y][x] = v; }
  }
  pure auto validPoint(Point!U p) const { return p.x >= 0 && p.x < cols && p.y >= 0 && p.y < rows; }
  pure auto points() const { return rows.to!U.iota.map!(y => cols.to!U.iota.map!(x => Point!U(x, y))).joiner; }
  pure auto sibPoints4(Point!U p) const { return sibs4.map!(s => p + s).filter!(p => validPoint(p)); }
}
