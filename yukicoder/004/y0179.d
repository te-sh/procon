import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias Point!int point;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1];
  auto sij = Matrix!(immutable(char))(h.iota.map!(_ => readln.chomp).array);

  auto s = {
    foreach (p; sij.points!int)
      if (sij[p] == '#') return p;
    return point(-1, -1);
  }();

  if (s == point(-1, -1)) {
    writeln("NO");
    return;
  }

  auto canPaint(point p) {
    auto d = p - s;
    auto tij = Matrix!bool(h, w);
    tij[s] = tij[p] = true;
    foreach (ip; sij.points!int)
      if (sij[ip] == '#' && !tij[ip]) {
        auto np = d + ip;
        if (!sij.validIndex(np) || sij[np] != '#' || tij[np])
            return false;
          tij[ip] = tij[np] = true;
        }
    return true;
  }

  auto r = {
    foreach (y; s.y..h)
      foreach (x; 0..w) {
        auto p = point(x, y);
        if (s != p && sij[p] == '#' && canPaint(p))
          return true;
      }
    return false;
  }();

  writeln(r ? "YES" : "NO");
}

struct Point(T)
{
  T x, y;

  auto opBinary(string op: "+")(Point!T rhs) { return Point!T(x + rhs.x, y + rhs.y); }
  auto opBinary(string op: "-")(Point!T rhs) { return Point!T(x - rhs.x, y - rhs.y); }
}

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
