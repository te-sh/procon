import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.split.to!(int[]);
  writeln(a.count(5) == 2 && a.count(7) == 1 ? "YES" : "NO");
}
