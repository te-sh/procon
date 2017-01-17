import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split;
  auto n = rd[0].to!size_t, v = rd[1].to!size_t;
  auto sx = rd[2].to!int - 1, sy = rd[3].to!int - 1;
  auto gx = rd[4].to!int - 1, gy = rd[5].to!int - 1;
  auto lij = n.iota.map!(_ => readln.split.to!(int[])).array;

  auto eij = new Edge!int[][](n ^^ 2);
  foreach (j; n.iota)
    foreach (i; n.iota) {
      auto p = point(j.to!int, i.to!int);
      foreach (sib; sibPoints) {
        auto np = p + sib;
        if (np.x >= 0 && np.y >= 0 && np.x < n && np.y < n)
          eij[p.x + p.y * n] ~= Edge!int(np.x + np.y * n, lij[np.y][np.x]);
      }
    }

  auto s = sx + sy * n;
  auto g = gx + gy * n;

  int calc()
  {
    auto qi = [s];
    auto dp = new int[](n ^^ 2);
    dp[] = -1;
    dp[s] = 0;

    for (auto r = 1; !qi.empty; ++r) {
      size_t[] ri;
      foreach (q; qi) {
        foreach (e; eij[q]) {
          auto nv = dp[q] + e.w;
          if (nv < v && (dp[e.v] < 0 || dp[e.v] > nv)) {
            if (e.v == g) return r;
            dp[e.v] = nv;
            ri ~= e.v;
          }
        }
      }
      qi = ri;
    }

    return -1;
  }

  writeln(calc);
}

struct Edge(T) {
  size_t v;
  T w;
}

struct Point(T) {
  T x, y;

  point opBinary(string op)(point rhs) {
    static if (op == "+") return point(x + rhs.x, y + rhs.y);
  }
}

alias Point!int point;

const auto sibPoints = [point(-1, 0), point(0, -1), point(1, 0), point(0, 1)];
