import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto s = readln.chomp;

  auto children = new int[][](n);
  foreach (_; 0..n-1) {
    auto rd = readln.splitter;
    auto a = rd.front.to!int-1; rd.popFront();
    auto b = rd.front.to!int-1;
    children[a] ~= b;
    children[b] ~= a;
  }

  auto parent = new int[](n);
  parent[0] = -1;

  auto q = DList!int(0), st = SList!int();
  while (!q.empty) {
    auto u = q.front; q.removeFront();
    st.insertFront(u);
    foreach (v; children[u])
      if (v != parent[u]) {
        parent[v] = u;
        q.insertBack(v);
      }
  }

  auto dc = new int[](n), dw = new int[](n);

  while (!st.empty) {
    auto u = st.front; st.removeFront();
    dc[u] = s[u] == 'c';
    dw[u] = s[u] == 'w';
    foreach (v; children[u])
      if (v != parent[u]) {
        dc[u] += dc[v];
        dw[u] += dw[v];
      }
  }

  auto ans = 0L;
  foreach (u; 0..n)
    if (s[u] == 'w') {
      foreach (v; children[u])
        if (v != parent[u]) {
          ans += long(dc[v]) * (dw[0] - dw[v] - 1);
          ans += long(dw[v]) * (dc[0] - dc[u]);
        }
    }

  writeln(ans);
}
