import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

alias Point!int point;
alias sibPoints!int sibs;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), w = rd[0], h = rd[1];
  auto cij = Matrix!(immutable(char))(h.iota.map!(_ => readln.chomp).array);

  auto vij = Matrix!bool(h, w);
  foreach (y; h.iota) vij[y, 0] = vij[y, w-1] = true;
  foreach (x; w.iota) vij[0, x] = vij[h-1, x] = true;

  auto wij = Matrix!bool(h, w);

  auto availableSibs(point p) {
    return sibs.map!(a => p + a).filter!(np => wij.validIndex(np));
  }

  auto findEmpty() {
    foreach (y; 1..h-1)
      foreach (x; 1..w-1)
        if (cij[y, x] == '.' && !wij[y, x]) return point(x, y);
    return point(-1, -1);
  }

  auto distanceTo1(point s) {
    auto xij = Matrix!bool(h, w);
    xij[s] = true;

    point[] pi = [s];
    auto r = 1;
    while (!pi.empty) {
      point[] npi;
      foreach (p; pi) {
        foreach (np; availableSibs(p)) {
          if (wij[np]) return r;
          if (cij[np] != '#' || xij[np]) continue;
          xij[np] = true;
          npi ~= np;
        }
      }
      pi = npi;
      ++r;
    }
    return int.max;
  }

  auto s1 = findEmpty;
  vij[s1] = wij[s1] = true;

  auto qi1 = SList!point(s1);
  while (!qi1.empty) {
    auto p = qi1.front; qi1.removeFront;
    foreach (np; availableSibs(p)) {
      if (cij[np] != '.' || vij[np]) continue;
      vij[np] = wij[np] = true;
      qi1.insertFront(np);
    }
  }

  auto s2 = findEmpty;
  vij[s2] = true;

  auto r = int.max;
  auto qi2 = SList!point(s2);
  while (!qi2.empty) {
    auto p = qi2.front; qi2.removeFront;
    foreach (np; availableSibs(p)) {
      if (vij[np]) continue;
      vij[np] = true;
      if (cij[np] == '#')
        r = min(r, distanceTo1(np));
      else
        qi2.insertFront(np);
    }
  }

  writeln(r);
}

struct Point(T)
{
  T x, y;

  auto opBinary(string op: "+")(Point!T rhs) { return Point!T(x + rhs.x, y + rhs.y); }
  auto opBinary(string op: "-")(Point!T rhs) { return Point!T(x - rhs.x, y - rhs.y); }
}

const auto sibPoints(T) = [Point!T(-1, 0), Point!T(0, -1), Point!T(1, 0), Point!T(0, 1)];

struct Matrix(T)
{
  import std.typecons, std.traits;

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
}
