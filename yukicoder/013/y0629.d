import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto a = readln.split.to!(int[]);
  auto g = new int[][](n);
  foreach (_; 0..m) {
    auto rd2 = readln.split.to!(int[]), u = rd2[0]-1, v = rd2[1]-1;
    g[u] ~= v;
    g[v] ~= u;
  }

  foreach (i; 0..n) {
    auto b = a[i];
    auto c = a.indexed(g[i]);
    if (c.filter!(ci => ci < b).uniq.walkLength > 1 || c.filter!(ci => ci > b).uniq.walkLength > 1) {
      writeln("YES");
      return;
    }
  }

  writeln("NO");
}
