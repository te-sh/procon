import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias point = Point!int;
alias grid = Grid!(int, int);
const n = 19, thre = 5;

version(unittest) {} else
void main()
{
  auto g = grid(n+2, n+2);
  foreach (i; 0..n+2) g[i][] = -1;
  auto nb = 0, nw = 0;

  foreach (i; 0..n) {
    auto rd = readln.chomp;
    foreach (j; 0..n)
      switch (rd[j]) {
      case 'o':
        g[i+1][j+1] = 0;
        ++nb;
        break;
      case 'x':
        g[i+1][j+1] = 1;
        ++nw;
        break;
      case '.':
        g[i+1][j+1] = -1;
        break;
      default:
        assert(0);
      }
  }

  writeln(calc(g, nb, nw) ? "YES" : "NO");
}

auto calc(grid g, int nb, int nw)
{
  if (nb == 0 && nw == 0) return true;

  auto t = nb - nw;

  if (t < 0 || t > 1) return false;
  if (exists5(g, t)) return false;

  t = 1-t;

  foreach (i; 1..n+1)
    foreach (j; 1..n+1) {
      auto p = point(j, i);
      if (g[p] == t) {
        g[p] = -1;
        if (!exists5(g, t)) return true;
        g[p] = t;
      }
    }

  return false;
}

auto exists5(grid g, int t)
{
  auto inLine(point p, point di)
  {
    auto r = 0;
    for (; g[p] == t; p = p + di) ++r;
    return r;
  }

  auto d = [point(1, 0), point(1, 1), point(0, 1), point(-1, 1)];
  foreach (i; 1..n+1)
    foreach (j; 1..n+1) {
      auto p = point(j, i);
      foreach (di; d) {
        if (g[p] == t && g[p-di] != t) {
          auto r = inLine(p, di);
          if (r >= thre) return true;
        }
      }
    }

  return false;
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
