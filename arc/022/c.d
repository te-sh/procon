import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto g = new int[][](n);
  foreach (i; 0..n-1) {
    auto rd = readln.splitter;
    auto a = rd.front.to!int-1; rd.popFront();
    auto b = rd.front.to!int-1;
    g[a] ~= b;
    g[b] ~= a;
  }

  auto d = new int[](n), visited = new bool[](n);
  visited[0] = true;
  auto q = DList!int(0);
  while (!q.empty) {
    auto u = q.front; q.removeFront();
    foreach (v; g[u])
      if (!visited[v]) {
        d[v] = d[u] + 1;
        visited[v] = true;
        q.insertBack(v);
      }
  }

  auto ima = 0, ma = 0;
  foreach (i; 0..n)
    if (d[i] > ma) {
      ima = i;
      ma = d[i];
    }

  d[ima] = 0;
  visited[] = false;
  visited[ima] = true;
  q.insertBack(ima);
  while (!q.empty) {
    auto u = q.front; q.removeFront();
    foreach (v; g[u])
      if (!visited[v]) {
        d[v] = d[u] + 1;
        visited[v] = true;
        q.insertBack(v);
      }
  }

  auto jma = 0; ma = 0;
  foreach (j; 0..n)
    if (d[j] > ma) {
      jma = j;
      ma = d[j];
    }

  writeln(ima+1, " ", jma+1);
}
