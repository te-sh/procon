import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!int, x = rd[1].to!uint;
  struct Edge { int v; uint c; }
  auto g = new Edge[][](n);
  foreach (i; 0..n-1) {
    auto rd2 = readln.splitter;
    auto u = rd2.front.to!int-1; rd2.popFront();
    auto v = rd2.front.to!int-1; rd2.popFront();
    auto c = rd2.front.to!uint;
    g[u] ~= Edge(v, c);
    g[v] ~= Edge(u, c);
  }

  auto parent = new int[](n), s = new uint[](n);
  auto q = DList!int(0);
  while (!q.empty) {
    auto u = q.front; q.removeFront();
    foreach (e; g[u])
      if (e.v != parent[u]) {
        parent[e.v] = u;
        s[e.v] = s[u] ^ e.c;
        q.insertBack(e.v);
      }
  }

  auto ss = s.sort();

  auto ans = 0L;
  foreach (i; 0..n) {
    auto r = ss.equalRange(s[i] ^ x).length;
    if (x == 0) --r;
    ans += r;
  }

  writeln(ans/2);
}
