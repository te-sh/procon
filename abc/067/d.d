// path: arc078_b

import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto edge = new size_t[][](n);
  auto parent = new size_t[](n);

  foreach (_; 0..n-1) {
    auto rd = readln.splitter;
    auto a = rd.front.to!size_t-1; rd.popFront();
    auto b = rd.front.to!size_t-1;
    edge[a] ~= b;
    edge[b] ~= a;
  }

  parent[0] = n;
  auto q = DList!size_t([0]), st = SList!size_t();
  while (!q.empty) {
    auto u = q.front; q.removeFront();
    st.insertFront(u);
    foreach (v; edge[u]) {
      if (parent[u] != v) {
        parent[v] = u;
        q.insertBack(v);
      }
    }
  }

  auto rt = new bool[](n), rtn = [n-1], c = n-1;
  while (c != 0) {
    rt[c] = true;
    c = parent[c];
    rtn ~= c;
  }
  rt[0] = true;
  auto nrtn = rtn.length;

  auto nodes = new int[](n);
  while (!st.empty) {
    auto u = st.front; st.removeFront();
    ++nodes[u];
    if (!rt[u]) nodes[parent[u]] += nodes[u];
  }

  auto n1 = nodes.indexed(rtn[0..nrtn/2]).sum;
  auto n2 = nodes.indexed(rtn[nrtn/2..$]).sum;
  if (n1 > n2)
    writeln("Snuke");
  else if (n1 < n2)
    writeln("Fennec");
  else if (nrtn % 2 == 0)
    writeln("Snuke");
  else
    writeln("Fennec");
}
