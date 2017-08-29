import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = new string[](n);
  foreach (i; 0..n) s[i] = readln.chomp;
  s.sort();
  auto g = s.group.array;
  g.sort!"a[1] > b[1]";
  writeln(g[0][0]);
}
