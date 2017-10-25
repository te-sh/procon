import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

alias point = Point!int;
alias grid = Grid!(int, int);
static inf = 10^^5;

enum Field { Plane, Tree, Enemy }

alias fgrid = Grid!(Field, int);

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), r = rd[0], c = rd[1], k = rd[2];

  point village, temple, castle;

  auto f = fgrid(r, c);
  foreach (i; 0..r) {
    auto s = readln.chomp;
    foreach (j; 0..c) {
      auto p = point(j, i);
      switch (s[j]) {
      case '.': break;
      case 'T': f[p] = Field.Tree;  break;
      case 'E': f[p] = Field.Enemy; break;
      case 'S': village = p; break;
      case 'C': temple  = p; break;
      case 'G': castle  = p; break;
      default: assert(0);
      }
    }
  }

  ref auto bfs(point s)
  {
    auto g = new grid[](k+1);
    foreach (ki; 0..k+1) {
      g[ki] = grid(r, c);
      foreach (i; 0..r) g[ki][i][] = inf;
    }

    struct PD { point p; int d; }

    auto q = DList!PD(PD(s, 0));
    g[0][s] = 0;

    while (!q.empty) {
      auto qi = q.front; q.removeFront();
      auto p = qi.p, d = qi.d, nl = g[d][p] + 1;
      foreach (np; f.sibPoints4(p).filter!(np => f[p] != Field.Tree)) {
        switch (f[p]) {
        case Field.Plane:
          if (g[d][np] >= inf) {
            g[d][np] = nl;
            q.insertBack(PD(np, d));
          }
          break;
        case Field.Enemy:
          if (d < k && g[d+1][np] >= inf) {
            g[d+1][np] = nl;
            q.insertBack(PD(np, d+1));
          }
          break;
        case Field.Tree:
          break;
        default:
          assert(0);
        }
      }
    }

    return g;
  }

  auto gv = bfs(village), gt = bfs(temple), gc = bfs(castle);

  auto ans = int.max;
  foreach (i; 0..r)
    foreach (j; 0..c) {
      auto p = point(j, i), k2 = k - (f[p] == Field.Enemy ? 1 : 0);
      if (f[p] == Field.Tree) continue;
      foreach (kt; 1..k+1) {
        gv[kt][p] = min(gv[kt][p], gv[kt-1][p]);
        gc[kt][p] = min(gc[kt][p], gc[kt-1][p]);
        gt[kt][p] = min(gt[kt][p], gt[kt-1][p]);
      }

      foreach (kv; 0..k2+1)
        foreach (kc; 0..k2-kv+1) {
          auto kt = k2 - (kv + kc);
          ans = min(ans, gv[kv][p] + gc[kc][p] + gt[kt][p] * 2);
        }
    }

  writeln(ans >= inf ? -1 : ans);
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
