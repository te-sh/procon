import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split;
  auto n = rd[0].to!size_t, v = rd[1].to!long;
  auto o = point(rd[2].to!int - 1, rd[3].to!int - 1);
  auto lij = Matrix!int(n.iota.map!(_ => readln.split.to!(int[])).array);

  auto gij = new Edge!long[][](n ^^ 2);
  foreach (p; lij.points!int)
    foreach (sib; sibPoints) {
      auto np = p + sib;
      if (lij.validIndex(np))
        gij[p.x + p.y * n] ~= Edge!long(np.x + np.y * n, lij[np]);
    }

  writeln(calc(gij, o, v) ? "YES" : "NO");
}

auto calc(Edge!long[][] gij, point o, long v)
{
  auto n = gij.length;

  auto d1 = gij.dijkstra2(0, -1);
  if (v > d1[n - 1]) return true;

  if (o.x < 0 || o.y < 0) return false;

  auto oi = o.x + o.y * n.to!real.sqrt.to!int;

  if (v <= d1[oi]) return false;
  v = (v - d1[oi]) * 2;

  auto d2 = gij.dijkstra2(oi, -1);
  return d2[n - 1] < v;
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

struct Edge(T) {
  size_t v;
  T w;
}

T[] dijkstra2(T)(Edge!T[][] ai, size_t s, T inf = 0) {
  auto n = ai.length;
  auto di = new T[](n);
  di[] = inf;

  auto qi = heapify!("a.w > b.w")(Array!(Edge!T)());

  void addNext(Edge!T e) {
    auto v = e.v, w = e.w;
    di[v] = w;
    foreach (a; ai[v])
      if (di[a.v] == inf)
        qi.insert(Edge!T(a.v, w + a.w));
  }

  addNext(Edge!T(s, 0));
  while (!qi.empty) {
    auto e = qi.front; qi.removeFront;
    if (di[e.v] == inf) addNext(e);
  }

  return di;
}
