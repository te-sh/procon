import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto g = new size_t[][](n);
  auto c = new int[][](n);
  foreach (_; 0..n-1) {
    auto rd1 = readln.splitter;
    auto ai = rd1.front.to!size_t-1; rd1.popFront;
    auto bi = rd1.front.to!size_t-1; rd1.popFront;
    auto ci = rd1.front.to!int;
    g[ai] ~= bi; c[ai] ~= ci;
    g[bi] ~= ai; c[bi] ~= ci;
  }

  auto rd2 = readln.split.to!(size_t[]), q = rd2[0], k = rd2[1]-1;

  auto p = new size_t[](n), d = new long[](n);
  p[k] = n;

  auto queue = DList!size_t([k]);
  while (!queue.empty) {
    auto u = queue.front; queue.removeFront();
    foreach (v, ci; lockstep(g[u], c[u])) {
      if (p[u] != v) {
        p[v] = u;
        d[v] = d[u] + ci;
        queue.insertBack(v);
      }
    }
  }

  foreach (_; 0..q) {
    auto rd3 = readln.splitter;
    auto x = rd3.front.to!size_t-1; rd3.popFront();
    auto y = rd3.front.to!size_t-1;
    writeln(d[x] + d[y]);
  }
}
