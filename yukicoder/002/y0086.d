import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto rd = readln.split.map!(to!size_t), n = rd[0], m = rd[1];
  auto aij = Matrix!bool(n.iota.map!(_ => readln.chomp.map!(c => c == '.').array).array);

  auto w = aij.joiner.count!"a";

  foreach (s; aij.points!int)
    foreach (di; 0..4) {
      if (calc(aij, s, di, w)) {
        writeln("YES");
        return;
      }
    }

  writeln("NO");
}

auto walk(Matrix!bool bij, point p, point d, point s) {
  auto c = 0;
  for (;;) {
    auto np = p + d;
    if (np == s) return Tuple!(int, point)(c + 1, s);
    if (!bij.validIndex(np) || !bij[np]) return Tuple!(int, point)(c, p);
    p = np;
    bij[p] = false;
    ++c;
  }
}

auto calc(Matrix!bool aij, point s, int di, size_t w) {
  auto bij = aij.dup;
  bij[s] = false;
  auto p = s;

  auto c = 0;
  foreach (t; 0..6) {
    auto d = sibPoints!int[di];

    auto wr = walk(bij, p, d, s), cr = wr[0], pr = wr[1];
    if (cr == 0) return false;

    c += cr;
    p = pr;

    if (p == s && c == w) return true;
    di = (di + 1) % 4;
  }

  return false;
}

alias Point!int point;

struct Point(T)
{
  T x, y;
  pure auto opBinary(string op: "+")(Point!T rhs) const { return Point!T(x + rhs.x, y + rhs.y); }
}

const sibPoints(T) = [Point!T(-1, 0), Point!T(0, 1), Point!T(1, 0), Point!T(0, -1)];

struct Matrix(T)
{
  import std.traits, std.typecons;

  T[][] m;
  const size_t rows, cols;

  mixin Proxy!m;

  this(size_t r, size_t c) { rows = r; cols = c; m = new T[][](rows, cols); }
  this(T[][] s) { rows = s.length; cols = s[0].length; m = s; }

  pure auto dup() const { return Matrix(m.map!(r => r.dup).array); }
  pure auto opIndex(U)(Point!U p) const { return m[p.y][p.x]; }
  pure auto opIndex(U)(U y) if (!is(U == Point!V, V)) { return m[y]; }
  pure auto opIndex(size_t y, size_t x) const { return m[y][x]; }
  static if (isAssignable!T) {
    auto opIndexAssign(U)(T v, Point!U p) { return m[p.y][p.x] = v; }
    auto opIndexAssign(T v, size_t y, size_t x) { return m[y][x] = v; }
  }
  pure auto validIndex(U)(Point!U p) const { return p.x >= 0 && p.x < cols && p.y >= 0 && p.y < rows; }
  pure auto points(U)() const { return rows.to!U.iota.map!(y => cols.to!U.iota.map!(x => Point!U(x, y))).joiner; }
}
