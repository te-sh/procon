import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto pi = n.iota.map!(_ => readln.split.to!(int[])).map!(rd => point(rd[0], rd[1])).array;

  if (n == 0) {
    writeln(1);
    return;
  }

  auto dij = new int[][](n, n);
  foreach (i; 0..n)
    foreach (j; i+1..n)
      dij[i][j] = dij[j][i] = (pi[i] - pi[j]).hypot2;

  auto uf = UnionFind!size_t(n);
  foreach (i; 0..n)
    foreach (j; i+1..n)
      if (i != j && dij[i][j] <= 100)
        uf.unite(i, j);

  auto maxD = uf.groups
      .map!(g => dij.indexed(g).map!(di => di.indexed(g)).joiner.fold!max)
      .fold!max;
  writefln("%.7f", maxD.to!real.sqrt + 2);
}

alias Point!int point;

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

struct Point(T) {
  T x, y;

  point opBinary(string op)(point rhs) {
    static if (op == "-") return point(x - rhs.x, y - rhs.y);
  }

  T hypot2() { return x ^^ 2 + y ^^ 2; }
}
