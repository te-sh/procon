import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

alias Point!long point;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto pi = n.iota.map!(_ => readln.split.to!(int[])).map!(rd => point(rd[0], rd[1])).array;

  auto dij = new long[][](n, n);
  auto maxD = long(0);
  foreach (i; n.iota)
    foreach (j; n.iota) {
      dij[i][j] = (pi[i] - pi[j]).hypot2;
      maxD = max(maxD, dij[i][j]);
    }

  auto calc(long _, long a) {
    auto uf = new UnionFind!size_t(n);
    foreach (i; n.iota)
      foreach (j; n.iota)
        if (dij[i][j] <= a * a)
          uf.unite(i, j);
    return uf.find(0) == uf.find(n - 1);
  }

  auto r = iota(10L, maxD.to!real.sqrt.to!long + 20, 10L).assumeSorted!calc.upperBound(0);
  writeln(r.front);
}

struct Point(T) {
  T x, y;

  auto opBinary(string op: "+")(Point!T rhs) { return Point!T(x + rhs.x, y + rhs.y); }
  auto opBinary(string op: "-")(Point!T rhs) { return Point!T(x - rhs.x, y - rhs.y); }
  auto opBinary(string op: "*")(Point!T rhs) { return x * rhs.x + y * rhs.y; }
  auto opBinary(string op: "*")(T a) { return Point!T(x * a, y * a); }

  T hypot2() { return x ^^ 2 + y ^^ 2; }
}

class UnionFind(T) {
  T[] p; // parent
  T s; // sentinel

  this(T n) {
    p = new T[](n);
    s = n + 1;
    p[] = s;
  }

  T find(T i) {
    if (p[i] == s) {
      return i;
    } else {
      p[i] = find(p[i]);
      return p[i];
    }
  }

  void unite(T i, T j) {
    auto pi = find(i), pj = find(j);
    if (pi != pj) p[pj] = pi;
  }
}
