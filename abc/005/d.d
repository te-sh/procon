import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto s = new int[][][][](n, n, n, n), t = new int[](n*n+1);
  foreach (y; 0..n) {
    auto di = readln.split.to!(int[]);
    foreach (x; 0..n) {
      s[x][y][0][0] = di[x];
      t[1] = max(t[1], s[x][y][0][0]);
    }
  }

  foreach (y; 0..n)
    foreach (x; 0..n)
      foreach (u; 1..n-x) {
        s[x][y][u][0] = s[x][y][u-1][0] + s[x+u][y][0][0];
        t[u+1] = max(t[u+1], s[x][y][u][0]);
      }

  foreach (y; 0..n)
    foreach (x; 0..n)
      foreach (v; 1..n-y)
        foreach (u; 0..n-x) {
          s[x][y][u][v] = s[x][y][u][v-1] + s[x][y+v][u][0];
          t[(u+1)*(v+1)] = max(t[(u+1)*(v+1)], s[x][y][u][v]);
        }

  foreach (i; 2..n*n+1) t[i] = max(t[i-1], t[i]);

  auto q = readln.chomp.to!size_t;
  foreach (_; 0..q) {
    auto p = readln.chomp.to!int;
    writeln(t[p]);
  }
}
