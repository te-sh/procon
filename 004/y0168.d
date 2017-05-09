import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

alias Point!long point;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto pi = n.iota.map!(_ => readln.split.to!(int[])).map!(rd => point(rd[0], rd[1])).array;

  auto pli = new pointLen[](n * (n - 1) / 2);
  auto k = size_t(0);
  foreach (i; 0..n-1)
    foreach (j; i+1..n)
      pli[k++] = pointLen(i, j, (pi[i] - pi[j]).hypot2);

  pli.sort!"a.len2 < b.len2";

  auto calc() {
    auto uf = UnionFind!size_t(n);
    foreach (pl; pli) {
      uf.unite(pl.i, pl.j);
      if (uf.isSame(0, n - 1)) return pl.len2;
    }
    return 0L;
  }

  auto sq(long len2, long a) {
    return a * a >= len2;
  }

  auto len2 = calc;
  auto r = iota(10L, pli.back.len2.to!real.sqrt.to!long + 20, 10L).assumeSorted!sq.upperBound(len2);

  writeln(r.front);
}

struct pointLen {
  size_t i, j;
  long len2;
}

struct Point(T) {
  T x, y;

  auto opBinary(string op: "+")(Point!T rhs) { return Point!T(x + rhs.x, y + rhs.y); }
  auto opBinary(string op: "-")(Point!T rhs) { return Point!T(x - rhs.x, y - rhs.y); }
  auto opBinary(string op: "*")(Point!T rhs) { return x * rhs.x + y * rhs.y; }
  auto opBinary(string op: "*")(T a) { return Point!T(x * a, y * a); }

  T hypot2() { return x ^^ 2 + y ^^ 2; }
}

struct UnionFind(T)
{
  import std.algorithm, std.range;

  T[] p; // parent
  const T s; // sentinel
  const T n;

  this(T n)
  {
    this.n = n;
    p = new T[](n);
    s = n + 1;
    p[] = s;
  }

  T find(T i)
  {
    if (p[i] == s) {
      return i;
    } else {
      p[i] = find(p[i]);
      return p[i];
    }
  }

  void unite(T i, T j)
  {
    auto pi = find(i), pj = find(j);
    if (pi != pj) p[pj] = pi;
  }

  bool isSame(T i, T j) { return find(i) == find(j); }

  auto groups()
  {
    auto g = new T[][](n);
    foreach (i; 0..n) g[find(i)] ~= i;
    return g.filter!(l => !l.empty);
  }
}
