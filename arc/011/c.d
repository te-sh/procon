import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split, f = rd[0], l = rd[1];
  auto n = readln.chomp.to!int, n2 = n+2;
  auto s = new string[](n2);
  s[0] = f;
  s[n+1] = l;
  foreach (i; 0..n) s[i+1] = readln.chomp;

  if (f == l) {
    writeln(0);
    writeln(f);
    writeln(l);
    return;
  }

  auto g = new int[][](n2);
  foreach (i; 0..n2-1)
    foreach (j; i+1..n2)
      if (isNeighbor(s[i], s[j])) {
        g[i] ~= j;
        g[j] ~= i;
      }

  auto d = new int[](n2), inf = 10 ^^ 5;
  d[] = inf;
  d[n2-1] = 0;
  auto q = DList!int(n2-1);
  while (!q.empty) {
    auto u = q.front; q.removeFront();
    foreach (v; g[u])
      if (d[v] == inf) {
        d[v] = d[u] + 1;
        q.insertBack(v);
      }
  }

  if (d[0] == inf) {
    writeln(-1);
    return;
  }

  writeln(d[0]-1);
  writeln(s[0]);

  auto u = 0;
 loop: while (u != n2-1) {
    foreach (v; g[u]) {
      if (d[v] == d[u] - 1) {
        writeln(s[v]);
        u = v;
      }
    }
  }
}

auto isNeighbor(string s1, string s2)
{
  auto c = 0;
  foreach (i; 0..s1.length) {
    if (s1[i] != s2[i]) ++c;
    if (c >= 2) return false;
  }
  return c == 1;
}
