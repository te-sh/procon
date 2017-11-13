import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto p = new int[](n);
  auto g = new int[][](n);
  foreach (u; 1..n) {
    auto v = readln.chomp.to!int;
    p[u] = v;
    g[v] ~= u;
  }

  auto c = new int[](n);
  foreach_reverse (u; 0..n) {
    c[u] = 1;
    foreach (v; g[u]) c[u] += c[v];
  }

  foreach (u; 0..n) {
    auto r = c[0] - c[u];
    foreach (v; g[u]) r = max(r, c[v]);
    writeln(r);
  }
}
