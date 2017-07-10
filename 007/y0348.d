import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

alias Point!int point;
const emptyCell = -2, tbdCell = -1;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), r = rd[0], c = rd[1];

  auto g = Grid!(int, int)(r+2, c+2);
  foreach (i; 0..r) {
    auto s = readln.chomp;
    foreach (j; 0..c)
      g[i+1][j+1] = s[j].predSwitch('.', emptyCell, 'x', tbdCell);
  }
  foreach (i; 0..r+2) {
    g[i][0] = emptyCell;
    g[i][$-1] = emptyCell;
  }
  g[0][] = emptyCell;
  g[$-1][] = emptyCell;

  auto ringNo = 0;
  int[] rings = [];

  foreach (p; g.points) {
    if (g[p] == emptyCell || g[p] != tbdCell) continue;

    struct Qitem { point pp, cp; int len; }
    auto q = DList!Qitem(Qitem(point(-1, -1), p, 1));
    g[p] = ringNo;
    while (!q.empty) {
      auto qi = q.front; q.removeFront;
      foreach (np; g.sibPoints8(qi.cp).filter!(p => p != qi.pp)) {
        if (np == p) rings ~= qi.len;
        if (g[np] == tbdCell) {
          g[np] = ringNo;
          q.insertBack(Qitem(qi.cp, np, qi.len+1));
          break;
        }
      }
    }

    ++ringNo;
  }

  auto nr = rings.length;
  auto visited = Grid!(bool, int)(r+2, c+2);
  auto marked = new bool[](nr), tree = new int[][](nr+1);

  auto findMarked(point p)
  {
    foreach (np; g.sibPoints4(p))
      if (marked[g[np]])
        return g[np];
    assert(0);
  }

  foreach (p; g.points) {
    if (g[p] != emptyCell || visited[p]) continue;
    auto outer = p == point(0, 0) ? nr : findMarked(p);

    auto q = DList!point(p);
    visited[p] = true;
    while (!q.empty) {
      auto cp = q.front; q.removeFront();
      foreach (np; g.sibPoints4(cp)) {
        if (g[np] == emptyCell) {
          if (!visited[np]) {
            visited[np] = true;
            q.insertBack(np);
          }
        } else {
          auto ring = g[np];
          if (!marked[ring]) {
            tree[outer] ~= ring;
            marked[ring] = true;
          }
        }
      }
    }
  }

  auto dpa = new int[](nr), dpb = new int[](nr);
  auto t = SList!int();

  foreach (i; tree[nr]) {
    auto s = SList!int(i);
    while (!s.empty) {
      auto j = s.front; s.removeFront();
      t.insertFront(j);
      foreach (k; tree[j]) s.insertFront(k);
    }
  }

  while (!t.empty) {
    auto i = t.front; t.removeFront();
    dpa[i] = rings[i] + tree[i].map!(j => dpb[j]).sum;
    dpb[i] = tree[i].map!(j => max(dpa[j], dpb[j])).sum;
  }

  writeln(tree[nr].map!(i => max(dpa[i], dpb[i])).sum);
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
