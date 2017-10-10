import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.bitmanip;  // BitArray

auto ma1 = 77*77*6;
auto ma2 = 77*6;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), a = rd1[0], t = rd1[1], k = rd1[2];
  auto n = new size_t[](a), c = new size_t[][](a);
  foreach (i; 0..a) {
    n[i] = readln.chomp.to!size_t;
    c[i] = readln.split.map!(rd2 => rd2.to!size_t-1).array;
  }
  auto m = readln.chomp.to!size_t;
  auto e = new Edge[](0);
  foreach (_; 0..m) {
    auto rd3 = readln.split, u = rd3[0].to!size_t-1, v = rd3[1].to!size_t-1, w = rd3[2].to!int;
    e ~= Edge(u, v, w);
  }

  auto b = new int[][](a, 77*6+1);

  foreach (i; 0..a) {
    auto cinv = new size_t[](t), c2 = new bool[](t);
    foreach (j, ci; c[i]) {
      cinv[ci] = j;
      c2[ci] = true;
    }

    auto e2 = new Edge[](0), scost = 0;
    foreach (ei; e)
      if (c2[ei.src] && c2[ei.dst]) {
        e2 ~= ei;
        scost += ei.cost;
      }
    auto ne2 = e2.length;

    foreach (j; 1..1<<ne2) {
      if (j.popcnt != n[i]-1) continue;
      auto e3 = new Edge[][](n[i]);
      foreach (e2i; e2.indexed(j.bitsSet)) {
        auto u = cinv[e2i.src], v = cinv[e2i.dst];
        e3[u] ~= Edge(u, v, e2i.cost);
        e3[v] ~= Edge(v, u, e2i.cost);
      }

      auto q = DList!size_t(0), visited = new bool[](n[i]), tcost = 0;
      visited[0] = true;
      while (!q.empty) {
        auto u = q.front; q.removeFront();
        foreach (e3i; e3[u]) {
          auto v = e3i.dst;
          if (!visited[v]) {
            tcost += e3i.cost;
            visited[v] = true;
            q.insertBack(v);
          }
        }
      }

      if (!visited.all!"a") continue;

      ++b[i][tcost];
    }
  }

  auto b2 = new int[][](a, 77*6+1), mar = 1L, mac = 0;
  foreach (i; 0..a) {
  }
}

struct Edge
{
  size_t src, dst;
  int cost;
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
