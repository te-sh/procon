import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

alias Point!int point;
alias Grid!(int, int) grid;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), h = rd1[0], w = rd1[1];
  auto a = h.iota.map!(_ => readln.split.to!(int[])).array;
  auto g = grid(a);

  auto q = readln.chomp.to!size_t, sameColor = false, lastColor = 0;
  foreach (_; 0..q) {
    auto rd2 = readln.split.to!(int[]), p = point(rd2[1]-1, rd2[0]-1), x = rd2[2];

    if (sameColor) {
      lastColor = x;
      continue;
    }

    if (g[p] == x) continue;

    g[p] = x;
    auto qu = new DList!point([p]), cnt = 1;

    while (!qu.empty) {
      auto qp = qu.front; qu.removeFront();
      foreach (np; g.sibPoints4(qp))
        if (g[np] != x) {
          g[np] = x;
          qu.insertBack(np);
          ++cnt;
        }
    }

    if (cnt == h * w) {
      sameColor = true;
      lastColor = x;
    }
  }

  if (sameColor) {
    foreach (i; 0..h)
      writeln(lastColor.repeat.take(w).array.to!(string[]).join(" "));
  } else {
    foreach (i; 0..h)
      writeln(g[i].to!(string[]).join(" "));
  }
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
