import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), w = rd[0], h = rd[1];
  auto mij = Matrix!int(h.iota.map!(_ => readln.split.to!(int[])).array);

  auto vij = Matrix!bool(h, w);

  bool wfs(point s)
  {
    auto q = SList!pointsCP(pointsCP(s, point(-1, -1)));
    vij[s] = true;

    while (!q.empty) {
      auto cp = q.front; q.removeFront;
      auto curr = cp.curr, prev = cp.prev;
      foreach (sp; sibPoints) {
        auto np = curr + sp;
        if (mij.validIndex(np) && np != prev && mij[curr] == mij[np]) {
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
    foreach (p; vij.points!int)
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

const auto sibPoints = [point(-1, 0), point(0, -1), point(1, 0), point(0, 1)];

struct Matrix(T)
{
  import std.algorithm, std.conv, std.range, std.traits, std.typecons;

  T[][] m;
  size_t rows, cols;

  mixin Proxy!m;

  this(size_t r, size_t c) { rows = r; cols = c; m = new T[][](rows, cols); }
  this(T[][] s) { rows = s.length; cols = s[0].length; m = s; }

  auto opIndex(U)(U p) { static if (is(U == Point!V, V)) return m[p.y][p.x]; else return m[p]; }
  auto opIndex(size_t y, size_t x) { return m[y][x]; }
  static if (isAssignable!T) {
    auto opIndexAssign(U)(T v, Point!U p) { return m[p.y][p.x] = v; }
    auto opIndexAssign(T v, size_t y, size_t x) { return m[y][x] = v; }
  }
  auto validIndex(U)(Point!U p) { return p.x >= 0 && p.x < cols && p.y >= 0 && p.y < rows; }
  auto points(U)() { return rows.to!U.iota.map!(y => cols.to!U.iota.map!(x => Point!U(x, y))).joiner; }
}
