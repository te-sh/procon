import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split;
  auto n = rd[0].to!size_t, v = rd[1].to!long;
  auto o = point(rd[2].to!int - 1, rd[3].to!int - 1);
  auto lij = n.iota.map!(_ => readln.split.to!(int[])).array;

  auto gij = new Edge!long[][](n ^^ 2);
  foreach (j; n.iota)
    foreach (i; n.iota) {
      auto p = point(i.to!int, j.to!int);
      foreach (sib; sibPoints) {
        auto np = p + sib;
        if (np.x >= 0 && np.y >= 0 && np.x < n && np.y < n)
          gij[i + j * n] ~= Edge!long(np.x + np.y * n, lij[np.y][np.x]);
      }
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
