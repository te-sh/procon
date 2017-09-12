import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto l = readln.split.to!(int[]);
  l.sort();
  writeln(l[0] == l[1] ? l[2] : l[0]);
}
