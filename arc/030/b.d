import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], x = rd1[1]-1;
  auto h = readln.split.to!(int[]);
  auto g = new int[][](n);
  foreach (i; 0..n-1) {
    auto rd2 = readln.split.to!(int[]), a = rd2[0]-1, b = rd2[1]-1;
    g[a] ~= b;
    g[b] ~= a;
  }

  auto p = new int[](n), sh = h.dup;
  p[x] = n;

  auto q = DList!int(x), s = SList!int();
  while (!q.empty) {
    auto u = q.front; q.removeFront();
    s.insertFront(u);
    foreach (v; g[u])
      if (v != p[u]) {
        p[v] = u;
        q.insertFront(v);
      }
  }

  while (!s.empty) {
    auto u = s.front; s.removeFront();
    foreach (v; g[u])
      if (v != p[u]) sh[u] += sh[v];
  }

  auto ans = 0;
  q.insertFront(x);
  while (!q.empty) {
    auto u = q.front; q.removeFront();
    foreach (v; g[u])
      if (v != p[u] && sh[v]) {
        ++ans;
        q.insertBack(v);
      }
  }

  writeln(ans*2);
}
