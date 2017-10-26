import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1]/2;
  auto u = new int[](n);
  foreach (i; 0..n) u[i] = readln.chomp.to!int;

  struct Edge { size_t a, b; int c; }
  auto e = new Edge[][](n);
  foreach (i; 0..n-1) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!size_t; rd2.popFront();
    auto b = rd2.front.to!size_t; rd2.popFront();
    auto c = rd2.front.to!int;
    e[a] ~= Edge(a, b, c);
    e[b] ~= Edge(b, a, c);
  }

  auto parent = new size_t[](n);
  parent[0] = n;
  auto q = DList!size_t(0), s = SList!size_t();
  while (!q.empty) {
    auto a = q.front; q.removeFront();
    s.insertFront(a);
    foreach (ei; e[a])
      if (ei.b != parent[a]) {
        parent[ei.b] = a;
        q.insertBack(ei.b);
      }
  }

  auto dp = new int[][](n, m+1);
  while (!s.empty) {
    auto a = s.front; s.removeFront();
    dp[a][0] = u[a];
    foreach (ei; e[a])
      if (ei.b != parent[a])
        foreach_reverse (i; 0..m+1)
          if (dp[a][i])
            foreach_reverse (j; 0..m+1)
              if (dp[ei.b][j] && i+j+ei.c <= m)
                dp[a][i+j+ei.c] = max(dp[a][i+j+ei.c], dp[a][i] + dp[ei.b][j]);
  }

  writeln(dp[0].maxElement);
}
